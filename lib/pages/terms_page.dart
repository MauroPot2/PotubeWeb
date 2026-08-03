import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:potube_web/components/site_scaffold.dart';

class TermsPage extends StatelessComponent {
  const TermsPage({super.key});

  @override
  Component build(BuildContext context) {
    return SiteScaffold(
      child: el('article', classes: 'container legal-page', children: [
        el('span', classes: 'eyebrow', children: [text('INFORMAZIONI LEGALI')]),
        el('h1', children: [text('Termini di utilizzo')]),
        el('p', classes: 'legal-updated', children: [text('Ultimo aggiornamento: 3 agosto 2026')]),
        el('p', classes: 'article-lead', children: [
          text('Potube Web è uno strumento di conversione multimediale. Utilizzandolo accetti di farlo in modo lecito, responsabile e compatibile con i diritti di terzi.'),
        ]),
        el('h2', children: [text('Uso consentito')]),
        el('p', children: [
          text('Puoi elaborare file di tua proprietà, contenuti di pubblico dominio, materiali con licenza compatibile o contenuti per cui disponi di un’autorizzazione sufficiente.'),
        ]),
        el('h2', children: [text('Uso vietato')]),
        el('p', children: [
          text('Non sono consentiti utilizzi illeciti, violazioni di copyright o altri diritti, upload abusivi, tentativi di aggirare i limiti tecnici, automazioni massive, attacchi al servizio o uso del convertitore come infrastruttura per distribuzioni non autorizzate.'),
        ]),
        el('h2', children: [text('Beta e disponibilità del servizio')]),
        el('p', children: [
          text('Potube Web è attualmente in beta. Limiti, formati supportati, tempi di elaborazione e funzionalità possono cambiare. Il servizio può essere temporaneamente sospeso per manutenzione, sicurezza, contenimento dei costi o problemi dell’infrastruttura.'),
        ]),
        el('h2', children: [text('Responsabilità dell’utente')]),
        el('p', children: [
          text('Sei responsabile dei file che scegli di elaborare e della legittimità del relativo utilizzo. La conferma richiesta nel modulo di conversione non trasferisce al gestore del sito la responsabilità per i contenuti caricati.'),
        ]),
        el('h2', children: [text('Limitazione tecnica')]),
        el('p', children: [
          text('La conversione può fallire a causa del formato, della corruzione del file, dei limiti di dimensione, del timeout o di altre condizioni tecniche. Potube Web non garantisce che ogni file sia convertibile né che la ricodifica migliori la qualità della sorgente.'),
        ]),
        el('h2', children: [text('Modifiche ai termini')]),
        el('p', children: [
          text('Questi termini possono essere aggiornati quando cambiano il servizio, i fornitori utilizzati o gli obblighi applicabili. La data di ultimo aggiornamento indica la versione attualmente pubblicata.'),
        ]),
      ]),
    );
  }
}
