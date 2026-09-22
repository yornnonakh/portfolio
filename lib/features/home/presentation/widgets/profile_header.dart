import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/typewriter_text.dart';
import '../../../../data/models/portfolio.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.profile,
    required this.onProjects,
    required this.onContact,
    this.animateRole = false,
  });
  final PortfolioProfile profile;
  final VoidCallback onProjects;
  final VoidCallback onContact;
  final bool animateRole;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    return Column(
      children: [
        const SizedBox(height: 8),
        ProfileAvatar(
          initials: profile.initials,
          imageAsset: profile.avatarAsset,
          size: wide ? 120 : 104,
        ),
        const SizedBox(height: 22),
        Text(
          profile.name,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.headlineLarge?.copyWith(fontSize: wide ? 44 : 36),
        ),
        const SizedBox(height: 6),
        TypewriterText(
          text: profile.role,
          enabled: animateRole,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          profile.tagline,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        GlassCard(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: IntrinsicHeight(
            child: Row(
              children: [
                for (var index = 0; index < profile.stats.length; index++) ...[
                  if (index > 0)
                    const VerticalDivider(width: 1, indent: 6, endIndent: 6),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          profile.stats[index].value,
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profile.stats[index].label,
                          textAlign: TextAlign.center,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final buttons = [
              GradientButton(
                label: 'View Projects',
                icon: Icons.north_east_rounded,
                onPressed: onProjects,
              ),
              GradientButton(
                label: "Let’s Talk",
                outlined: true,
                onPressed: onContact,
              ),
            ];
            if (constraints.maxWidth < 310 ||
                MediaQuery.textScalerOf(context).scale(1) > 1.3) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [buttons[0], const SizedBox(height: 12), buttons[1]],
              );
            }
            return Row(
              children: [
                Expanded(flex: 6, child: buttons[0]),
                const SizedBox(width: 12),
                Expanded(flex: 5, child: buttons[1]),
              ],
            );
          },
        ),
      ],
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.initials,
    this.imageAsset,
    this.size = 112,
  });
  final String initials;
  final String? imageAsset;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: imageAsset == null
          ? 'Profile monogram $initials'
          : 'Profile photo',
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: .22),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface,
                ),
                child: SizedBox(
                  width: size - 16,
                  height: size - 16,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2C2C2E), Color(0xFF1C1C1E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: AppColors.glassBorder),
                    ),
                    child: ClipOval(
                      child: imageAsset == null
                          ? Center(
                              child: Text(
                                initials,
                                style: TextStyle(
                                  fontSize: size * .36,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -1.5,
                                ),
                              ),
                            )
                          : Image.asset(
                              imageAsset!,
                              width: size - 16,
                              height: size - 16,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Center(
                                    child: Text(
                                      initials,
                                      style: TextStyle(
                                        fontSize: size * .36,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 1,
              bottom: 4,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 4),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 16,
                  color: AppColors.ink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
