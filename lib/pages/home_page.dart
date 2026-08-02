import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:potube_web/components/ad_slot.dart';
import 'package:potube_web/components/converter_card.dart';
import 'package:potube_web/components/site_scaffold.dart';

class HomePage extends StatelessComponent {
  const HomePage({super.key});

  @override
  Component build(BuildContext context) {
    return SiteScaffold(
      child: el('div', children: [
        el('section', classes: 'hero', children: [
          el('div', classes: 'container hero-grid', children: [
            el('div', classes: 'hero-copy', children: [
              el('span', classes: 'pill', children: [text('Potube Web · beta gratuita')]),
              el('h1', children: [text('Il tuo media. Il tuo audio.')]),
              el('p', classes: 'hero-lead', children: [
                text('Converti i tuoi file audio e video in MP3 con una procedura semplice, temporanea e pensata per il web.'),
              ]),
              el('div', classes: 'hero-points', children: [
                _point('Upload temporanei'),
                _point('3 conversioni / 24h'),
                _point('Fino a 192 kbps'),
              ]),
            ]),
            const ConverterCard(),
          ]),
        ]),
        el('div', classes: 'container', children: [const AdSlot()]),
        el('section', classes: 'section', children: [
          el('div', classes: 'container', children: [
            el('div', classes: 'section-heading', children: [
              el('span', classes: 'eyebrow', children: [text('COME FUNZIONA')]),
              el('h2', children: [text('Tre passaggi, niente confusione')]),
            ]),
            el('div', classes: 'feature-grid', children: [
              _feature('01', 'Carica', 'Scegli un file dal tuo dispositivo. Non accettiamo link a piattaforme video.'),
              _feature('02', 'Configura', 'Seleziona bitrate, metadata e normalizzazione del volume.'),
              _feature('03', 'Scarica', 'FFmpeg crea l’MP3 e il file temporaneo viene rimosso dopo la risposta.'),
            ]),
          ]),
        ]),
        el('section', classes: 'section section-muted', children: [
          el('div', classes: 'container content-grid', children: [
            el('article', children: [
              el('span', classes: 'eyebrow', children: [text('GUIDA RAPIDA')]),
              el('h2', children: [text('128 o 192 kbps?')]),
              el('p', children: [
                text('Il bitrate definisce quanto spazio usa l’MP3. Un bitrate più alto riduce la compressione, ma non può ricreare dettagli che non esistono nella sorgente.'),
              ]),
              el('a', classes: 'text-link', attributes: {'href': '/guide/mp3-bitrate'}, children: [
                text('Leggi la guida completa →'),
              ]),
            ]),
            const AdSlot(label: 'Pubblicità · contenuto'),
          ]),
        ]),
        el('section', classes: 'section', attributes: {'id': 'faq'}, children: [
          el('div', classes: 'container narrow', children: [
            el('div', classes: 'section-heading', children: [
              el('span', classes: 'eyebrow', children: [text('FAQ')]),
              el('h2', children: [text('Domande frequenti')]),
            ]),
            _faq('Posso inserire un link YouTube?', 'No. La versione web è progettata per elaborare esclusivamente file caricati direttamente dall’utente.'),
            _faq('Quante conversioni posso fare?', 'Durante la beta gratuita il limite è di 3 conversioni ogni 24 ore per utente/IP. Il contatore MVP è best-effort e serve soprattutto a ridurre abusi.'),
            _faq('Quanto rimane online il mio file?', 'La conversione usa una directory temporanea che viene eliminata dopo l’invio del file risultante.'),
            _faq('Perché il limite è 192 kbps?', 'La fase di validazione mantiene bassi i costi operativi. I bitrate 256 e 320 kbps sono previsti per la futura versione Pro.'),
          ]),
        ]),
      ]),
    );
  }

  Component _point(String value) => el('span', children: [text('✓ $value')]);

  Component _feature(String number, String title, String body) => el('article', classes: 'feature-card', children: [
        el('span', classes: 'feature-number', children: [text(number)]),
        el('h3', children: [text(title)]),
        el('p', children: [text(body)]),
      ]);

  Component _faq(String title, String body) => el('details', classes: 'faq-item', children: [
        el('summary', children: [text(title)]),
        el('p', children: [text(body)]),
      ]);
}
