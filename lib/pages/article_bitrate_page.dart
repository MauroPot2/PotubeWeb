import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:potube_web/components/ad_slot.dart';
import 'package:potube_web/components/site_scaffold.dart';

class ArticleBitratePage extends StatelessComponent {
  const ArticleBitratePage({super.key});

  @override
  Component build(BuildContext context) {
    return SiteScaffold(
      child: el('article', classes: 'container legal-page article-page', children: [
        el('span', classes: 'eyebrow', children: [text('GUIDA AUDIO')]),
        el('h1', children: [text('MP3: 128, 192, 256 o 320 kbps?')]),
        el('p', classes: 'article-lead', children: [
          text('Il bitrate indica quanti kilobit al secondo vengono usati per rappresentare l’audio compresso. Più alto non significa automaticamente “audio migliore”.'),
        ]),
        el('h2', children: [text('192 kbps: il default equilibrato')]),
        el('p', children: [text('Per ascolto quotidiano offre spesso un buon compromesso tra dimensione e qualità, soprattutto quando la sorgente è già compressa.')]),
        el('h2', children: [text('320 kbps: meno compressione, file più grande')]),
        el('p', children: [text('È utile quando vuoi limitare ulteriormente le perdite introdotte dalla ricodifica. Non trasforma però una sorgente compressa in lossless.')]),
        const AdSlot(label: 'Pubblicità · guida'),
        el('h2', children: [text('Quando scegliere 128 o 256 kbps')]),
        el('p', children: [text('128 kbps privilegia dimensioni ridotte; 256 kbps è un compromesso più conservativo quando lo spazio non è un problema.')]),
        el('a', classes: 'primary-button inline-button', attributes: {'href': '/#convert'}, children: [text('Apri il convertitore')]),
      ]),
    );
  }
}
