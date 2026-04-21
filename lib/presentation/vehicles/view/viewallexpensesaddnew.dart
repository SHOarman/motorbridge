import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_text_styles.dart';

class ViewAllExpensesAddNew extends StatefulWidget {
  const ViewAllExpensesAddNew({super.key});

  @override
  State<ViewAllExpensesAddNew> createState() => _ViewAllExpensesAddNewState();
}

class _ViewAllExpensesAddNewState extends State<ViewAllExpensesAddNew> {
  String selectedFilter = "Daily";

  Map<String, dynamic> get currentData {
    switch (selectedFilter) {
      case "Weekly":
        return {
          "total": "£12,450.00",
          "average": "£1,778.57",
          "entries": "7 total entries",
          "avgLabel": "Based on 7 days of data",
          "trend": "Weekly Spending Trend",
          "bars": [0.3, 0.5, 0.4, 0.8, 0.2, 0.6, 0.9],
          "date": "Week 14, 2026",
          "category": "Maintenance",
          "catAmount": "£8,200.00"
        };
      case "Monthly":
        return {
          "total": "£45,320.00",
          "average": "£1,510.66",
          "entries": "24 total entries",
          "avgLabel": "Based on 30 days of data",
          "trend": "Monthly Spending Trend",
          "bars": [0.6, 0.8, 0.4, 0.9],
          "date": "April 2026",
          "category": "Fuel & Servicing",
          "catAmount": "£30,100.00"
        };
      case "Yearly":
        return {
          "total": "£125,750.00",
          "average": "£10,479.16",
          "entries": "156 total entries",
          "avgLabel": "Based on 12 months of data",
          "trend": "Yearly Spending Trend",
          "bars": [0.4, 0.3, 0.5, 0.7, 0.9, 0.8],
          "date": "2026 Yearly",
          "category": "Full Fleet Costs",
          "catAmount": "£95,400.00"
        };
      default:
        return {
          "total": "£2050.00",
          "average": "£2050.00",
          "entries": "1 total entries",
          "avgLabel": "Based on 1 days of data",
          "trend": "Daily Spending Trend",
          "bars": [0.0, 0.0, 0.9, 0.0, 0.0],
          "date": "05 Apr 2026",
          "category": "Repairs",
          "catAmount": "£2050.00"
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    var data = currentData;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "Back to Vehicle",
                        style: AppTextStyles.smallText.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E68F5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.directions_car, color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "adxfgvafv - dafsgvad",
                                style: AppTextStyles.bigText.copyWith(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "2024",
                                style: AppTextStyles.smallText.copyWith(
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC000),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "ADGVADFV",
                          style: AppTextStyles.bigText.copyWith(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                        spreadRadius: -2,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 4),
                        blurRadius: 6,
                        spreadRadius: -1,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD1FAE5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.currency_pound, color: Color(0xFF059669), size: 20),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "Running Costs",
                              style: AppTextStyles.bigText.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            ElevatedButton.icon(
                              onPressed: () => _showAddCostDialog(context),
                              icon: const Icon(Icons.add, size: 18, color: Colors.white),
                              label: const Text("Add Cost", style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                elevation: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("View by:", style: AppTextStyles.smallText.copyWith(color: Colors.grey[600], fontSize: 13)),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  _buildFilterTab("Daily"),
                                  _buildFilterTab("Weekly"),
                                  _buildFilterTab("Monthly"),
                                  _buildFilterTab("Yearly"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSummaryCard(
                        color: const Color(0xFFECFDF5),
                        borderColor: const Color(0xFFD1FAE5),
                        icon: Icons.trending_up,
                        iconColor: const Color(0xFF059669),
                        title: "Total Running Costs",
                        titleColor: const Color(0xFF065F46),
                        amount: data['total'],
                        subtitle: data['entries'],
                        subtitleColor: const Color(0xFF059669),
                      ),
                      const SizedBox(height: 16),
                      _buildSummaryCard(
                        color: const Color(0xFFEEF2FF),
                        borderColor: const Color(0xFFE0E7FF),
                        icon: Icons.bar_chart,
                        iconColor: const Color(0xFF4F46E5),
                        title: "Average Daily Cost",
                        titleColor: const Color(0xFF3730A3),
                        amount: data['average'],
                        subtitle: data['avgLabel'],
                        subtitleColor: const Color(0xFF4F46E5),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.show_chart, color: Color(0xFF2563EB), size: 20),
                                const SizedBox(width: 10),
                                Text(
                                  data['trend'],
                                  style: AppTextStyles.bigText.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Container(
                              height: 300,
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(10, 20, 20, 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFFF1F5F9)),
                              ),
                              child: Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(height: 20, child: RotatedBox(quarterTurns: 3, child: Text("Amount (£)", style: TextStyle(fontSize: 10, color: Colors.grey)))),
                                      const Spacer(),
                                      _axisLabel("2200"), _axisLabel("1650"), _axisLabel("1100"), _axisLabel("550"), _axisLabel("0"),
                                      const SizedBox(height: 40),
                                    ],
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        const Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_GridLine(), _GridLine(), _GridLine(), _GridLine(), Divider(height: 1, color: Colors.grey)]),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: (data['bars'] as List).map((h) => _buildBar(h, data['date'])).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      _sectionTitle("Category Summary"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF1F2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFFFC9C9), width: 1),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.build_outlined, color: Color(0xFFE11D48), size: 20),
                              const SizedBox(width: 12),
                              Text(data['category'], style: AppTextStyles.smallText.copyWith(fontWeight: FontWeight.w600)),
                              const Spacer(),
                              Text(data['catAmount'], style: AppTextStyles.bigText.copyWith(fontSize: 18, color: const Color(0xFFE11D48))),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      _sectionTitle("Recent Expenses"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF1F2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFFFFC9C9), width: 1),
                                ),
                                child: const Icon(Icons.build_outlined, color: Color(0xFFE11D48), size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(data['category'], style: AppTextStyles.smallText.copyWith(fontWeight: FontWeight.w700)),
                                        Text(" - ${data['date']}", style: AppTextStyles.smallText.copyWith(fontSize: 12, color: Colors.grey)),
                                      ],
                                    ),
                                    Text("Vehicle", style: AppTextStyles.smallText.copyWith(fontSize: 12, color: Colors.grey)),
                                    const SizedBox(height: 4),
                                    Text(data['catAmount'], style: AppTextStyles.bigText.copyWith(fontSize: 18, color: const Color(0xFFE11D48))),
                                  ],
                                ),
                              ),
                              IconButton(icon: const Icon(Icons.delete_outline, color: Color(0xFFE11D48)), onPressed: () {}),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Text(title, style: AppTextStyles.bigText.copyWith(fontSize: 18, fontWeight: FontWeight.w700)),
    );
  }

  Widget _buildSummaryCard({required Color color, required Color borderColor, required IconData icon, required Color iconColor, required String title, required Color titleColor, required String amount, required String subtitle, required Color subtitleColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(icon, color: iconColor, size: 20), const SizedBox(width: 10), Text(title, style: AppTextStyles.smallText.copyWith(fontSize: 14, fontWeight: FontWeight.w600, color: titleColor))]),
            const SizedBox(height: 8),
            Text(amount, style: AppTextStyles.bigText.copyWith(fontSize: 32, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(subtitle, style: AppTextStyles.smallText.copyWith(fontSize: 12, color: subtitleColor)),
          ],
        ),
      ),
    );
  }

  Widget _axisLabel(String text) => Text(text, style: const TextStyle(fontSize: 10, color: Colors.grey));

  Widget _buildFilterTab(String title) {
    bool isSelected = selectedFilter == title;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedFilter = title),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(color: isSelected ? const Color(0xFF2563EB) : Colors.transparent, borderRadius: BorderRadius.circular(10)),
          child: Text(title, textAlign: TextAlign.center, style: AppTextStyles.smallText.copyWith(fontSize: 13, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500, color: isSelected ? Colors.white : const Color(0xFF64748B))),
        ),
      ),
    );
  }

  Widget _buildBar(double heightFactor, String date) {
    bool isPrimaryBar = heightFactor >= 0.8;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(height: 180 * heightFactor, margin: const EdgeInsets.symmetric(horizontal: 4), decoration: BoxDecoration(color: const Color(0xFF2563EB), borderRadius: BorderRadius.circular(6))),
          SizedBox(height: 40, child: isPrimaryBar ? Center(child: Transform.rotate(angle: -0.7, child: Text(date, style: const TextStyle(fontSize: 8, color: Colors.grey)))) : const SizedBox()),
        ],
      ),
    );
  }

  void _showAddCostDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add New Cost", style: AppTextStyles.bigText.copyWith(fontSize: 18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: InputDecoration(labelText: "Amount (£)", filled: true, fillColor: const Color(0xFFF1F5F9), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none))),
            const SizedBox(height: 16),
            TextField(decoration: InputDecoration(labelText: "Purpose", filled: true, fillColor: const Color(0xFFF1F5F9), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(onPressed: () => Get.back(), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)), child: const Text("Add", style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}

class _GridLine extends StatelessWidget {
  const _GridLine();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 1,
      child: CustomPaint(painter: _DashedLinePainter()),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 3, dashSpace = 3, startX = 0;
    final paint = Paint()..color = Colors.grey.withOpacity(0.1)..strokeWidth = 1;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}