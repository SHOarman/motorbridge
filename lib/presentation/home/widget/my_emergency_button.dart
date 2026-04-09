import 'package:flutter/material.dart';

class MyEmergencyButton extends StatefulWidget {
  const MyEmergencyButton({super.key});

  @override
  State<MyEmergencyButton> createState() => _MyEmergencyButtonState();
}

class _MyEmergencyButtonState extends State<MyEmergencyButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTapDown: (_) => setState(() => _scale = 0.96),
        onTapUp: (_) => setState(() => _scale = 1.0),
        onTapCancel: () => setState(() => _scale = 1.0),
        onTap: () {
          debugPrint("Emergency Button Clicked!");
        },
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 100),
          child: Container(
            height: 40,
            width: 240,
            decoration: BoxDecoration(
              color: const Color(0xff2664A3),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(7),
                onTap: () {
                  debugPrint("Emergency Button Clicked!");
                },
                splashColor: Colors.white.withValues(alpha: 0.2),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Add Emergency Contact",
                      style: TextStyle(
                        color: Color(0xffFFFFFF),
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 5),
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