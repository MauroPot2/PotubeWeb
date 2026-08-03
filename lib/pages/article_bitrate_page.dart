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
          text(
            'Il bitrate indica quanti kilobit al secondo vengono destinati all’audio compresso. '
            'Più alto significa generalmente meno compressione, ma non significa automaticamente “audio migliore”.',
          ),
        ]),
        el('h2', children: [text('La qualità della sorgente viene prima del bitrate')]),
        el('p', children: [
          text(
            'Se la sorgente ha già perso dettaglio a causa di una precedente compressione, esportarla a 320 kbps non può ricostruire '
            'le informazioni mancanti. Il bitrate di uscita decide come comprimere ciò che è disponibile in quel momento.',
          ),
        ]),
        el('h2', children: [text('128 kbps: quando conta soprattutto lo spazio')]),
        el('p', children: [
          text(
            'Può essere sufficiente per parlato, bozze, ascolto non critico o quando la dimensione del file è più importante della fedeltà. '
            'Su materiale musicale complesso le differenze possono diventare più percepibili.',
          ),
        ]),
        el('h2', children: [text('192 kbps: il compromesso della beta Potube')]),
        el('p', children: [
          text(
            'Per molti utilizzi quotidiani offre un equilibrio ragionevole tra dimensione e compressione. Per questo Potube Web lo usa '
            'come valore predefinito nella beta gratuita.',
          ),
        ]),
        const AdSlot(label: 'Pubblicità · guida'),
        el('h2', children: [text('256 e 320 kbps: meno compressione, file più grandi')]),
        el('p', children: [
          text(
            'Sono opzioni più conservative quando vuoi ridurre ulteriormente le perdite introdotte da una nuova codifica. '
            'Restano però formati lossy e non trasformano una sorgente compressa in audio lossless.',
          ),
        ]),
        el('h2', children: [text('Regola pratica')]),
        el('p', children: [
          text(
            'Se non hai un requisito specifico, parti dalla sorgente migliore disponibile e scegli il bitrate in base all’uso finale. '
            'Per ascolto comune 192 kbps è spesso una scelta sensata; per voce o file leggeri 128 kbps può bastare.',
          ),
        ]),
        el('div', classes: 'article-actions', children: [
          el('a', classes: 'primary-button inline-button', attributes: {'href': '/#convert'}, children: [
            text('Apri il convertitore'),
          ]),
          el('a', classes: 'text-link', attributes: {'href': '/guide'}, children: [
            text('Tutte le guide →'),
          ]),
        ]),
      ]),
    );
  }
}
