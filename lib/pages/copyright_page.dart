import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:potube_web/components/site_scaffold.dart';

class CopyrightPage extends StatelessComponent {
  const CopyrightPage({super.key});

  @override
  Component build(BuildContext context) {
    return SiteScaffold(
      child: el('article', classes: 'container legal-page', children: [
        el('h1', children: [text('Copyright e utilizzo responsabile')]),
        el('p', children: [text('Potube Web non offre una funzione di download da YouTube o da altre piattaforme di streaming. Elabora esclusivamente file caricati dall’utente.')]),
        el('p', children: [text('Prima di pubblicare il servizio, inserire qui un indirizzo di contatto dedicato alle segnalazioni relative ai diritti d’autore.')]),
      ]),
    );
  }
}
