import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:potube_web/components/site_scaffold.dart';

class PrivacyPage extends StatelessComponent {
  const PrivacyPage({super.key});

  @override
  Component build(BuildContext context) {
    return SiteScaffold(
      child: el('article', classes: 'container legal-page', children: [
        el('h1', children: [text('Privacy Policy')]),
        el('p', children: [text('Bozza tecnica da completare prima della pubblicazione con titolare, contatti, provider, basi giuridiche, tempi di conservazione e configurazione effettiva di analytics/cookie.')]),
        el('h2', children: [text('File caricati')]),
        el('p', children: [text('Il backend MVP usa file temporanei per eseguire la conversione. La directory temporanea viene eliminata dopo l’invio del risultato o in caso di errore.')]),
        el('h2', children: [text('Pubblicità e cookie')]),
        el('p', children: [text('Gli spazi pubblicitari presenti nell’MVP sono solo placeholder. Prima di attivare reti pubblicitarie va configurata una CMP e aggiornata questa informativa.')]),
      ]),
    );
  }
}
