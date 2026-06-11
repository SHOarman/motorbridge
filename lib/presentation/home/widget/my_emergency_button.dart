import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/controller/home_controller.dart';

class MyEmergencyButton extends StatefulWidget {
  const MyEmergencyButton({super.key});

  @override
  State<MyEmergencyButton> createState() => _MyEmergencyButtonState();
}

class _MyEmergencyButtonState extends State<MyEmergencyButton> {
  double _scale = 1.0;
  final HomeController homeController = Get.find<HomeController>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  void _showAddContactDialog() {
    _nameController.clear();
    _numberController.clear();
    bool isSaving = false;
    
    Get.defaultDialog(
      title: "",
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      radius: 12,
      content: StatefulBuilder(
        builder: (context, setDialogState) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Emergency Contact Name",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff2D3436),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "example - insurance provider",
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Emergency Contact Number",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff2D3436),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _numberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "example - insurance contact number",
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isSaving
                        ? null
                        : () async {
                            if (_nameController.text.trim().isEmpty || _numberController.text.trim().isEmpty) {
                              Get.snackbar("Error", "Please fill all fields", backgroundColor: Colors.red, colorText: Colors.white);
                              return;
                            }
                            
                            setDialogState(() {
                              isSaving = true;
                            });
                            
                            bool success = await homeController.addEmergencyContact(
                              contactName: _nameController.text.trim(),
                              contactNumber: _numberController.text.trim(),
                            );
                            
                            if (success) {
                              Get.back();
                              Get.snackbar("Success", "Contact added successfully", backgroundColor: Colors.green, colorText: Colors.white);
                            } else {
                              setDialogState(() {
                                isSaving = false;
                              });
                              Get.snackbar("Error", "Failed to add contact", backgroundColor: Colors.red, colorText: Colors.white);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2664A3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isSaving
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            "Create Contact",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTapDown: (_) => setState(() => _scale = 0.96),
        onTapUp: (_) => setState(() => _scale = 1.0),
        onTapCancel: () => setState(() => _scale = 1.0),
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 100),
          child: Container(
            height: 48,
            width: 260,
            decoration: BoxDecoration(
              color: const Color(0xff2664A3),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(7),
                onTap: _showAddContactDialog,
                splashColor: Colors.white.withAlpha(51),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Add Emergency Contact",
                      style: TextStyle(
                        color: Color(0xffFFFFFF),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.add,
                      color: Color(0xffFFFFFF),
                      size: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
