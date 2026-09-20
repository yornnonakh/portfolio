import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/page_content.dart';
import '../../../core/widgets/tag_chip.dart';
import '../../../data/portfolio_providers.dart';
import '../../home/presentation/widgets/profile_header.dart';
import '../../home/presentation/widgets/toolbox_card.dart';
import '../../main/presentation/navigation_provider.dart';
import '../../projects/presentation/project_detail_sheet.dart';
import '../../projects/presentation/widgets/project_card.dart';

/// A single scrollable overview of the portfolio for visitors who want to
/// browse everything without changing tabs.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final projects = ref.watch(projectsProvider);
    final experience = ref.watch(experienceProvider);
    final wide = MediaQuery.sizeOf(context).width >= 900;
    void selectProjects() =>
        ref.read(navigationProvider.notifier).select(MainTab.project);
    void selectContact() =>
        ref.read(navigationProvider.notifier).select(MainTab.contact);

    return PageContent(
      title: 'Dashboard',
      children: [
        ProfileHeader(
          profile: profile,
          onProjects: selectProjects,
          onContact: selectContact,
        ),
        const SizedBox(height: 38),
        const SectionHeading(title: 'Featured Work'),
        LayoutBuilder(
          builder: (context, constraints) {
            if (wide) {
              final width = (constraints.maxWidth - 18) / 2;
              return Wrap(
                spacing: 18,
                runSpacing: 18,
                children: [
                  for (final project in projects)
                    SizedBox(
                      width: width,
                      child: ProjectCard(
                        project: project,
                        onTap: () => showProjectDetails(context, project),
                      ),
                    ),
                ],
              );
            }
            return Column(
              children: [
                for (final project in projects) ...[
                  ProjectCard(
                    project: project,
                    compact: true,
                    onTap: () => showProjectDetails(context, project),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            );
          },
        ),
        const SizedBox(height: 25),
        const SectionHeading(title: 'Skills and stack'),
        const ToolboxCard(),
        const SizedBox(height: 30),
        const SectionHeading(title: 'Experience'),
        for (final job in experience) ...[
          GlassCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(job.role, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  '${job.company} · ${job.period}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  job.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 13),
                TagList(job.technologies, compact: true),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 16),
        GlassCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Let's build something great.",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                profile.availability,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 18),
              GradientButton(
                label: 'Get in touch',
                icon: Icons.arrow_forward_rounded,
                onPressed: selectContact,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
