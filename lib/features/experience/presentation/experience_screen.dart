import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/page_content.dart';
import '../../../core/widgets/reveal_text.dart';
import '../../../core/widgets/tag_chip.dart';
import '../../../data/models/portfolio.dart';
import '../../../data/portfolio_providers.dart';

class ExperienceScreen extends ConsumerWidget {
  const ExperienceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final experience = ref.watch(experienceProvider);
    return _AnimatedExperienceTimeline(experience: experience);
  }
}

class _AnimatedExperienceTimeline extends StatefulWidget {
  const _AnimatedExperienceTimeline({required this.experience});

  final List<WorkExperience> experience;

  @override
  State<_AnimatedExperienceTimeline> createState() =>
      _AnimatedExperienceTimelineState();
}

class _AnimatedExperienceTimelineState
    extends State<_AnimatedExperienceTimeline>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _reducedMotion = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1050),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reducedMotion = MediaQuery.disableAnimationsOf(context);
    if (_reducedMotion) {
      _controller.value = 1;
    } else if (!_controller.isAnimating && !_controller.isCompleted) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final count = widget.experience.length;
        final stagger = count <= 1 ? 0.0 : .18;
        return DetailPage(
          title: 'Experience',
          children: [
            for (var i = 0; i < count; i++)
              _TimelineEntry(
                experience: widget.experience[i],
                last: i == count - 1,
                progress: _entryProgress(i, stagger),
              ),
          ],
        );
      },
    );
  }

  double _entryProgress(int index, double stagger) {
    if (_reducedMotion) return 1;
    final start = math.min(index * stagger, .48);
    final end = math.min(start + .58, 1.0);
    final interval = Interval(start, end, curve: Curves.easeOutCubic);
    return interval.transform(_controller.value);
  }
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({
    required this.experience,
    required this.last,
    required this.progress,
  });
  final WorkExperience experience;
  final bool last;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 22),
      child: Stack(
        children: [
          if (!last)
            Positioned(
              left: 12.25,
              top: 29,
              bottom: 5,
              width: 1.5,
              child: Align(
                alignment: Alignment.topCenter,
                child: FractionallySizedBox(
                  heightFactor: progress,
                  widthFactor: 1,
                  child: ColoredBox(color: Colors.white.withValues(alpha: .13)),
                ),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 26,
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Transform.scale(
                    scale: .78 + (.22 * progress),
                    child: Opacity(
                      opacity: progress,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                          border: Border.all(
                            color: const Color(0xFF294C55),
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(
                                alpha: .28 * progress,
                              ),
                              blurRadius: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Opacity(
                  opacity: progress,
                  child: Transform.translate(
                    offset: Offset(0, 14 * (1 - progress)),
                    child: GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RevealText(
                            text: experience.role,
                            progress: progress,
                            style: Theme.of(context).textTheme.titleLarge!,
                          ),
                          const SizedBox(height: 5),
                          RevealText(
                            text:
                                '${experience.company} · ${experience.period}',
                            progress: progress,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.primary,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            experience.description,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 18),
                          TagList(experience.technologies, compact: true),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
