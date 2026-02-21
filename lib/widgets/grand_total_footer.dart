import 'package:flutter/material.dart';
import '../utils/formatter.dart';
import '../utils/constants.dart';

class GrandTotalFooter extends StatelessWidget {
  final double total;
  final int studentCount;

  const GrandTotalFooter({
    super.key,
    required this.total,
    required this.studentCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.kSpaceL),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3D5AFE), Color(0xFF673AB7)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Community Impact',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                Text(
                  '$studentCount Students',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Grand Total',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: total),
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeOutExpo,
                  builder: (context, value, child) {
                    return Text(
                      Formatter.formatPrice(value, compact: true),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
