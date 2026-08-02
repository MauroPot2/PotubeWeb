import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:potube_web/components/site_scaffold.dart';

class TermsPage extends StatelessComponent {
  const TermsPage({super.key});

  @override
  Component build(BuildContext context) {
    return SiteScaffold(
      child: el('article', classes: 'container legal-page', children: [
        el('h1', children: [text('Termini di utilizzo')]),
        el('p', children: [text('Potube Web è uno strumento di conversione file. L’utente deve caricare esclusivamente contenuti che può legalmente elaborare.')]),
        el('h2', children: [text('Uso consentito')]),
        el('p', children: [text('Sono ammessi file propri, contenuti con licenza compatibile o materiali per cui l’utente dispone di autorizzazione.')]),
        el('h2', children: [text('Limitazioni')]),
        el('p', children: [text('Sono vietati usi illeciti, upload abusivi, tentativi di aggirare limiti tecnici, automazioni massive e contenuti che violano diritti di terzi.')]),
      ]),
    );
  }
}
