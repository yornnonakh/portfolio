import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/availability_badge.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/info_row.dart';
import '../../../core/widgets/page_content.dart';
import '../../../core/widgets/tag_chip.dart';
import '../../../data/portfolio_providers.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    return DetailPage(
      title: 'About',
      children: [
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AvailabilityBadge(available: profile.available),
              const SizedBox(height: 18),
              Text(
                profile.bio,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.75,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        const SectionHeading(title: 'Education'),
        GlassCard(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  gradient: AppGradients.violet,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.school_outlined,
                  color: AppColors.ink,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.education.degree,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${profile.education.school} · ${profile.education.period}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        const SectionHeading(title: 'Quick Facts'),
        GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            children: [
              InfoRow(
                icon: Icons.location_on_outlined,
                text: '${profile.location} · Remote-friendly',
              ),
              const Divider(),
              InfoRow(icon: Icons.language_rounded, text: profile.languages),
              const Divider(),
              InfoRow(
                icon: Icons.schedule_rounded,
                text: profile.experienceSummary,
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        const SectionHeading(title: 'What I Value'),
        TagList(profile.values),
      ],
    );
  }
}
