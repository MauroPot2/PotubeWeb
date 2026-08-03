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
      title: 'Potube Web — Converti i tuoi file audio e video in MP3',
      lang: 'it',
      meta: {
        'description':
            'Converti i tuoi file audio e video in MP3 dal browser con upload temporanei, bitrate selezionabile e normalizzazione opzionale.',
        'application-name': 'Potube Web',
        'theme-color': '#0d0f14',
        'referrer': 'strict-origin-when-cross-origin',
        'robots': 'index,follow,max-image-preview:large',
        'google-adsense-account': 'ca-pub-2871209384703483',
        if (gaMeasurementId.isNotEmpty) 'potube-ga-id': gaMeasurementId,
        if (googleSiteVerification.isNotEmpty)
          'google-site-verification': googleSiteVerification,
      },
      head: [
        link(rel: 'stylesheet', href: '/styles.css'),
        link(rel: 'stylesheet', href: '/polish.css'),
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
