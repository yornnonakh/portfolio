import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/page_content.dart';
import '../../../core/widgets/typewriter_text.dart';
import '../../../data/portfolio_providers.dart';
import '../../about/presentation/about_screen.dart';
import '../../experience/presentation/experience_screen.dart';
import '../../main/presentation/navigation_provider.dart';
import '../../projects/presentation/project_detail_sheet.dart';
import '../../projects/presentation/projects_provider.dart';
import '../../projects/presentation/widgets/project_card.dart';
import '../../../data/models/portfolio.dart';
import 'widgets/profile_header.dart';
import 'widgets/home_motion.dart';
import 'widgets/toolbox_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, this.motionEnabled = true});

  final bool motionEnabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final projects = ref.watch(projectsProvider);
    final wide = MediaQuery.sizeOf(context).width >= 900;
    void showProjects() {
      ref.read(projectFilterProvider.notifier).select(ProjectCategory.all);
      ref.read(navigationProvider.notifier).select(MainTab.project);
    }

    final introduction = ProfileHeader(
      profile: profile,
      onProjects: showProjects,
      animateRole: motionEnabled,
      onContact: () =>
          ref.read(navigationProvider.notifier).select(MainTab.contact),
    );
    final work = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeading(
          title: 'Featured Work',
          action: 'See all',
          onAction: showProjects,
        ),
        for (final project in projects.take(wide ? 2 : 1)) ...[
          ProjectCard(
            project: project,
            compact: true,
            onTap: () => showProjectDetails(context, project),
          ),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 12),
        const _ProfileLinks(),
        const SizedBox(height: 26),
        SectionHeading(
          title: 'Skills and stack',
          action: 'Explore',
          onAction: () =>
              ref.read(navigationProvider.notifier).select(MainTab.skill),
        ),
        const ToolboxCard(),
      ],
    );
    return HomeMotion(
      enabled: motionEnabled,
      child: PageContent(
        title: 'Portfolio',
        children: [
          if (wide)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: introduction),
                  const SizedBox(width: 76),
                  Expanded(flex: 5, child: work),
                ],
              ),
            )
          else ...[
            introduction,
            const SizedBox(height: 24),
            work,
          ],
          const SizedBox(height: 32),
          const Text(
            'CRAFTED WITH CARE. BUILT WITH FLUTTER.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9,
              letterSpacing: 2,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// Kept as a dense fallback layout for future embedded/landscape surfaces.
// ignore: unused_element
class _CompactHomeScreen extends StatelessWidget {
  const _CompactHomeScreen({
    required this.profile,
    required this.onProjects,
    required this.animateRole,
  });

  final PortfolioProfile profile;
  final VoidCallback onProjects;
  final bool animateRole;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(48, 14, 48, 132),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'HOME',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.8,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  _CompactAvatar(
                    initials: profile.initials,
                    imageAsset: profile.avatarAsset,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "HI, I'M",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.4,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          profile.name,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: .6),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 23),
              TypewriterText(
                text: profile.role,
                enabled: animateRole,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -.3,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'I build fluid, thoughtful mobile\nexperiences from pixel to production.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _CompactGradientButton(
                      label: 'View work →',
                      onTap: onProjects,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GlassCard(
                    borderRadius: 22,
                    padding: EdgeInsets.zero,
                    semanticLabel: 'Download resume',
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Add your resume URL in portfolio_content.dart.',
                        ),
                      ),
                    ),
                    child: const SizedBox(
                      width: 42,
                      height: 42,
                      child: Icon(Icons.download_outlined, size: 19),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 27),
              const Text(
                'TOOLBOX',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Skills and stack',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              const ToolboxCard(compact: true),
              const SizedBox(height: 96),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompactAvatar extends StatelessWidget {
  const _CompactAvatar({required this.initials, this.imageAsset});
  final String initials;
  final String? imageAsset;

  @override
  Widget build(BuildContext context) => Container(
    width: 43,
    height: 43,
    padding: const EdgeInsets.all(1.5),
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        colors: [Color(0xFF76A8FF), Color(0xFF62DCD3)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: ClipOval(
      child: imageAsset == null
          ? Center(
              child: Text(
                initials,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : Image.asset(
              imageAsset!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Center(
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
    ),
  );
}

class _CompactGradientButton extends StatelessWidget {
  const _CompactGradientButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: AppGradients.primary,
      borderRadius: BorderRadius.circular(22),
    ),
    child: TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.ink,
        minimumSize: const Size(0, 42),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

class _ProfileLinks extends StatelessWidget {
  const _ProfileLinks();

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: _ProfileLink(
          label: 'About me',
          icon: Icons.person_outline_rounded,
          page: const AboutScreen(),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: _ProfileLink(
          label: 'Experience',
          icon: Icons.work_outline_rounded,
          page: const ExperienceScreen(),
        ),
      ),
    ],
  );
}

class _ProfileLink extends StatelessWidget {
  const _ProfileLink({
    required this.label,
    required this.icon,
    required this.page,
  });
  final String label;
  final IconData icon;
  final Widget page;

  @override
  Widget build(BuildContext context) => GlassCard(
    onTap: () => Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => page)),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 17),
    borderRadius: 18,
    child: Row(
      children: [
        Icon(icon, size: 19, color: AppColors.primary),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
        const Icon(
          Icons.chevron_right_rounded,
          size: 16,
          color: AppColors.textMuted,
        ),
      ],
    ),
  );
}
