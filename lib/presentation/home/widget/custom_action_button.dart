import 'package:flutter/material.dart';
import 'package:motorbridge/utils/app_text_styles.dart';

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

  void _onTapDown(TapDownDetails _) => setState(() => _scale = 0.95);
  void _onTapUp(TapUpDetails _) => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    final double iconSize   = sw * 0.050;  // ~18px
    final double titleSize  = sw * 0.042;  // ~15px
    final double subSize    = sw * 0.030;  // ~11px
    final double hPad       = sw * 0.050;
    final double vPad       = sh * 0.016;

    final iconWidget = Image.asset(
      widget.iconPath,
      width: 22,
      height: 22,
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
                padding: EdgeInsets.symmetric( vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!widget.iconAfterText) ...[
                          iconWidget,
                          SizedBox(width: sw * 0.022),
                        ],
                        Flexible(
                          child: Text(
                            widget.title,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bigText.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Color(0xffFCFDFF),
                                fontSize: 16

                            ),
                          ),
                        ),
                        if (widget.iconAfterText) ...[
                          SizedBox(width: sw * 0.022),
                          iconWidget,
                        ],
                      ],
                    ),
                    SizedBox(height: sh * 0.004),
                    Text(
                      widget.subtitle,
                       textAlign: TextAlign.center,
                      style: AppTextStyles.smallText.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Color(0xffFCFDFF),
                        fontSize: 14

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