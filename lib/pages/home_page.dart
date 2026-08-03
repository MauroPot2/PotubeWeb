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
              el('h1', children: [text('Da media a MP3, senza complicazioni.')]),
              el('p', classes: 'hero-lead', children: [
                text(
                  'Carica un file audio o video dal tuo dispositivo, scegli le opzioni essenziali e scarica il risultato. '
                  'Potube Web è pensato per elaborazioni rapide, trasparenti e temporanee.',
                ),
              ]),
              el('div', classes: 'hero-points', children: [
                _point('File temporanei'),
                _point('3 conversioni / 24h'),
                _point('Fino a 192 kbps'),
              ]),
              el('p', classes: 'hero-note', children: [
                text('Nessun account richiesto durante la beta.'),
              ]),
            ]),
            const ConverterCard(),
          ]),
        ]),
        el('div', classes: 'container', children: [const AdSlot()]),
        el('section', classes: 'section', children: [
          el('div', classes: 'container', children: [
            el('div', classes: 'section-heading narrow', children: [
              el('span', classes: 'eyebrow', children: [text('COME FUNZIONA')]),
              el('h2', children: [text('Tre passaggi, niente confusione')]),
              el('p', children: [
                text('Il flusso è volutamente breve: il file parte dal tuo dispositivo e il risultato torna direttamente a te.'),
              ]),
            ]),
            el('div', classes: 'feature-grid', children: [
              _feature('01', 'Carica', 'Scegli un file dal tuo dispositivo. La versione pubblica non richiede URL a piattaforme di streaming.'),
              _feature('02', 'Configura', 'Scegli 128 o 192 kbps, mantieni i metadata e abilita la normalizzazione solo se ti serve.'),
              _feature('03', 'Scarica', 'FFmpeg crea l’MP3 e la directory temporanea viene rimossa dopo la risposta o in caso di errore.'),
            ]),
          ]),
        ]),
        el('section', classes: 'section section-muted', children: [
          el('div', classes: 'container trust-grid', children: [
            el('div', children: [
              el('span', classes: 'eyebrow', children: [text('PRIVACY BY DESIGN')]),
              el('h2', children: [text('Il convertitore non è un archivio')]),
              el('p', children: [
                text(
                  'Potube Web usa una directory temporanea per la conversione e non offre una libreria o uno storico dei file caricati. '
                  'I file non vengono inviati a Google Analytics.',
                ),
              ]),
              el('a', classes: 'text-link', attributes: {'href': '/privacy'}, children: [
                text('Come gestiamo i dati →'),
              ]),
            ]),
            el('div', classes: 'trust-list', children: [
              _trustItem('25 MB', 'dimensione massima nella beta'),
              _trustItem('192 kbps', 'bitrate massimo gratuito'),
              _trustItem('0 account', 'registrazione non necessaria'),
            ]),
          ]),
        ]),
        el('section', classes: 'section', children: [
          el('div', classes: 'container', children: [
            el('div', classes: 'section-heading narrow', children: [
              el('span', classes: 'eyebrow', children: [text('FORMATI')]),
              el('h2', children: [text('Audio e video comuni, un’unica uscita MP3')]),
              el('p', children: [
                text('La beta accetta i principali contenitori audio e video supportati dal backend e produce un file MP3.'),
              ]),
            ]),
            el('div', classes: 'format-list', children: [
              _format('MP4'),
              _format('MOV'),
              _format('WEBM'),
              _format('M4A'),
              _format('WAV'),
              _format('FLAC'),
              _format('AAC'),
              _format('OGG'),
              _format('MP3'),
            ]),
          ]),
        ]),
        el('section', classes: 'section section-muted', children: [
          el('div', classes: 'container', children: [
            el('div', classes: 'section-heading narrow', children: [
              el('span', classes: 'eyebrow', children: [text('IMPARA PRIMA DI CONVERTIRE')]),
              el('h2', children: [text('Scelte semplici, spiegate bene')]),
              el('p', children: [
                text('Il bitrate e la normalizzazione rispondono a problemi diversi. Le guide Potube spiegano quando usarli e quando lasciarli stare.'),
              ]),
            ]),
            el('div', classes: 'guide-grid', children: [
              _guide(
                'Bitrate MP3',
                '128, 192, 256 o 320 kbps?',
                'Perché un bitrate più alto non può recuperare qualità già persa nella sorgente.',
                '/guide/mp3-bitrate',
              ),
              _guide(
                'Normalizzazione',
                'Uniformare il volume senza confonderlo con il gain',
                'Quando loudness e picchi contano più del semplice “alzare il volume”.',
                '/guide/normalizzazione-audio',
              ),
            ]),
            el('a', classes: 'text-link guides-all-link', attributes: {'href': '/guide'}, children: [
              text('Vedi tutte le guide →'),
            ]),
          ]),
        ]),
        el('section', classes: 'section', attributes: {'id': 'faq'}, children: [
          el('div', classes: 'container narrow', children: [
            el('div', classes: 'section-heading', children: [
              el('span', classes: 'eyebrow', children: [text('FAQ')]),
              el('h2', children: [text('Domande frequenti')]),
            ]),
            _faq('Posso inserire un link YouTube?', 'No. Il servizio pubblico è progettato per elaborare esclusivamente file caricati direttamente dall’utente.'),
            _faq('Quante conversioni posso fare?', 'Durante la beta gratuita il limite è di 3 conversioni ogni 24 ore per utente/IP. Il contatore MVP è best-effort e serve soprattutto a ridurre gli abusi.'),
            _faq('Quanto rimane online il mio file?', 'La conversione usa una directory temporanea che viene eliminata dopo l’invio del risultato oppure quando la richiesta termina con un errore.'),
            _faq('Che cosa fa la normalizzazione?', 'Cerca di rendere più coerente il livello percepito dell’audio durante la conversione. Non migliora la qualità della sorgente e non è sempre necessaria.'),
            _faq('Perché il limite è 192 kbps?', 'La fase beta mantiene volutamente contenuti i tempi di elaborazione e i costi operativi. Le opzioni superiori potranno essere valutate in una versione futura.'),
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

  Component _trustItem(String value, String label) => el('div', classes: 'trust-item', children: [
        el('strong', children: [text(value)]),
        el('span', children: [text(label)]),
      ]);

  Component _format(String value) => el('span', classes: 'format-chip', children: [text(value)]);

  Component _guide(String eyebrow, String title, String body, String href) =>
      el('article', classes: 'guide-card compact-guide-card', children: [
        el('span', classes: 'eyebrow', children: [text(eyebrow)]),
        el('h3', children: [text(title)]),
        el('p', children: [text(body)]),
        el('a', classes: 'text-link', attributes: {'href': href}, children: [text('Leggi →')]),
      ]);

  Component _faq(String title, String body) => el('details', classes: 'faq-item', children: [
        el('summary', children: [text(title)]),
        el('p', children: [text(body)]),
      ]);
}
