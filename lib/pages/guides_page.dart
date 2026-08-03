import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:potube_web/components/site_scaffold.dart';

class GuidesPage extends StatelessComponent {
  const GuidesPage({super.key});

  @override
  Component build(BuildContext context) {
    return SiteScaffold(
      child: el('section', classes: 'section guides-page', children: [
        el('div', classes: 'container', children: [
          el('div', classes: 'page-intro narrow', children: [
            el('span', classes: 'eyebrow', children: [text('GUIDE POTUBE')]),
            el('h1', children: [text('Capire l’audio prima di convertirlo')]),
            el('p', classes: 'article-lead', children: [
              text(
                'Guide brevi e pratiche per scegliere bitrate, normalizzazione e formato senza inseguire numeri inutili. '
                'L’obiettivo è ottenere un file adatto all’uso reale, partendo sempre dalla qualità della sorgente.',
              ),
            ]),
          ]),
          el('div', classes: 'guide-grid', children: [
            _guide(
              'BITRATE MP3',
              '128, 192, 256 o 320 kbps?',
              'Cosa cambia davvero tra i diversi bitrate e perché una ricodifica non può aggiungere dettagli assenti nella sorgente.',
              '/guide/mp3-bitrate',
            ),
            _guide(
              'VOLUME',
              'Che cosa significa normalizzare l’audio?',
              'Quando la normalizzazione è utile, che cosa modifica e perché non è la stessa cosa di “alzare il volume”.',
              '/guide/normalizzazione-audio',
            ),
          ]),
          el('div', classes: 'guide-cta', children: [
            el('div', children: [
              el('span', classes: 'eyebrow', children: [text('PRONTO A PROVARE?')]),
              el('h2', children: [text('Converti un tuo file direttamente dal browser')]),
              el('p', children: [
                text('Potube Web usa upload temporanei e non crea uno storico dei file elaborati.'),
              ]),
            ]),
            el('a', classes: 'primary-button', attributes: {'href': '/#convert'}, children: [
              text('Apri il convertitore'),
            ]),
          ]),
        ]),
      ]),
    );
  }

  Component _guide(String eyebrow, String title, String body, String href) {
    return el('article', classes: 'guide-card', children: [
      el('span', classes: 'eyebrow', children: [text(eyebrow)]),
      el('h2', children: [text(title)]),
      el('p', children: [text(body)]),
      el('a', classes: 'text-link', attributes: {'href': href}, children: [
        text('Leggi la guida →'),
      ]),
    ]);
  }
}
