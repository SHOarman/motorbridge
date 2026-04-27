import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/app_text_styles.dart';

class HelpAndTutorialView extends StatefulWidget {
  const HelpAndTutorialView({super.key});

  @override
  State<HelpAndTutorialView> createState() => _HelpAndTutorialViewState();
}

class _HelpAndTutorialViewState extends State<HelpAndTutorialView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 0),
            decoration: const BoxDecoration(
              color: Color(0xFF006D3E), // Dark green header
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.help_outline,
                            color: Colors.white,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Help & Tutorial",
                            style: AppTextStyles.bigText.copyWith(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Tab Bar
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelPadding: const EdgeInsets.only(bottom: 10),
                  labelStyle: AppTextStyles.smallText.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  unselectedLabelStyle: AppTextStyles.smallText.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withValues(alpha: 0.6),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: "Quick Start Tutorial"),
                    Tab(text: "FAQs"),
                  ],
                ),
              ],
            ),
          ),

          // Content Section
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildTutorialTab(), _buildFAQSTab()],
            ),
          ),
          // Bottom Footer
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        final Uri emailLaunchUri = Uri(
                          scheme: 'mailto',
                          path: 'support@motor-bridge.co.uk',
                        );
                        launchUrl(emailLaunchUri);
                      },
                      child: Text(
                        "support@motor-bridge.co.uk",
                        style: AppTextStyles.smallText.copyWith(
                          color: const Color(0xFF10B981),
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "Quick Start Tutorial",
                          style: AppTextStyles.smallText.copyWith(
                            color: const Color(0xFF64748B),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "FAQs",
                          style: AppTextStyles.smallText.copyWith(
                            color: const Color(0xFF64748B),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Close",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Welcome Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome to Your Virtual Garage",
                  style: AppTextStyles.bigText.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF004D40),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Let's get your journey started. Follow these simple steps to master the Motor Bridge UK experience and take full control of your automotive life.",
                  style: AppTextStyles.smallText.copyWith(
                    fontSize: 15,
                    color: const Color(0xFF004D40).withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF81C784),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.directions_car,
                      color: Color(0xFF1B5E20),
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Step 1: Add Vehicle
          _buildStepCard(
            step: "Step 1: Add Your First Vehicle",
            description:
                "Input your registration number and we'll automatically pull the technical specs and service history for your car.",
            accentColor: const Color(0xFF2196F3),
            icon: Icons.directions_car_filled_outlined,
            imagePath: "assets/icon/helpimage.png",
          ),

          const SizedBox(height: 24),

          // Step 2: Enable Notifications
          _buildStepCard(
            step: "Step 2: Enable Notifications",
            description:
                "Never miss an MOT or insurance renewal. Stay ahead with intelligent alerts tailored to your vehicle's specific needs.",
            accentColor: const Color(0xFFFB8C00),
            icon: Icons.notifications_none_rounded,
          ),

          const SizedBox(height: 24),

          // Step 3: Upload Documents
          _buildStepCard(
            step: "Step 3: Upload Your Documents",
            description:
                "Keep your digital V5C, insurance certificates, and service receipts in one secure, encrypted location.",
            accentColor: const Color(0xFF00C853),
            icon: Icons.cloud_done_outlined,
            extraContent: Row(
              children: [
                _buildMiniDocIcon(Icons.description_outlined),
                const SizedBox(width: 12),
                _buildMiniDocIcon(Icons.verified_user_outlined),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Step 4: Track Expenses
          _buildStepCard(
            step: "Step 4: Track Your Expenses",
            description:
                "Log fuel costs, maintenance fees, and parking to get a comprehensive view of your monthly automotive spending.",
            accentColor: const Color(0xFFE91E63),
            icon: Icons.payments_outlined,
          ),

          const SizedBox(height: 24),

          // Step 5: Customize
          _buildStepCard(
            step: "Step 5: Customize Your Experience",
            description:
                "Choose your preferred currency, units, and appearance mode. Motor Bridge UK adapts to how you drive.",
            accentColor: const Color(0xFF3F51B5),
            icon: Icons.tune_outlined,
          ),

          const SizedBox(height: 32),

          // Pro Tips Section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFDE7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFFF9C4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      color: Color(0xFFFBC02D),
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Pro Tips",
                      style: AppTextStyles.bigText.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF455A64),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildProTip(
                  "Check your dashboard regularly for urgent alerts about expiring documents",
                ),
                _buildProTip(
                  "Click on vehicle cards to access detailed information, documents, and expenses",
                ),
                _buildProTip(
                  "Set up your profile preferences to personalize how the app addresses you",
                ),
                _buildProTip(
                  "Your data is accessible from any device - just sign in with the same Google account",
                ),
                _buildProTip(
                  "Use the 'Reorder' button to customize the order your vehicles appear in the carousel and list",
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStepCard({
    required String step,
    required String description,
    required Color accentColor,
    required IconData icon,
    String? imagePath,
    Widget? extraContent,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xff2C2F300F),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: accentColor, size: 24),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      step,
                      style: AppTextStyles.bigText.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description,
                      style: AppTextStyles.smallText.copyWith(
                        fontSize: 14,
                        color: const Color(0xFF64748B),
                        height: 1.5,
                      ),
                    ),
                    if (extraContent != null) ...[
                      const SizedBox(height: 16),
                      extraContent,
                    ],
                    if (imagePath != null) ...[
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Center(
                          child: Image.asset(
                            imagePath,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(
                              height: 150,
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.directions_car,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniDocIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFECEFF1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: const Color(0xFF78909C), size: 20),
    );
  }

  Widget _buildProTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFFFBC02D),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: AppTextStyles.smallText.copyWith(
                fontSize: 14,
                color: const Color(0xFF546E7A),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String selectedFAQCategory = "All";
  String faqSearchQuery = "";

  final List<Map<String, String>> faqData = [
    {
      "category": "Getting Started",
      "question": "How do I add my first vehicle?",
      "answer": "Simply go to the Home screen and tap the 'Add Vehicle' button. Enter your registration number, and we'll handle the rest.",
    },
    {
      "category": "Getting Started",
      "question": "What information do I need to add a vehicle?",
      "answer": "Just your vehicle registration number! We'll pull technical specs, MOT history, and TAX status automatically.",
    },
    {
      "category": "Getting Started",
      "question": "How do I set up my profile?",
      "answer": "Go to the Profile tab and click 'Edit Profile'. You can upload a photo and set your preferred currency and contact details.",
    },
    {
      "category": "Notifications",
      "question": "How do I enable notifications?",
      "answer": "Ensure notifications are enabled in your phone settings and within the app's Settings menu. You'll then receive alerts for MOT, Tax, and Insurance.",
    },
    {
      "category": "Notifications",
      "question": "When will I receive expiry reminders?",
      "answer": "We typically notify you 30 days, 7 days, and 1 day before an important date expires to ensure you have plenty of time.",
    },
    {
      "category": "Notifications",
      "question": "What if I miss a notification?",
      "answer": "Don't worry! All active alerts are prominently displayed in the red 'Reminders' section on your dashboard until they are resolved.",
    },
    {
      "category": "Vehicle Management",
      "question": "How many vehicles can I add?",
      "answer": "Motor Bridge UK allows you to manage an unlimited number of vehicles in your virtual garage.",
    },
    {
      "category": "Vehicle Management",
      "question": "How do I edit vehicle details?",
      "answer": "Open your vehicle's profile and tap the 'Edit' icon. You can manually update nicknames, purchase dates, and mileage.",
    },
    {
      "category": "Vehicle Management",
      "question": "Can I delete a vehicle?",
      "answer": "Yes. In the vehicle details view, scroll to the bottom to find the option to permanently remove a vehicle from your garage.",
    },
    {
      "category": "Vehicle Management",
      "question": "Can I change the order my vehicles appear?",
      "answer": "Yes! Use the 'Reorder' button on the home screen carousel to drag and drop your vehicles into your preferred sequence.",
    },
    {
      "category": "Documents",
      "question": "How do I upload vehicle documents?",
      "answer": "Inside any vehicle's view, go to 'Documents' and click '+' to upload photos or PDF files of your V5C, insurance, or receipts.",
    },
    {
      "category": "Documents",
      "answer": "We take your privacy seriously. Your data is encrypted and stored securely following the highest industry standards.",
      "question": "Are my documents secure?",
    },
    {
      "category": "Documents",
      "question": "How do I view or download documents?",
      "answer": "Just tap on any document in your vault to view it. You can also use the share icon to export or print it as needed.",
    },
    {
      "category": "Expenses",
      "question": "How do I track vehicle expenses?",
      "answer": "Tap on your vehicle, then 'Expenses'. Click 'Add New' to log fuel, maintenance, or other costs with notes and amounts.",
    },
    {
      "category": "Expenses",
      "question": "What expense categories can I track?",
      "answer": "You can track Fuel, Maintenance, Insurance, Parking, Tolls, and Repairs. Each category provides its own spending analysis.",
    },
    {
      "category": "Expenses",
      "question": "Can I see my total running costs?",
      "answer": "Yes! The Expenses dashboard providing daily, weekly, monthly, and yearly summaries of all your automotive spending.",
    },
    // {
    //   "category": "Features",
    //   "question": "What is the information carousel?",
    //   "answer": "The top carousel on your home screen provides quick, actionable insights like 'All Documents Safe' or 'Action Required for MOT'.",
    // },
    {
      "category": "Features",
      "question": "What are the legal warnings about?",
      "answer": "The 'Motoring Emergencies' section provides vital legal and safety advice for handling breakdowns and accidents in the UK.",
    },
    {
      "category": "Features",
      "question": "Can I customize the app's appearance?",
      "answer": "Yes, you can toggle between Light and Dark modes in the Settings menu to match your preference.",
    },
    {
      "category": "Troubleshooting",
      "question": "Why aren't my notifications working?",
      "answer": "Check your device's background app refresh settings. Ensure Motor Bridge UK has permission to stay active for timely alerts.",
    },
    {
      "category": "Troubleshooting",
      "question": "My dates aren't showing correctly",
      "answer": "This usually happens due to a delay in data fetching from official sources. Try pulling down to refresh the page.",
    },
    {
      "category": "Troubleshooting",
      "question": "I can't see my documents after uploading",
      "answer": "Ensure you have a stable connection. If issues persist, try logging out and back in to re-sync your secure vault.",
    },
    {
      "category": "Accident Reports",
      "question": "How do I create an accident report?",
      "answer": "Tap the 'Accident Report' icon on the home screen. The wizard will guide you through capturing photos, witnesses, and party details step-by-step.",
    },
    {
      "category": "Accident Reports",
      "question": "Can I add photos to accident reports?",
      "answer": "Absolutely. You can upload multiple high-resolution photos of vehicle damage, number plates, and the general scene directly within the report.",
    },
    {
      "category": "Accident Reports",
      "question": "How do I share my accident report?",
      "answer": "Once a report is completed, you can export it as a professional PDF and share it with your insurance provider or legal representation via email.",
    },
    {
      "category": "Accident Reports",
      "question": "Can I edit an accident report after creating it?",
      "answer": "Yes, you can return to any saved report to add more details or photos as they become available. All changes are timestamped for accuracy.",
    },
    {
      "category": "Accident Reports",
      "question": "Where can I view my accident reports?",
      "answer": "Existing reports are stored in the 'Accident Reports' section accessible from the main dashboard or your vehicle's specific history log.",
    },
    {
      "category": "Accident Reports",
      "question": "What information should I include in an accident report?",
      "answer": "Try to capture the other party's registration, insurance details, contact info, witness statements, and clear photos of all vehicles involved.",
    },
  ];

  List<Map<String, String>> get filteredFAQs {
    return faqData.where((faq) {
      bool matchesCategory =
          selectedFAQCategory == "All" ||
          faq['category'] == selectedFAQCategory;
      bool matchesSearch =
          faqSearchQuery.isEmpty ||
          faq['question']!.toLowerCase().contains(
            faqSearchQuery.toLowerCase(),
          ) ||
          faq['answer']!.toLowerCase().contains(faqSearchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  Widget _buildFAQSTab() {
    final categories = [
      "All",
      "Getting Started",
      "Notifications",
      "Vehicle Management",
      "Documents",
      "Expenses",
      "Features",
      "Troubleshooting",
      "Account",
      "Accident Reports",
    ];

    return Column(
      children: [
        // Search & Category Header
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Frequently Asked Questions",
                style: AppTextStyles.bigText.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Find answers to common questions about using Motor Bridge UK",
                style: AppTextStyles.smallText.copyWith(
                  color: const Color(0xFF64748B),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) => setState(() => faqSearchQuery = value),
                  decoration: InputDecoration(
                    hintText: "Search for a question...",
                    hintStyle: AppTextStyles.smallText.copyWith(
                      color: const Color(0xFF94A3B8),
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF64748B),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Filter Chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories
                    .map((cat) => _buildCategoryChip(cat))
                    .toList(),
              ),
            ],
          ),
        ),

        // FAQ List
        Expanded(
          child: filteredFAQs.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 60, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        "No results found for \"$faqSearchQuery\"",
                        style: AppTextStyles.smallText.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemCount: filteredFAQs.length + 1, // Add 1 for the help card
                  itemBuilder: (context, index) {
                    if (index == filteredFAQs.length) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Need more help? Contact support at",
                              style: AppTextStyles.smallText.copyWith(color: const Color(0xFF2E7D32), fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            GestureDetector(
                              onTap: () {
                                final Uri emailLaunchUri = Uri(
                                  scheme: 'mailto',
                                  path: 'support@motor-bridge.co.uk',
                                );
                                launchUrl(emailLaunchUri);
                              },
                              child: Text(
                                "support@motor-bridge.co.uk",
                                style: AppTextStyles.smallText.copyWith(
                                  color: const Color(0xFF1B5E20),
                                  fontWeight: FontWeight.w800,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return _buildFAQItem(
                      filteredFAQs[index]['category']!,
                      filteredFAQs[index]['question']!,
                      filteredFAQs[index]['answer']!,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String title) {
    bool isSelected = selectedFAQCategory == title;
    return GestureDetector(
      onTap: () => setState(() => selectedFAQCategory = title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          title,
          style: AppTextStyles.smallText.copyWith(
            color: isSelected ? Colors.white : const Color(0xFF475569),
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildFAQItem(String category, String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent, // Disable splash to be 100% sure
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.toUpperCase(),
                style: AppTextStyles.smallText.copyWith(
                  color: const Color(0xFF10B981),
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                question,
                style: AppTextStyles.bigText.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          iconColor: const Color(0xFF94A3B8),
          collapsedIconColor: const Color(0xFF94A3B8),
          children: [
            Text(
              answer,
              style: AppTextStyles.smallText.copyWith(
                fontSize: 14,
                color: const Color(0xFF64748B),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
