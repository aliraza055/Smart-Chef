import 'package:flutter/material.dart';

class AnalyzerBanner extends StatelessWidget {
  final VoidCallback onTap;

  const AnalyzerBanner({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 140,
        decoration: BoxDecoration(
          color: const Color(0xFF1B4332),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned(
                top: -25,
                right: 45,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF40916C).withOpacity(0.4),
                  ),
                ),
              ),
              Positioned(
                bottom: -18,
                right: 10,
                child: Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF2D6A4F).withOpacity(0.5),
                  ),
                ),
              ),

              // Left content
              Positioned(
                left: 16,
                top: 0,
                bottom: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // AI Powered pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF9F27).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFEF9F27),
                          width: 0.5,
                        ),
                      ),
                      child: const Text(
                        '✦AI POWERED',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFAC775),
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.2,
                        ),
                        children: [
                          TextSpan(text: 'Food '),
                          TextSpan(
                            text: 'Analyzer',
                            style: TextStyle(color: Color(0xFF7ecba1)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 3),

                    // Subtitle
                    const Text(
                      'Scan any dish · Get instant nutrition',
                      style: TextStyle(fontSize: 10, color: Colors.white54),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _StatChip(label: 'Calories'),
                        const SizedBox(width: 6),
                        _StatChip(label: 'Macros'),
                        const SizedBox(width: 6),
                        _StatChip(label: 'Health Score'),
                      ],
                    ),
                  ],
                ),
              ),

              Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF9F27),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          color: Color(0xFF412402),
                          size: 26,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Scan Now',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF412402),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  const _StatChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 9,
          color: Color(0xFF7ecba1),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
