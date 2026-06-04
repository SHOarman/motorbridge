import 'package:flutter/material.dart';
import 'package:motorbridge/utils/app_text_styles.dart';

class VehicleDocumentsCard extends StatelessWidget {
  final List<dynamic> documents;
  final bool isLoading;
  final VoidCallback onAddTap;
  final Function(Map<String, dynamic>) onViewTap;
  final Function(Map<String, dynamic>) onEditTap;
  final Function(Map<String, dynamic>) onDeleteTap;

  const VehicleDocumentsCard({
    super.key,
    required this.documents,
    required this.isLoading,
    required this.onAddTap,
    required this.onViewTap,
    required this.onEditTap,
    required this.onDeleteTap,
  });

  String? getFileUrl(Map<String, dynamic> doc) {
    if (doc['files'] is List && (doc['files'] as List).isNotEmpty) {
      final first = doc['files'][0];
      if (first is String) return first;
      if (first is Map) return first['url']?.toString() ?? first['path']?.toString();
    }
    if (doc['files'] is String) return doc['files'];
    if (doc['file'] is String) return doc['file'];
    if (doc['url'] is String) return doc['url'];
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xffEEEEEE), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Vehicle Documents",
            style: AppTextStyles.bigText.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xff2A2A2A),
            ),
          ),
          const SizedBox(height: 16),
          if (isLoading) ...[
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1B4E9F)),
                ),
              ),
            ),
          ] else if (documents.isEmpty) ...[
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    Icon(Icons.folder_open, size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 8),
                    Text(
                      "No documents uploaded for this vehicle",
                      style: AppTextStyles.smallText.copyWith(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: documents.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final Map<String, dynamic> doc = Map<String, dynamic>.from(documents[index]);
                final title = doc['title']?.toString() ?? 'Unnamed Document';
                final fileUrl = getFileUrl(doc) ?? '';
                final isPdf = fileUrl.toLowerCase().endsWith('.pdf') || title.toLowerCase().contains('pdf');

                return DocumentItem(
                  title: title,
                  isPdf: isPdf,
                  onViewTap: () => onViewTap(doc),
                  onEditTap: () => onEditTap(doc),
                  onDeleteTap: () => onDeleteTap(doc),
                );
              },
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: onAddTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff1B3A6E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add, color: Colors.white, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    "Add Documents",
                    style: AppTextStyles.smallText.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DocumentItem extends StatelessWidget {
  final String title;
  final bool isPdf;
  final VoidCallback onViewTap;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;

  const DocumentItem({
    super.key,
    required this.title,
    required this.isPdf,
    required this.onViewTap,
    required this.onEditTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffF0F0F0), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: isPdf ? const Color(0xffFFEBEE) : const Color(0xffE3F2FD),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isPdf ? "PDF" : "IMG",
              style: TextStyle(
                color: isPdf ? const Color(0xffE53935) : const Color(0xff1976D2),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.smallText.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: const Color(0xff4A4A4A),
              ),
            ),
          ),
          PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.more_vert, color: Color(0xff607D8B)),
            onSelected: (value) {
              if (value == 'view') {
                onViewTap();
              } else if (value == 'edit') {
                onEditTap();
              } else if (value == 'delete') {
                onDeleteTap();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'view',
                child: Text('View'),
              ),
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}