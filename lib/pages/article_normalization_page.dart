import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:potube_web/components/ad_slot.dart';
import 'package:potube_web/components/site_scaffold.dart';

class ArticleNormalizationPage extends StatelessComponent {
  const ArticleNormalizationPage({super.key});

  @override
  Component build(BuildContext context) {
    return SiteScaffold(
      child: el('article', classes: 'container legal-page article-page', children: [
        el('span', classes: 'eyebrow', children: [text('GUIDA AUDIO')]),
        el('h1', children: [text('Normalizzare l’audio: cosa significa davvero')]),
        el('p', classes: 'article-lead', children: [
          text(
            'La normalizzazione serve a portare il livello percepito dell’audio verso un obiettivo coerente. '
            'Non migliora una registrazione scadente e non recupera dettagli che non esistono nella sorgente.',
          ),
        ]),
        el('h2', children: [text('Non è semplicemente “alzare il volume”')]),
        el('p', children: [
          text(
            'Aumentare il gain sposta tutto il segnale verso l’alto. Una normalizzazione basata sulla loudness, invece, '
            'valuta il livello percepito e cerca un risultato più uniforme, rispettando anche i picchi.',
          ),
        ]),
        el('h2', children: [text('Quando è utile')]),
        el('p', children: [
          text(
            'Può essere utile per parlato, registrazioni provenienti da fonti diverse o raccolte di file che risultano molto '
            'disomogenei tra loro. Se il file è già ben bilanciato, la normalizzazione può essere superflua.',
          ),
        ]),
        const AdSlot(label: 'Pubblicità · guida'),
        el('h2', children: [text('Cosa fa Potube Web')]),
        el('p', children: [
          text(
            'Quando abiliti “Normalizza il volume”, il backend usa il filtro loudnorm di FFmpeg durante la conversione. '
            'È una ricodifica: per questo conviene partire dal file sorgente migliore che possiedi.',
          ),
        ]),
        el('h2', children: [text('Normalizzazione e bitrate sono due scelte diverse')]),
        el('p', children: [
          text(
            'Il bitrate riguarda quanta informazione viene destinata all’audio compresso; la normalizzazione riguarda il livello '
            'percepito. Impostare un bitrate più alto non rende automaticamente il volume più uniforme, e viceversa.',
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
