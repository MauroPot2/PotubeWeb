import 'dart:io';

import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:potube_web/app.dart';

void main() {
  Jaspr.initializeApp();

  final gaMeasurementId =
      Platform.environment['GA_MEASUREMENT_ID']?.trim() ?? '';
  final googleSiteVerification =
      Platform.environment['GOOGLE_SITE_VERIFICATION']?.trim() ?? '';

  runApp(
    Document(
      title: 'Potube Web — Converti i tuoi media in MP3',
      lang: 'it',
      meta: {
        'description':
            'Converti i tuoi file audio e video in MP3 direttamente dal browser. Upload temporanei, beta gratuita e interfaccia semplice.',
        'theme-color': '#0d0f14',
        'robots': 'index,follow,max-image-preview:large',
        'google-adsense-account': 'ca-pub-2871209384703483',
        if (gaMeasurementId.isNotEmpty) 'potube-ga-id': gaMeasurementId,
        if (googleSiteVerification.isNotEmpty)
          'google-site-verification': googleSiteVerification,
      },
      head: [
        link(rel: 'stylesheet', href: '/styles.css'),
        link(
          rel: 'icon',
          href: '/favicon.svg',
          attributes: {'type': 'image/svg+xml'},
        ),
        Component.element(
          tag: 'script',
          attributes: {'src': '/privacy-consent.js', 'defer': ''},
        ),
        Component.element(
          tag: 'script',
          attributes: {'src': '/analytics.js', 'defer': ''},
        ),
      ],
      body: const App(),
    ),
  );
}
