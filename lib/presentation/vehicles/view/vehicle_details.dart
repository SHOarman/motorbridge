import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:motorbridge/core/route/app_routes.dart';
import 'package:motorbridge/general_widget/customappbar.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:motorbridge/presentation/vehicles/widget/running_costs_card.dart';
import 'package:motorbridge/presentation/vehicles/widget/vehicle_documents_card.dart';
import 'package:motorbridge/utils/app_text_styles.dart';
import 'package:motorbridge/utils/app_sizes.dart';
import '../../reminders/widget/custom_text.dart';
import '../widget/custom_vehicle_field.dart';
import 'viewallexpensesaddnew.dart';
import '../../../core/services/api_sevices/api_services.dart';
import '../../../core/services/controller/home_controller.dart';

class VehicleDetails extends StatefulWidget {
  const VehicleDetails({super.key});

  @override
  State<VehicleDetails> createState() => _VehicleDetailsState();
}

class _VehicleDetailsState extends State<VehicleDetails> {
  late Map<String, dynamic> vehicle;
  bool isEditing = true;
  bool isSaving = false;

  late TextEditingController makeController;
  late TextEditingController modelController;
  late TextEditingController yearController;
  late TextEditingController regController;
  
  late TextEditingController engineSizeController;
  late TextEditingController vinController;
  late TextEditingController v5cController;
  late TextEditingController fuelTypeController;
  late TextEditingController bodyTypeController;
  late TextEditingController engineCodeController;

  @override
  void initState() {
    super.initState();
    vehicle = Get.arguments ?? {};
    
    makeController = TextEditingController(text: vehicle['make']?.toString() ?? '');
    modelController = TextEditingController(text: vehicle['model']?.toString() ?? '');
    yearController = TextEditingController(text: vehicle['year']?.toString() ?? '');
    regController = TextEditingController(text: vehicle['registration']?.toString() ?? '');
    
    engineSizeController = TextEditingController(text: vehicle['engineSize']?.toString() ?? '');
    vinController = TextEditingController(text: vehicle['vin']?.toString() ?? '');
    v5cController = TextEditingController(text: vehicle['v5cDocumentNumber']?.toString() ?? '');
    fuelTypeController = TextEditingController(text: vehicle['fuelType']?.toString() ?? '');
    bodyTypeController = TextEditingController(text: vehicle['bodyType']?.toString() ?? '');
    engineCodeController = TextEditingController(text: vehicle['engineCode']?.toString() ?? '');
  }

  @override
  void dispose() {
    makeController.dispose();
    modelController.dispose();
    yearController.dispose();
    regController.dispose();
    engineSizeController.dispose();
    vinController.dispose();
    v5cController.dispose();
    fuelTypeController.dispose();
    bodyTypeController.dispose();
    engineCodeController.dispose();
    super.dispose();
  }

  Future<void> saveVehicle() async {
    setState(() {
      isSaving = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String vehicleId = vehicle['id'] ?? vehicle['_id'] ?? '';
      
      final response = await http.patch(
        Uri.parse("${ApiServices.baseurl}/api/vehicle/$vehicleId"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "vin": vinController.text.trim(),
          "v5cDocumentNumber": v5cController.text.trim(),
          "fuelType": fuelTypeController.text.trim(),
          "bodyType": bodyTypeController.text.trim(),
          "engineSize": engineSizeController.text.trim(),
          "engineCode": engineCodeController.text.trim(),
        }),
      );

      print("Update vehicle status: ${response.statusCode}");
      print("Update vehicle response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Vehicle updated successfully!",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        
        var responseData = jsonDecode(response.body);
        if (responseData['data'] != null) {
          setState(() {
            vehicle = responseData['data'];
          });
        } else {
          setState(() {
            vehicle['vin'] = vinController.text.trim();
            vehicle['v5cDocumentNumber'] = v5cController.text.trim();
            vehicle['fuelType'] = fuelTypeController.text.trim();
            vehicle['bodyType'] = bodyTypeController.text.trim();
            vehicle['engineSize'] = engineSizeController.text.trim();
            vehicle['engineCode'] = engineCodeController.text.trim();
          });
        }

        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().fetchVehicles();
        }
      } else {
        Get.snackbar("Update Failed", "Server returned status: ${response.statusCode}",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Update Failed", "Something went wrong: $e",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  Map<String, dynamic> getBadgeStyles(String? status) {
    final s = status?.toLowerCase() ?? 'upcoming';
    if (s == 'expired') {
      return {
        'text': 'Expired',
        'bgColor': const Color(0xffDABBBB),
        'textColor': const Color(0xffA61B1B),
        'expiryColor': const Color(0xFFFF0000),
      };
    } else if (s == 'due_soon' || s == 'due soon') {
      return {
        'text': 'Due Soon',
        'bgColor': const Color(0xFFFFA500),
        'textColor': const Color(0xff3F2402),
        'expiryColor': const Color(0xFFFFA500),
      };
    } else {
      return {
        'text': 'Upcoming',
        'bgColor': const Color(0xffD1FADF),
        'textColor': const Color(0xff14B11C),
        'expiryColor': const Color(0xff14B11C),
      };
    }
  }

  Widget _buildVehicleImage(String imagePath) {
    if (imagePath.isEmpty) {
      return Image.asset("assets/image/Rectangle_2-removebg-preview.png", fit: BoxFit.contain);
    }
    
    if (imagePath.startsWith("http://") || imagePath.startsWith("https://")) {
      return Image.network(imagePath, fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) {
        return Image.asset("assets/image/Rectangle_2-removebg-preview.png", fit: BoxFit.contain);
      });
    } else if (imagePath.startsWith("/uploads/")) {
      final String fullUrl = "https://9cx6xd5z-5000.inc1.devtunnels.ms$imagePath";
      return Image.network(fullUrl, fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) {
        return Image.asset("assets/image/Rectangle_2-removebg-preview.png", fit: BoxFit.contain);
      });
    } else {
      return Image.asset(imagePath, fit: BoxFit.contain);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppSizes(context);
    const Color primaryColor = Color(0xFF1B4E9F);

    final List<dynamic> gallery = vehicle['galleryImages'] is List ? vehicle['galleryImages'] : [];
    final String imgPath = gallery.isNotEmpty ? gallery[0].toString() : '';

    // Badges
    final motStyles = getBadgeStyles(vehicle['expiryStatus']?['motExpiry']?['status']?.toString());
    final taxStyles = getBadgeStyles(vehicle['expiryStatus']?['roadTaxExpiry']?['status']?.toString());
    final insStyles = getBadgeStyles(vehicle['expiryStatus']?['insuranceExpiry']?['status']?.toString());
    final srvStyles = getBadgeStyles(vehicle['expiryStatus']?['serviceDue']?['status']?.toString());
    final brkStyles = getBadgeStyles(vehicle['expiryStatus']?['breakdownCoverExpiry']?['status']?.toString());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: CustomAppBar(
        title: "Vehicle Details",
        backgroundImage: "assets/image/Image__3_-removebg-preview.png",
        leftIcon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 20,
        ),
        onLeftTap: () => Get.back(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: s.vehicleDetailImageHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xff9DBDEE),
                    width: 2,
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: _buildVehicleImage(imgPath),
                    ),
                    Positioned(
                      top: 15,
                      right: 15,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: const Color(0xffFFF4D0),
                        ),
                        child: Text(
                          "Vehicle 1",
                          style: AppTextStyles.smallText.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xffFDC209),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${vehicle['make'] ?? ''} ${vehicle['model'] ?? ''}",
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bigText.copyWith(
                        fontSize: 24,
                        color: const Color(0xff2A2A2A),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                "${vehicle['engineCode'] ?? ''}. ${vehicle['year'] ?? ''}",
                style: AppTextStyles.smallText.copyWith(
                  fontSize: 16,
                  color: const Color(0xff888888),
                ),
              ),
              
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xff141414),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(7),
                  color: const Color(0xffFDC209),
                ),
                child: Center(
                  child: Text(
                    vehicle['registration'] ?? '',
                    style: AppTextStyles.bigText.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff2A2A2A),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              CustomReminderCard(
                title: "MOT",
                date: vehicle['motExpiry'] ?? '',
                expiryStatus: vehicle['expiryStatus']?['motExpiry']?['label'] ?? '',
                vehicleName: motStyles['text'],
                buttonText: "Book Now",
                iconPath: 'assets/icon/Group (4).png',
                buttonIconPath: 'assets/icon/fluent_share-20-filled.png',
                backgroundColor: Colors.white,
                titleColor: const Color(0xff2A2A2A),
                dateColor: const Color(0xff888888),
                expiryTextColor: motStyles['expiryColor'],
                buttonColor: primaryColor,
                customButtonTextColor: Colors.white,
                badgeBackgroundColor: motStyles['bgColor'],
                badgeTextColor: motStyles['textColor'],
                borderColor: const Color(0xffCECECE),
                onButtonPressed: () {},
              ),
              const SizedBox(height: 10),
              CustomReminderCard(
                title: "Road Tax",
                date: vehicle['roadTaxExpiry'] ?? '',
                expiryStatus: vehicle['expiryStatus']?['roadTaxExpiry']?['label'] ?? '',
                vehicleName: taxStyles['text'],
                buttonText: "Pay Tax Online",
                iconPath: 'assets/icon/image 2.png',
                buttonIconPath: 'assets/icon/fluent_share-20-filled.png',
                backgroundColor: Colors.white,
                titleColor: const Color(0xff2A2A2A),
                dateColor: const Color(0xff888888),
                expiryTextColor: taxStyles['expiryColor'],
                buttonColor: primaryColor,
                customButtonTextColor: Colors.white,
                badgeBackgroundColor: taxStyles['bgColor'],
                badgeTextColor: taxStyles['textColor'],
                borderColor: const Color(0xffCECECE),
                onButtonPressed: () {},
              ),
              const SizedBox(height: 10),
              CustomReminderCard(
                title: "Insurance",
                date: vehicle['insuranceExpiry'] ?? '',
                expiryStatus: vehicle['expiryStatus']?['insuranceExpiry']?['label'] ?? '',
                vehicleName: insStyles['text'],
                buttonText: "Find Insurance",
                iconPath: 'assets/icon/image 3.png',
                buttonIconPath: 'assets/icon/fluent_share-20-filled.png',
                backgroundColor: Colors.white,
                titleColor: const Color(0xff2A2A2A),
                dateColor: const Color(0xff2A2A2A),
                expiryTextColor: insStyles['expiryColor'],
                buttonColor: primaryColor,
                customButtonTextColor: Colors.white,
                badgeBackgroundColor: insStyles['bgColor'],
                badgeTextColor: insStyles['textColor'],
                borderColor: const Color(0xffCECECE),
                onButtonPressed: () {},
              ),
              const SizedBox(height: 10),
              CustomReminderCard(
                title: "Service Due",
                date: vehicle['serviceDue'] ?? '',
                expiryStatus: vehicle['expiryStatus']?['serviceDue']?['label'] ?? '',
                vehicleName: srvStyles['text'],
                buttonText: "Book Now",
                iconPath: 'assets/icon/mdi_tools.png',
                buttonIconPath: 'assets/icon/fluent_share-20-filled.png',
                backgroundColor: Colors.white,
                titleColor: const Color(0xff2A2A2A),
                dateColor: const Color(0xff888888),
                expiryTextColor: srvStyles['expiryColor'],
                buttonColor: primaryColor,
                customButtonTextColor: Colors.white,
                badgeBackgroundColor: srvStyles['bgColor'],
                badgeTextColor: srvStyles['textColor'],
                borderColor: const Color(0xffCECECE),
                onButtonPressed: () {},
              ),
              const SizedBox(height: 10),
              CustomReminderCard(
                title: "Breakdown Cover",
                date: vehicle['breakdownCoverExpiry'] ?? '',
                expiryStatus: vehicle['expiryStatus']?['breakdownCoverExpiry']?['label'] ?? '',
                vehicleName: brkStyles['text'],
                buttonText: "Find Cover",
                iconPath: 'assets/icon/image 4.png',
                buttonIconPath: 'assets/icon/fluent_share-20-filled.png',
                backgroundColor: Colors.white,
                titleColor: const Color(0xff2A2A2A),
                dateColor: const Color(0xff888888),
                expiryTextColor: brkStyles['expiryColor'],
                buttonColor: primaryColor,
                customButtonTextColor: Colors.white,
                badgeBackgroundColor: brkStyles['bgColor'],
                badgeTextColor: brkStyles['textColor'],
                borderColor: const Color(0xffCECECE),
                onButtonPressed: () {},
              ),
              const SizedBox(height: 20),
              
              CustomVehicleField(
                label: "Engine Size",
                hintText: "e.g., 1998cc",
                controller: engineSizeController,
                readOnly: true,
              ),
              CustomVehicleField(
                label: "Vin Number",
                hintText: "e.g., WBA...",
                controller: vinController,
                readOnly: !isEditing,
              ),
              CustomVehicleField(
                label: "V5C Document Number",
                hintText: "e.g., Egne1221",
                controller: v5cController,
                readOnly: !isEditing,
              ),
              CustomVehicleField(
                label: "Fuel Type",
                hintText: "e.g., Petrol",
                controller: fuelTypeController,
                readOnly: true,
              ),
              CustomVehicleField(
                label: "Body Type",
                hintText: "e.g., Hatchback",
                controller: bodyTypeController,
                readOnly: !isEditing,
              ),
              CustomVehicleField(
                label: "Engine Number",
                hintText: "e.g., 2611",
                controller: engineCodeController,
                readOnly: !isEditing,
              ),
              
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isSaving ? null : () => saveVehicle(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isSaving ? "Saving..." : "Save Changes",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: isSaving ? null : () {
                    setState(() {
                      engineSizeController.text = vehicle['engineSize']?.toString() ?? '';
                      vinController.text = vehicle['vin']?.toString() ?? '';
                      v5cController.text = vehicle['v5cDocumentNumber']?.toString() ?? '';
                      fuelTypeController.text = vehicle['fuelType']?.toString() ?? '';
                      bodyTypeController.text = vehicle['bodyType']?.toString() ?? '';
                      engineCodeController.text = vehicle['engineCode']?.toString() ?? '';
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              RunningCostsCard(
                iconPath: "assets/icon/Icon (18).png",
                trendIconPath: "assets/icon/Icon (19).png",
                repairIconPath: "assets/icon/Icon (20).png",
                arrowIconPath: "assets/icon/Icon (21).png",
                onPressed: () => Get.to(() => const ViewAllExpensesAddNew()),
              ),
              const SizedBox(height: 20),
              VehicleDocumentsCard(
                onAddTap: () {
                  Get.toNamed(AppRoutes.addDocuments);
                },
                onViewTap: (String p1) {
                  debugPrint(p1);
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
