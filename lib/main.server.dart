import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:potube_web/app.dart';

void main() {
  Jaspr.initializeApp();

  runApp(
    Document(
      title: 'Potube Web — Converti i tuoi media in MP3',
      lang: 'it',
      meta: const {
        'description': 'Converti i tuoi file audio e video in MP3 direttamente dal browser. Upload temporanei, qualità selezionabile e interfaccia semplice.',
        'theme-color': '#0d0f14',
      },
      head: const [
        link(rel: 'stylesheet', href: '/styles.css'),
        link(rel: 'icon', href: '/favicon.svg', attributes: {'type': 'image/svg+xml'}),
      ],
      body: const App(),
    ),
  );
}
