import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

final linkServiceProvider = Provider((ref) => const LinkService());

/// Kept behind a provider so platform behavior can be replaced in tests.
class LinkService {
  const LinkService();

  Future<bool> open(Uri uri) async {
    try {
      return await launchUrl(uri, mode: LaunchMode.platformDefault);
    } on Exception {
      return false;
    }
  }
}

Uri emailUri(String address, {String? subject}) => Uri(
  scheme: 'mailto',
  path: address,
  // Non-http schemes need percent-encoded spaces rather than '+'.
  query: subject == null ? null : 'subject=${Uri.encodeComponent(subject)}',
);

Future<void> openPortfolioLink(
  BuildContext context,
  WidgetRef ref,
  Uri uri,
) async {
  final opened = await ref.read(linkServiceProvider).open(uri);
  if (!opened && context.mounted) {
    final fallback = uri.scheme == 'mailto' || uri.scheme == 'tel'
        ? uri.path
        : uri.toString();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Couldn’t open an app for this link. $fallback'),
        action: SnackBarAction(
          label: 'Copy',
          onPressed: () => Clipboard.setData(ClipboardData(text: fallback)),
        ),
      ),
    );
  }
}
