import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/api_sevices/api_services.dart';
import '../../core/route/app_routes.dart';
import '../../core/services/controller/authcontroller.dart';

class GoogleLoginWebView extends StatefulWidget {
  const GoogleLoginWebView({super.key});

  @override
  State<GoogleLoginWebView> createState() => _GoogleLoginWebViewState();
}

class _GoogleLoginWebViewState extends State<GoogleLoginWebView> {
  late final WebViewController controller;
  bool isLoading = true;
  bool isLoginProcessed = false;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
            _checkUrlForToken(url);
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
            _checkUrl(url); // General check after page finish
          },
          onNavigationRequest: (NavigationRequest request) {
            if (_checkUrlForToken(request.url)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            if (change.url != null) {
              _checkUrlForToken(change.url!);
            }
          }
        ),
      )
      ..loadRequest(Uri.parse(ApiServices.oauthGoogle));
  }
  
  void _checkUrl(String url) async {
    _checkUrlForToken(url);
    
    // Some backends return JSON with token on a blank page instead of URL params
    if (!isLoginProcessed && url.contains(ApiServices.baseurl)) {
      try {
        final String htmlContent = await controller.runJavaScriptReturningResult('document.body.innerText') as String;
        // Check if the response contains json with token
        if (htmlContent.contains('token') || htmlContent.contains('accessToken')) {
           // We could try to parse json here but that's very speculative
           // Left here as a potential fallback entry point
        }
      } catch (e) {
        // ignore
      }
    }
  }

  bool _checkUrlForToken(String url) {
    if (isLoginProcessed) return true;
    
    // Look for token in query params or deep link format
    if (url.toLowerCase().contains('token=')) {
      try {
        Uri uri = Uri.parse(url);
        // Supports ?token=xyz or ?accessToken=xyz style redirect
        String? token = uri.queryParameters['token'] ?? uri.queryParameters['accessToken'];
        
        if (token != null && token.isNotEmpty) {
           _completeLogin(token);
           return true;
        }
      } catch (e) {
        debugPrint("Error parsing OAuth URL: $e");
      }
    }
    return false;
  }

  void _completeLogin(String token) async {
    isLoginProcessed = true;
    final authController = Get.isRegistered<AuthController>() 
        ? Get.find<AuthController>() 
        : Get.put(AuthController());
      
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setBool('isLoggedIn', true);
    
    authController.isLoggedIn.value = true;
    
    Get.snackbar("Success", "Google Login successful!", backgroundColor: Colors.green, colorText: Colors.white);
    Get.offAllNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Continue with Google", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.black12),
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  child: WebViewWidget(controller: controller),
                ),
                if (isLoading)
                  const Center(child: CircularProgressIndicator(color: Color(0xFF1B4E9F))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
