import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

// Project specific imports
import 'package:motorbridge/core/route/app_routes.dart';
import 'package:motorbridge/general_widget/custom_bottom_nav_bar.dart';
import 'package:motorbridge/presentation/home/widget/add_vehicle_card.dart';
import 'package:motorbridge/presentation/home/widget/custom_action_button.dart';
import 'package:motorbridge/presentation/home/widget/custom_action_card.dart';
import 'package:motorbridge/utils/app_text_styles.dart';
import 'package:motorbridge/utils/app_sizes.dart';
import 'package:motorbridge/utils/app_colors.dart';
import '../../../core/services/controller/home_controller.dart';
import '../widget/vehiclecard.dart';
import 'helpandtutorial.dart';

final List<Map<String, String>> whyChooseData = [
  {
    "title": "Never Miss a Deadline",
    "desc": "Smart notifications remind you when your MOT, tax, insurance, or service is due. Stay legal and safe on UK roads without the stress of remembering dates.",
    "image": "assets/image/Rectangle 11.png",
    "icon": "assets/icon/activereminder.png",
  },
  {
    "title": "All Dates in One Place",
    "desc": "Track MOT expiry, road tax, insurance renewal, and service schedules for all your vehicles from a single dashboard. No more searching through emails or paperwork.",
    "image": "assets/image/Rectangle 11 (8).png",
    "icon": "assets/icon/uis_calender.png",
  },
  {
    "title": "Stay Road Legal",
    "desc": "Driving without valid MOT, tax, or insurance can result in fines up to £1,000, points on your licence, or even vehicle seizure. We keep you protected and compliant.",
    "image": "assets/image/Rectangle 11 (9).png",
    "icon": "assets/icon/image 3.png",
  },
  {
    "title": "Digital Document Storage",
    "desc": "Upload and store all your vehicle documents securely in the cloud. Access MOT certificates, insurance papers, and service records anytime, anywhere.",
    "image": "assets/image/Rectangle 11 (10).png",
    "icon": "assets/icon/calendar 1.png",
  },
  {
    "title": "Multi-Vehicle Management",
    "desc": "Whether you have a car, van, bike, or HGV, manage unlimited vehicles from one account. Perfect for families, car enthusiasts, or small businesses.",
    "image": "assets/image/Rectangle 11 (11).png",
    "icon": "assets/icon/calendar 1 (1).png",
  },
  {
    "title": "Access Anywhere",
    "desc": "Your virtual garage is accessible from any device. Check expiry dates on your phone while at the garage, or renew insurance from your laptop at home.",
    "image": "assets/image/Rectangle 11 (12).png",
    "icon": "assets/icon/calendar 1 (2).png",
  },
  {
    "title": "Track Running Costs",
    "desc": "Monitor all your vehicle expenses including fuel, servicing, MOT, insurance, and repairs. See your total spending and average costs per day, week, month, or year to understand your true cost of ownership.",
    "image": "assets/image/Rectangle 11 (13).png",
    "icon": "assets/icon/calendar 1 (3).png",
  },
];

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar("Error", "Could not launch $url");
    }
  }

  void showWhyChoosePopup(BuildContext context) {
    int currentIndex = 0;
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final imageHeight = sh * 0.20;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(
          horizontal: sw * 0.04,
          vertical: sh * 0.06,
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Slider area ────────────────────────────────────────
                SizedBox(
                  height: sh * 0.50,
                  child: PageView.builder(
                    itemCount: whyChooseData.length,
                    onPageChanged: (i) => setState(() => currentIndex = i),
                    itemBuilder: (context, index) {
                      final item = whyChooseData[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      style: AppTextStyles.bigText.copyWith(
                                        fontSize: sw * 0.052,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black,
                                      ),
                                      children: const [
                                        TextSpan(text: 'Why choose '),
                                        TextSpan(
                                          text: 'Motor Bridge\nUK?',
                                          style: TextStyle(color: Color(0xFF1B4E9F)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0F4FA),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Image.asset(
                                    item['icon']!,
                                    width: 26,
                                    height: 26,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: sh * 0.022),
                            // Blue feature card
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1B4E9F),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Image
                                    Container(
                                      margin: const EdgeInsets.all(12),
                                      height: imageHeight,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.asset(
                                        item['image']!,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // Title + description
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['title']!,
                                            style: AppTextStyles.bigText.copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            item['desc']!,
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTextStyles.smallText.copyWith(
                                              fontSize: 11.5,
                                              color: const Color(0xFFCDD8EC),
                                              height: 1.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // ── Page dots ──────────────────────────────────────────
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(whyChooseData.length, (i) {
                    final active = i == currentIndex;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: active ? 26 : 8,
                      decoration: BoxDecoration(
                        color: active ? const Color(0xFF1B4E9F) : const Color(0xFFD0DBF0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  }),
                ),

                // ── Social proof banner ────────────────────────────────
                const SizedBox(height: 14),
                Padding(
                  padding: EdgeInsets.fromLTRB(sw * 0.04, 0, sw * 0.04, 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F6FB),
                      borderRadius: BorderRadius.circular(14),
                      border:Border.all(
                        color: Color(0xffDDDDDD)
                      )
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 76,
                          height: 34,
                          child: Stack(
                            children: [
                              _stackedAvatar('assets/image/Ellipse 13.png', 0),
                              _stackedAvatar('assets/image/Ellipse 14.png', 22),
                              _stackedAvatar('assets/image/Ellipse 15.png', 44),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: AppTextStyles.smallText.copyWith(
                                fontSize: 12,
                                color: const Color(0xFF444444),
                              ),
                              children:  [
                                TextSpan(
                                  text: 'Thousands of UK Motorists ',
                                  style:AppTextStyles.internt.copyWith(
                                    
                                  fontSize:14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff1B4E9F)
                                    
                                  ),
                                ),
                                TextSpan(
                                  text: 'managing their vehicles smarter with Motor Bridge UK',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _stackedAvatar(String path, double left) {
    return Positioned(
      left: left,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // border: Border.all(color: Colors.white, width: 2),
        ),
        child: CircleAvatar(
          radius: 15,
          backgroundImage: AssetImage(path),
          backgroundColor: const Color(0xFFD0DBF0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppSizes(context);
    const Color primaryColor = Color(0xFF1B4E9F);

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 0),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(s.homeAppBarHeight),
        child: AppBar(
          backgroundColor: primaryColor,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              children: [
                Positioned(
                  right: -40,
                  top: -40,
                  child: Image.asset('assets/image/Image__3_-removebg-preview.png', width: 220),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                          child: Image.asset('assets/image/img.png', height: 40, fit: BoxFit.cover),
                        ),
                        const Spacer(),
                        const Text("Hi Tanvir", style: TextStyle(color: Colors.white, fontSize: 16)),
                        const SizedBox(height: 4),
                        const Text("Welcome to your", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        const Row(
                          children: [
                            Text("Virtual ", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                            Text("Garage", style: TextStyle(color: Colors.white54, fontSize: 26, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text("Bridging the gaps to smarter motoring.", style: TextStyle(color: Color(0xffEFEFEF), fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                const SizedBox(height: 110),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    decoration: const BoxDecoration(
                      color: Color(0xffFFFFFF),
                      borderRadius: BorderRadius.all(Radius.circular(9)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                          spreadRadius: 0,
                          blurStyle: BlurStyle.normal
                        )
                      ]
                     
                    ),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(18, 0, 18, MediaQuery.of(context).padding.bottom + 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AddVehicleCard(
                  title: "Add Your Vehicle To Your Virtual Garage",
                  imagePath: "assets/image/whitecar.png",
                  onAddPressed: () => Get.toNamed(AppRoutes.addvehicles),
                  subtitle: 'Add your vehicle, get timely reminders,\nand never miss an important date.',
                ),
                const SizedBox(height: 16),
                CustomActionCard(
                  title: "Why Choose Motorbridge",
                  bgColor: const Color(0x33000BE0),
                  contentColor: const Color(0xFF000BE0),
                  onTap: () => showWhyChoosePopup(context),
                  iconPath: 'assets/icon/Vector (2).png',
                ),
                const SizedBox(height: 10),
                CustomActionCard(
                  title: "Help & Tutorial",
                  bgColor: const Color.fromRGBO(0, 177, 0, 0.2),
                  contentColor: const Color(0xFF00B100),
                  onTap: () => Get.to(() => const HelpAndTutorialView()),
                  iconPath: 'assets/icon/Frame (5).png',
                ),
                const SizedBox(height: 30),
                CustomActionButton(
                  title: "Motoring Emergencies",
                  subtitle: "Quick access to emergency contact\n & insurance details",
                  iconPath: "assets/icon/Frame.svg",
                  bgColor: const Color(0xffBD1D1D),
                  contentColor: const Color(0xffFCFDFF),
                  onTap: () => Get.toNamed(AppRoutes.motoringemergencies),
                ),
                const SizedBox(height: 8),
                CustomActionButton(
                  title: "Visit Motor Bridge UK",
                  subtitle: "All of your motoring solutions",
                  iconPath: 'assets/icon/Frame (1).svg',
                  bgColor: const Color(0xFF283593),
                  contentColor: Colors.white,
                  iconAfterText: true,
                  onTap: () => _launchUrl("https://motor-bridge.co.uk/"),
                ),
                const SizedBox(height: 20),
                Text(
                  "Added Vehicles",
                  style: AppTextStyles.bigText.copyWith(fontSize: 22, fontWeight: FontWeight.w500, color: const Color(0xff525252)),
                ),
                const SizedBox(height: 10),
                VehicleCard(
                  hasBorder: true,
                  registrationTextColor: const Color(0xff000000),
                  vehicleName: "Hilux",
                  year: "2026",
                  engineCode: "2GD-FTV",
                  vehicleTag: "Vehicle 1",
                  registrationNumber: "AB12 CDE",
                  vehicleImage: "assets/image/Rectangle_2-removebg-preview.png",
                  onTagTap: () {},
                  onViewDetails: () => Get.toNamed(AppRoutes.vehicledetails),
                ),
                const SizedBox(height: 30),
                Text(
                  "Important: Motor Bridge UK is a reminder tool only. We accept no liability for missed renewals, fines, or any decisions made using this app. You are solely responsible for maintaining valid MOT, tax, and insurance. Always verify dates with official sources.",
                  style: AppTextStyles.smallText.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.subtleText,
                  ),
                ),
                const SizedBox(height: 15),
                Text("© 2026 Motor Bridge UK. All rights reserved.", style: AppTextStyles.smallText.copyWith(fontSize: 14, color: AppColors.subtleText)),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () => _launchUrl("https://motor-bridge.co.uk"),
                  child: Text(
                    "| motor-bridge.co.uk",
                    style: AppTextStyles.smallText.copyWith(
                      fontSize: 14,
                      color: AppColors.subtleText,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}