import 'dart:ui';
import 'package:flutter/material.dart';

class SwipeNextButton extends StatelessWidget {
  final VoidCallback onTap;

  const SwipeNextButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      // margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: const Color(0xFFC4C4C4).withValues(alpha: 0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(
            color: Colors.white.withValues(alpha: 0.2),
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                // Button with Inkwell effect
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(36),
                    splashColor: Colors.white24, // Click korle white splash hobe
                    child: Ink(
                      width: 130,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF154da1),
                        borderRadius: BorderRadius.circular(36),
                      ),
                      child: const Center(
                        child: Text(
                          "Next",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 5),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 26),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 23,
                        color: const Color(0xFF00C853).withValues(alpha: 0.2 + (index * 0.15)),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}