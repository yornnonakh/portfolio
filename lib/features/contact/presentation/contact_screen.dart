import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/services/link_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/info_row.dart';
import '../../../core/widgets/page_content.dart';
import '../../../data/models/portfolio.dart';
import '../../../data/portfolio_providers.dart';

class ContactScreen extends ConsumerWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final introduction = GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Let’s build\nsomething great.",
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontSize: 30),
          ),
          const SizedBox(height: 14),
          Text(
            profile.availability,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 22),
          GradientButton(
            label: 'Send a Message',
            icon: Icons.near_me_outlined,
            onPressed: () => openPortfolioLink(
              context,
              ref,
              emailUri(profile.email, subject: 'Let’s build something great'),
            ),
          ),
        ],
      ),
    );
    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Column(
            children: [
              InfoRow(
                icon: Icons.mail_outline_rounded,
                text: profile.email,
                onTap: () =>
                    openPortfolioLink(context, ref, emailUri(profile.email)),
                trailing: IconButton(
                  tooltip: 'Copy email address',
                  icon: const Icon(Icons.copy_rounded, size: 17),
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: profile.email));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Email address copied.')),
                      );
                    }
                  },
                ),
              ),
              const Divider(),
              InfoRow(
                icon: Icons.phone_outlined,
                text: profile.phone,
                onTap: () => openPortfolioLink(
                  context,
                  ref,
                  Uri(
                    scheme: 'tel',
                    path: profile.phone.replaceAll(RegExp(r'[^+\d]'), ''),
                  ),
                ),
              ),
              const Divider(),
              InfoRow(
                icon: Icons.location_on_outlined,
                text: profile.location,
                onTap: () => openPortfolioLink(
                  context,
                  ref,
                  Uri.https('www.google.com', '/maps/search/', {
                    'api': '1',
                    'query': profile.location,
                  }),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        const SectionHeading(title: 'Find Me Elsewhere'),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final social in profile.socials) _SocialButton(social: social),
          ],
        ),
        if (profile.socials.every((social) => social.url == null)) ...[
          const SizedBox(height: 12),
          Text(
            'Social profiles coming soon.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
    return PageContent(
      title: 'Contact',
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 760) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: introduction),
                  const SizedBox(width: 28),
                  Expanded(child: details),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [introduction, const SizedBox(height: 18), details],
            );
          },
        ),
      ],
    );
  }
}

class _SocialButton extends ConsumerWidget {
  const _SocialButton({required this.social});
  final SocialProfile social;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final icon = switch (social.platform) {
      SocialPlatform.github => FontAwesomeIcons.github,
      SocialPlatform.linkedIn => FontAwesomeIcons.linkedin,
      SocialPlatform.x => FontAwesomeIcons.xTwitter,
      SocialPlatform.dribbble => FontAwesomeIcons.dribbble,
    };
    return Tooltip(
      message: social.url == null
          ? '${social.label} · Coming soon'
          : social.label,
      child: GlassCard(
        borderRadius: 22,
        padding: EdgeInsets.zero,
        child: SizedBox.square(
          dimension: 58,
          child: IconButton(
            onPressed: social.url == null
                ? null
                : () => openPortfolioLink(context, ref, Uri.parse(social.url!)),
            icon: FaIcon(icon, size: 21),
            color: AppColors.textPrimary,
            disabledColor: AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}
