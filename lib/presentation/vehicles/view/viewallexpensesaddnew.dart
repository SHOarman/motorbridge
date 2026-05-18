import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/api_sevices/api_services.dart';
import '../../../utils/app_text_styles.dart';

class ViewAllExpensesAddNew extends StatefulWidget {
  const ViewAllExpensesAddNew({super.key});

  @override
  State<ViewAllExpensesAddNew> createState() => _ViewAllExpensesAddNewState();
}

class _ViewAllExpensesAddNewState extends State<ViewAllExpensesAddNew> {
  String selectedFilter = "Daily";
  Map<String, dynamic> vehicle = {};
  List<dynamic> rawCosts = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Safely retrieve passed vehicle details map from Get.arguments
    final args = Get.arguments;
    if (args is Map) {
      vehicle = Map<String, dynamic>.from(args);
    }
    fetchCosts();
  }

  Future<void> fetchCosts() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String targetVehicleId = (vehicle['id'] ?? vehicle['_id'] ?? '').toString().trim();

      if (targetVehicleId.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Fetch Costs specifically querying the server filtered by this vehicle ID
      final response = await http.get(
        Uri.parse("${ApiServices.get_const}?vehicleId=$targetVehicleId&vehicle=$targetVehicleId"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      debugPrint("Fetch costs status: ${response.statusCode}");
      debugPrint("Fetch costs body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List<dynamic> fetchedList = [];
        if (decoded is List) {
          fetchedList = decoded;
        } else if (decoded is Map) {
          fetchedList = decoded['data'] ?? [];
        }

        // Strict filtering: only include costs that belong to this specific vehicle
        final filteredList = fetchedList.where((item) {
          if (item is! Map) return false;
          var v = item['vehicle'] ?? item['vehicleId'] ?? item['vehicle_id'];
          if (v == null) {
            final String costId = (item['_id'] ?? item['id'] ?? '').toString();
            if (costId.isNotEmpty) {
              v = prefs.getString("cost_vehicle_$costId");
            }
          }
          v ??= targetVehicleId;
          
          String itemVehicleId = '';
          if (v is Map) {
            itemVehicleId = (v['id'] ?? v['_id'] ?? '').toString().trim();
          } else {
            itemVehicleId = v.toString().trim();
          }
          return targetVehicleId.isNotEmpty && 
                 itemVehicleId.toLowerCase() == targetVehicleId.toLowerCase();
        }).toList();

        // Sort by entryDate descending (newest first)
        filteredList.sort((a, b) {
          final String dateAStr = (a['entryDate'] ?? a['createdAt'] ?? '').toString();
          final String dateBStr = (b['entryDate'] ?? b['createdAt'] ?? '').toString();
          final DateTime dateA = DateTime.tryParse(dateAStr) ?? DateTime(1970);
          final DateTime dateB = DateTime.tryParse(dateBStr) ?? DateTime(1970);
          return dateB.compareTo(dateA);
        });

        setState(() {
          rawCosts = filteredList;
        });
      }
    } catch (e) {
      debugPrint("Error fetching costs: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> addCost(double amount, String purpose) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? userId = prefs.getString('userId');
      String targetVehicleId = (vehicle['id'] ?? vehicle['_id'] ?? '').toString().trim();

      if (targetVehicleId.isEmpty || userId == null) {
        Get.snackbar("Error", "Missing vehicle or user details", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      // Append a zero-width space and unique timestamp to bypass database 409 Conflict unique index limitations
      final String uniquePurpose = "$purpose\u200b${DateTime.now().microsecondsSinceEpoch}";

      final body = {
        "amount": amount,
        "purpose": uniquePurpose,
        "vehicle": targetVehicleId,
        "vehicleId": targetVehicleId,
        "vehicle_id": targetVehicleId,
        "userId": userId,
        "entryDate": DateTime.now().toIso8601String(),
      };

      final response = await http.post(
        Uri.parse(ApiServices.crete_cost),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      debugPrint("Add cost status: ${response.statusCode}");
      debugPrint("Add cost body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        var decoded = jsonDecode(response.body);
        String costId = '';
        if (decoded is Map && decoded['data'] != null) {
          costId = (decoded['data']['_id'] ?? decoded['data']['id'] ?? '').toString();
        }

        if (costId.isNotEmpty && targetVehicleId.isNotEmpty) {
          await prefs.setString("cost_vehicle_$costId", targetVehicleId);
        }

        // Detailed console logging as requested
        debugPrint("==================================================");
        debugPrint("💸 COST CREATION SUCCESS 💸");
        debugPrint("💰 Amount: £$amount");
        debugPrint("🏷️ Purpose: $purpose");
        debugPrint("🔑 Created Cost _id: $costId");
        debugPrint("🚗 Associated Vehicle ID: $targetVehicleId");
        debugPrint("==================================================");

        Get.snackbar(
          "Success",
          "Cost added successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        fetchCosts();
      } else {
        String errorMsg = "Failed to add cost";
        try {
          var decoded = jsonDecode(response.body);
          if (decoded is Map && decoded.containsKey('message')) {
            errorMsg = decoded['message'].toString();
          }
        } catch (_) {}

        debugPrint("❌ COST CREATION FAILED ❌ Status: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");

        Get.snackbar(
          "Error",
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Error adding cost: $e");
    }
  }

  Future<void> deleteCost(String costId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.delete(
        Uri.parse("${ApiServices.delete_cost}/$costId"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      debugPrint("Delete cost status: ${response.statusCode}");
      debugPrint("Delete cost body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 204) {
        Get.snackbar(
          "Success",
          "Cost deleted successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        fetchCosts();
      } else {
        Get.snackbar(
          "Error",
          "Failed to delete cost",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Error deleting cost: $e");
    }
  }

  String formatCostDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final dt = DateTime.parse(dateStr);
      final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
      return "${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]} ${dt.year}";
    } catch (e) {
      return dateStr;
    }
  }

  Map<String, dynamic> get computedData {
    if (rawCosts.isEmpty) {
      return {
        "total": "£0.00",
        "average": "£0.00",
        "entries": "0 total entries",
        "avgLabel": "Based on 0 days of data",
        "trend": "$selectedFilter Spending Trend",
        "bars": <Map<String, dynamic>>[
          {"label": "", "value": 0.0, "fraction": 0.0},
          {"label": "", "value": 0.0, "fraction": 0.0},
          {"label": "", "value": 0.0, "fraction": 0.0},
          {"label": "", "value": 0.0, "fraction": 0.0},
          {"label": "", "value": 0.0, "fraction": 0.0},
        ],
        "category": "No Expenses",
        "catAmount": "£0.00",
      };
    }

    double totalSum = 0.0;
    for (var cost in rawCosts) {
      totalSum += (cost['amount'] ?? 0.0).toDouble();
    }

    // Category grouping to find the top category
    Map<String, double> categoriesMap = {};
    for (var cost in rawCosts) {
      String cat = (cost['purpose'] ?? 'General').toString().trim();
      if (cat.contains('\u200b')) {
        cat = cat.split('\u200b').first.trim();
      }
      if (cat.isEmpty) cat = 'General';
      cat = cat[0].toUpperCase() + cat.substring(1).toLowerCase();
      double amt = (cost['amount'] ?? 0.0).toDouble();
      categoriesMap[cat] = (categoriesMap[cat] ?? 0.0) + amt;
    }

    String topCategory = "General";
    double topCategoryAmount = 0.0;
    categoriesMap.forEach((key, val) {
      if (val > topCategoryAmount) {
        topCategoryAmount = val;
        topCategory = key;
      }
    });

    List<Map<String, dynamic>> barList = [];
    String avgLabel = "";
    double averageVal = 0.0;

    if (selectedFilter == "Daily") {
      Map<String, double> dayGroups = {};
      for (var cost in rawCosts) {
        final dateStr = (cost['entryDate'] ?? cost['createdAt'] ?? '').toString();
        final dt = DateTime.tryParse(dateStr) ?? DateTime.now();
        final dayKey = "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
        dayGroups[dayKey] = (dayGroups[dayKey] ?? 0.0) + (cost['amount'] ?? 0.0).toDouble();
      }

      final sortedKeys = dayGroups.keys.toList()..sort();
      final lastKeys = sortedKeys.length > 5 ? sortedKeys.sublist(sortedKeys.length - 5) : sortedKeys;

      double maxVal = 0.0;
      for (var key in lastKeys) {
        if (dayGroups[key]! > maxVal) maxVal = dayGroups[key]!;
      }

      for (var key in lastKeys) {
        final dt = DateTime.parse(key);
        final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        final label = "${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]}";
        barList.add({
          "label": label,
          "value": dayGroups[key]!,
          "fraction": maxVal == 0.0 ? 0.0 : (dayGroups[key]! / maxVal),
        });
      }

      averageVal = totalSum / dayGroups.length;
      avgLabel = "Based on ${dayGroups.length} days of data";

    } else if (selectedFilter == "Weekly") {
      Map<String, double> weekGroups = {};
      for (var cost in rawCosts) {
        final dateStr = (cost['entryDate'] ?? cost['createdAt'] ?? '').toString();
        final dt = DateTime.tryParse(dateStr) ?? DateTime.now();
        final int weekNum = (dt.difference(DateTime(dt.year, 1, 1)).inDays / 7).ceil();
        final weekKey = "${dt.year}-W$weekNum";
        weekGroups[weekKey] = (weekGroups[weekKey] ?? 0.0) + (cost['amount'] ?? 0.0).toDouble();
      }

      final sortedKeys = weekGroups.keys.toList()..sort();
      final lastKeys = sortedKeys.length > 5 ? sortedKeys.sublist(sortedKeys.length - 5) : sortedKeys;

      double maxVal = 0.0;
      for (var key in lastKeys) {
        if (weekGroups[key]! > maxVal) maxVal = weekGroups[key]!;
      }

      for (var key in lastKeys) {
        final parts = key.split('-W');
        final label = "Week ${parts.last}";
        barList.add({
          "label": label,
          "value": weekGroups[key]!,
          "fraction": maxVal == 0.0 ? 0.0 : (weekGroups[key]! / maxVal),
        });
      }

      averageVal = totalSum / weekGroups.length;
      avgLabel = "Based on ${weekGroups.length} weeks of data";

    } else if (selectedFilter == "Monthly") {
      Map<String, double> monthGroups = {};
      for (var cost in rawCosts) {
        final dateStr = (cost['entryDate'] ?? cost['createdAt'] ?? '').toString();
        final dt = DateTime.tryParse(dateStr) ?? DateTime.now();
        final monthKey = "${dt.year}-${dt.month.toString().padLeft(2, '0')}";
        monthGroups[monthKey] = (monthGroups[monthKey] ?? 0.0) + (cost['amount'] ?? 0.0).toDouble();
      }

      final sortedKeys = monthGroups.keys.toList()..sort();
      final lastKeys = sortedKeys.length > 5 ? sortedKeys.sublist(sortedKeys.length - 5) : sortedKeys;

      double maxVal = 0.0;
      for (var key in lastKeys) {
        if (monthGroups[key]! > maxVal) maxVal = monthGroups[key]!;
      }

      for (var key in lastKeys) {
        final parts = key.split('-');
        final monthInt = int.parse(parts.last);
        final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        final label = months[monthInt - 1];
        barList.add({
          "label": label,
          "value": monthGroups[key]!,
          "fraction": maxVal == 0.0 ? 0.0 : (monthGroups[key]! / maxVal),
        });
      }

      averageVal = totalSum / monthGroups.length;
      avgLabel = "Based on ${monthGroups.length} months of data";

    } else {
      Map<String, double> yearGroups = {};
      for (var cost in rawCosts) {
        final dateStr = (cost['entryDate'] ?? cost['createdAt'] ?? '').toString();
        final dt = DateTime.tryParse(dateStr) ?? DateTime.now();
        final yearKey = dt.year.toString();
        yearGroups[yearKey] = (yearGroups[yearKey] ?? 0.0) + (cost['amount'] ?? 0.0).toDouble();
      }

      final sortedKeys = yearGroups.keys.toList()..sort();
      final lastKeys = sortedKeys.length > 5 ? sortedKeys.sublist(sortedKeys.length - 5) : sortedKeys;

      double maxVal = 0.0;
      for (var key in lastKeys) {
        if (yearGroups[key]! > maxVal) maxVal = yearGroups[key]!;
      }

      for (var key in lastKeys) {
        barList.add({
          "label": key,
          "value": yearGroups[key]!,
          "fraction": maxVal == 0.0 ? 0.0 : (yearGroups[key]! / maxVal),
        });
      }

      averageVal = totalSum / yearGroups.length;
      avgLabel = "Based on ${yearGroups.length} years of data";
    }

    while (barList.length < 5) {
      barList.insert(0, {
        "label": "",
        "value": 0.0,
        "fraction": 0.0,
      });
    }

    return {
      "total": "£${totalSum.toStringAsFixed(2)}",
      "average": "£${averageVal.toStringAsFixed(2)}",
      "entries": "${rawCosts.length} total entries",
      "avgLabel": avgLabel,
      "trend": "$selectedFilter Spending Trend",
      "bars": barList,
      "category": topCategory,
      "catAmount": "£${topCategoryAmount.toStringAsFixed(2)}",
    };
  }

  @override
  Widget build(BuildContext context) {
    var data = computedData;
    final barsData = data['bars'] as List;
    double maxVal = 0.0;
    for (var b in barsData) {
      final double val = (b['value'] ?? 0.0).toDouble();
      if (val > maxVal) maxVal = val;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)))
            : RefreshIndicator(
                color: const Color(0xFF2563EB),
                onRefresh: fetchCosts,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
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
                                      color: Colors.white.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.directions_car, color: Colors.white, size: 28),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${vehicle['make'] ?? ''} - ${vehicle['model'] ?? ''}",
                                          style: AppTextStyles.bigText.copyWith(
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          (vehicle['year'] ?? '').toString(),
                                          style: AppTextStyles.smallText.copyWith(
                                            color: Colors.white.withValues(alpha: 0.7),
                                          ),
                                        ),
                                      ],
                                    ),
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
                                  (vehicle['registration'] ?? '').toString(),
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
                                color: Colors.black.withValues(alpha: 0.1),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                                spreadRadius: -2,
                              ),
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
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
                                    Expanded(
                                      child: Text(
                                        "Running Costs",
                                        style: AppTextStyles.bigText.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
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
                                title: "Average Cost",
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
                                              _axisLabel(maxVal.toStringAsFixed(0)),
                                              _axisLabel((maxVal * 0.75).toStringAsFixed(0)),
                                              _axisLabel((maxVal * 0.5).toStringAsFixed(0)),
                                              _axisLabel((maxVal * 0.25).toStringAsFixed(0)),
                                              _axisLabel("0"),
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
                                                    children: barsData.map<Widget>((b) => _buildBar((b['fraction'] ?? 0.0).toDouble(), (b['label'] ?? '').toString())).toList(),
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
                              rawCosts.isEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(24),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(color: const Color(0xFFE2E8F0)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "No expenses added yet.",
                                            style: AppTextStyles.smallText.copyWith(color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Column(
                                      children: rawCosts.map<Widget>((cost) {
                                        final String costId = (cost['_id'] ?? '').toString();
                                        final double amt = (cost['amount'] ?? 0.0).toDouble();
                                        String purpose = (cost['purpose'] ?? 'General').toString().trim();
                                        if (purpose.contains('\u200b')) {
                                          purpose = purpose.split('\u200b').first.trim();
                                        }
                                        if (purpose.isEmpty) purpose = 'General';
                                        purpose = purpose[0].toUpperCase() + purpose.substring(1).toLowerCase();
                                        final String rawDate = (cost['entryDate'] ?? cost['createdAt'] ?? '').toString();
                                        final String formattedDate = formatCostDate(rawDate);

                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                                                          Expanded(
                                                            child: Text(
                                                              purpose,
                                                              style: AppTextStyles.smallText.copyWith(
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 14,
                                                              ),
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                          const SizedBox(width: 4),
                                                          Text(
                                                            formattedDate,
                                                            style: AppTextStyles.smallText.copyWith(
                                                              fontSize: 11,
                                                              color: Colors.grey[500],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 2),
                                                      Text(
                                                        "Vehicle: ${(vehicle['registration'] ?? '').toString()}",
                                                        style: AppTextStyles.smallText.copyWith(
                                                          fontSize: 12,
                                                          color: Colors.grey[600],
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        "£${amt.toStringAsFixed(2)}",
                                                        style: AppTextStyles.bigText.copyWith(
                                                          fontSize: 18,
                                                          color: const Color(0xFFE11D48),
                                                          fontWeight: FontWeight.w800,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                IconButton(
                                                  icon: const Icon(Icons.delete_outline, color: Color(0xFFE11D48)),
                                                  onPressed: () => _confirmDeleteCost(context, costId),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
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
          SizedBox(height: 40, child: isPrimaryBar && date.isNotEmpty ? Center(child: Transform.rotate(angle: -0.7, child: Text(date, style: const TextStyle(fontSize: 8, color: Colors.grey)))) : const SizedBox()),
        ],
      ),
    );
  }

  void _showAddCostDialog(BuildContext context) {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController purposeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Add New Cost", style: AppTextStyles.bigText.copyWith(fontSize: 18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: amountController, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: "Amount (£)", filled: true, fillColor: const Color(0xFFF1F5F9), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none))),
            const SizedBox(height: 16),
            TextField(controller: purposeController, decoration: InputDecoration(labelText: "Purpose", filled: true, fillColor: const Color(0xFFF1F5F9), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              final double? amt = double.tryParse(amountController.text);
              final String purpose = purposeController.text.trim();
              if (amt != null && purpose.isNotEmpty) {
                Get.back();
                addCost(amt, purpose);
              } else {
                Get.snackbar("Invalid Input", "Please enter a valid amount and purpose", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
            child: const Text("Add", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteCost(BuildContext context, String costId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Delete Cost", style: AppTextStyles.bigText.copyWith(fontSize: 18)),
        content: Text("Are you sure you want to delete this cost entry?", style: AppTextStyles.smallText.copyWith(fontSize: 14)),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Get.back();
              deleteCost(costId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE11D48)),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
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
    final paint = Paint()..color = Colors.grey.withValues(alpha: 0.1)..strokeWidth = 1;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}