import 'package:dinopet_walker/widgets/home/GaugePainter.dart';
import 'package:flutter/material.dart';

class GaugeWidget extends StatelessWidget {
  final int value;
  final int maxValue;

  const GaugeWidget({super.key, required this.value, required this.maxValue});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: CustomPaint(
        painter: GaugePainter(value: value, maxValue: maxValue),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 90),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: _formatNumber(value),
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 1.2,
                      ),
                    ),
                    if (value < maxValue) ...[
                      TextSpan(
                        text: ' / ',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                      TextSpan(
                        text: _formatNumber(maxValue),
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Text(
                'Pas Aujourd\'hui',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatNumber(int number) {
  return number.toString().replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]} ',
  );
}
