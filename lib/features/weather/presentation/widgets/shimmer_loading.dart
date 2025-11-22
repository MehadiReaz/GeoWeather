import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer loading widget for weather page
class WeatherShimmerLoading extends StatelessWidget {
  const WeatherShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final horizontalPadding = isTablet ? size.width * 0.15 : 20.0;

    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).padding.top + 60),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 20,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Temperature Card Shimmer
              _TemperatureShimmer(
                baseColor: baseColor,
                highlightColor: highlightColor,
                isTablet: isTablet,
              ),
              const SizedBox(height: 20),
              // Weather Details Card Shimmer
              _WeatherDetailsShimmer(
                baseColor: baseColor,
                highlightColor: highlightColor,
                isTablet: isTablet,
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class _TemperatureShimmer extends StatelessWidget {
  final Color baseColor;
  final Color highlightColor;
  final bool isTablet;

  const _TemperatureShimmer({
    required this.baseColor,
    required this.highlightColor,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    final height = isTablet ? 500.0 : 500.0;
    final padding = isTablet ? 36.0 : 28.0;

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: baseColor,
      ),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            children: [
              // Location
              Container(
                height: 24,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 8),
              // Description
              Container(
                height: 16,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 20),
              // Weather Icon
              Container(
                height: isTablet ? 180 : 140,
                width: isTablet ? 180 : 140,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 20),
              // Temperature
              Container(
                height: isTablet ? 96 : 72,
                width: isTablet ? 240 : 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 12),
              // Feels like
              Container(
                height: 20,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: isTablet ? 36 : 28),
              // High/Low container
              Container(
                height: isTablet ? 70 : 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeatherDetailsShimmer extends StatelessWidget {
  final Color baseColor;
  final Color highlightColor;
  final bool isTablet;

  const _WeatherDetailsShimmer({
    required this.baseColor,
    required this.highlightColor,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).cardColor,
      ),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 32 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Container(
                height: 22,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                int crossAxisCount = 2;
                if (screenWidth > 900) {
                  crossAxisCount = 3;
                } else if (screenWidth > 600) {
                  crossAxisCount = 3;
                }

                final itemWidth =
                    (constraints.maxWidth - (crossAxisCount - 1) * 12) /
                    crossAxisCount;
                final itemHeight = itemWidth / 1.3;

                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(
                    6,
                    (index) => Shimmer.fromColors(
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                      child: Container(
                        width: itemWidth,
                        height: itemHeight,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
