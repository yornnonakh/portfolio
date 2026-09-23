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
            const gap = 12.0;
            final width =
                (constraints.maxWidth - (columns - 1) * gap) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: 12,
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
    final color = switch (skill.tone) {
      SkillTone.mint => const Color(0xFF30D158),
      SkillTone.violet => const Color(0xFFBF5AF2),
      SkillTone.coral => const Color(0xFFFF9F0A),
      SkillTone.sky => const Color(0xFF64D2FF),
    };
    final percentage = '${(skill.proficiency * 100).round()}%';
    return Semantics(
      label: '${skill.name} proficiency',
      value: percentage,
      excludeSemantics: true,
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .16),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.code_rounded, color: color, size: 22),
            ),
            const SizedBox(height: 28),
            Text(skill.name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              percentage,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: skill.proficiency,
                minHeight: 4,
                color: color,
                backgroundColor: Colors.white.withValues(alpha: .08),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
