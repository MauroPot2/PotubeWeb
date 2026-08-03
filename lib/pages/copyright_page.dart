import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:potube_web/components/site_scaffold.dart';

class CopyrightPage extends StatelessComponent {
  const CopyrightPage({super.key});

  @override
  Component build(BuildContext context) {
    return SiteScaffold(
      child: el('article', classes: 'container legal-page', children: [
        el('span', classes: 'eyebrow', children: [text('USO RESPONSABILE')]),
        el('h1', children: [text('Copyright e contenuti')]),
        el('p', classes: 'legal-updated', children: [text('Ultimo aggiornamento: 3 agosto 2026')]),
        el('p', classes: 'article-lead', children: [
          text('Potube Web è progettato per elaborare contenuti che l’utente possiede o è autorizzato a utilizzare.'),
        ]),
        el('h2', children: [text('Servizio pubblico')]),
        el('p', children: [
          text(
            'L’esperienza pubblica di Potube Web converte file caricati direttamente dal dispositivo dell’utente. '
            'Non presenta nella navigazione pubblica strumenti per acquisire contenuti da piattaforme di streaming.',
          ),
        ]),
        el('h2', children: [text('Ambienti sperimentali')]),
        el('p', children: [
          text(
            'Eventuali funzioni tecniche sperimentali o case study possono essere mantenuti separati dal servizio pubblico, '
            'protetti da accesso dedicato e non destinati all’indicizzazione. Anche in tali ambienti l’utilizzo è consentito '
            'esclusivamente per contenuti propri, di pubblico dominio o per cui esiste un’autorizzazione al download e all’elaborazione.',
          ),
        ]),
        el('h2', children: [text('Responsabilità sui diritti')]),
        el('p', children: [
          text(
            'La disponibilità tecnica di una conversione non implica che l’utente disponga automaticamente dei diritti necessari. '
            'L’utente deve verificare licenze, condizioni d’uso della fonte e normativa applicabile prima di elaborare o ridistribuire un contenuto.',
          ),
        ]),
        el('h2', children: [text('Segnalazioni')]),
        el('p', children: [
          text(
            'Le segnalazioni relative a violazioni di copyright devono identificare chiaramente l’opera interessata, il materiale contestato '
            'e il motivo della richiesta. Prima dell’attivazione commerciale definitiva verrà pubblicato un recapito dedicato per queste comunicazioni.',
          ),
        ]),
      ]),
    );
  }
}
