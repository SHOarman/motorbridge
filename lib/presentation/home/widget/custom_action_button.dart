import 'package:flutter/material.dart';

class CustomActionButton extends StatefulWidget {
  final String title;
  final String subtitle;
  final String iconPath;
  final Color bgColor;
  final Color contentColor;
  final VoidCallback onTap;
  final bool iconAfterText;

  const CustomActionButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.bgColor,
    required this.contentColor,
    required this.onTap,
    this.iconAfterText = false,
  });

  @override
  State<CustomActionButton> createState() => _CustomActionButtonState();
}

class _CustomActionButtonState extends State<CustomActionButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.95);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final iconWidget = Image.asset(
      widget.iconPath,
      width: 20,
      height: 20,
      color: widget.contentColor,
    );

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: widget.bgColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              splashColor: Colors.white.withValues(alpha: 0.2),
              highlightColor: Colors.white.withValues(alpha: 0.1),
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!widget.iconAfterText) ...[
                          iconWidget,
                          const SizedBox(width: 8),
                        ],
                        Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: widget.contentColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.iconAfterText) ...[
                          const SizedBox(width: 8),
                          iconWidget,
                        ],
                      ],
                    ),
                    Text(
                      widget.subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: widget.contentColor.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
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