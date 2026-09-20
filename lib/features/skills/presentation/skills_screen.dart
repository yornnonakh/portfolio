import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/page_content.dart';
import '../../../core/widgets/tag_chip.dart';
import '../../../data/models/portfolio.dart';
import '../../../data/portfolio_providers.dart';

class SkillsScreen extends ConsumerWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skills = ref.watch(skillsProvider);
    final otherSkills = ref.watch(otherSkillsProvider);
    return PageContent(
      title: 'Skills',
      children: [
        const SectionHeading(title: 'Languages & Frameworks'),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 760 ? 4 : 2;
            const gap = 16.0;
            final width =
                (constraints.maxWidth - (columns - 1) * gap) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: 20,
              children: [
                for (final skill in skills)
                  SizedBox(
                    width: width,
                    child: _SkillCard(skill: skill),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 36),
        const SectionHeading(title: 'Also Working With'),
        TagList(otherSkills),
      ],
    );
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({required this.skill});
  final PortfolioSkill skill;

  @override
  Widget build(BuildContext context) {
    final colors = switch (skill.tone) {
      SkillTone.mint => const [Color(0xFF75DECF), Color(0xFF2DB4A1)],
      SkillTone.violet => const [Color(0xFFA1AAFF), Color(0xFF7066F2)],
      SkillTone.coral => const [Color(0xFFFFB996), Color(0xFFFF896B)],
      SkillTone.sky => const [Color(0xFFA7E0F7), Color(0xFF5EB7EC)],
    };
    final percentage = '${(skill.proficiency * 100).round()}%';
    return Semantics(
      label: '${skill.name} proficiency',
      value: percentage,
      excludeSemantics: true,
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 23),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = math.min(112.0, constraints.maxWidth);
            return Column(
              children: [
                SizedBox.square(
                  dimension: size,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: CircularProgressIndicator(
                          value: skill.proficiency,
                          strokeWidth: 9,
                          strokeAlign: -1,
                          backgroundColor: Colors.white.withValues(alpha: .12),
                          color: AppColors.primary,
                        ),
                      ),
                      Container(
                        width: size - 18,
                        height: size - 18,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: colors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Text(
                          percentage,
                          style: const TextStyle(
                            color: AppColors.ink,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  skill.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
