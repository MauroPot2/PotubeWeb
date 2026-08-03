import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:potube_web/components/site_scaffold.dart';

class PrivacyPage extends StatelessComponent {
  const PrivacyPage({super.key});

  @override
  Component build(BuildContext context) {
    return SiteScaffold(
      child: el('article', classes: 'container legal-page', children: [
        el('span', classes: 'eyebrow', children: [text('INFORMAZIONI LEGALI')]),
        el('h1', children: [text('Privacy Policy')]),
        el('p', classes: 'legal-updated', children: [text('Ultimo aggiornamento: 3 agosto 2026')]),
        el('p', classes: 'article-lead', children: [
          text(
            'Questa informativa descrive in modo trasparente quali dati tecnici può trattare Potube Web durante l’uso del sito e del convertitore.',
          ),
        ]),
        el('h2', children: [text('File caricati e conversione')]),
        el('p', children: [
          text(
            'I file inviati al convertitore vengono salvati in una directory temporanea esclusivamente per il tempo necessario '
            'all’elaborazione. La directory viene rimossa dopo l’invio del risultato oppure quando la richiesta termina con un errore. '
            'Potube Web non offre uno storico dei file caricati e non utilizza il loro contenuto per finalità pubblicitarie o di analytics.',
          ),
        ]),
        el('h2', children: [text('Dati tecnici e protezione dagli abusi')]),
        el('p', children: [
          text(
            'L’indirizzo IP, o un identificatore tecnico equivalente fornito dall’infrastruttura, può essere utilizzato temporaneamente '
            'per applicare limiti di utilizzo, proteggere il servizio da richieste abusive e garantire la stabilità del convertitore. '
            'Durante la beta il contatore anti-abuso è mantenuto in memoria e può azzerarsi quando l’istanza viene riavviata.',
          ),
        ]),
        el('h2', children: [text('Google Analytics')]),
        el('p', children: [
          text(
            'Google Analytics 4 può essere utilizzato per misurare visite e utilizzo generale del sito. Nel setup Potube lo script '
            'Analytics viene caricato solo dopo una scelta positiva dell’utente. I file caricati nel convertitore non vengono inviati ad Analytics.',
          ),
        ]),
        el('h2', children: [text('Pubblicità, AdSense e consenso')]),
        el('p', children: [
          text(
            'Potube Web può utilizzare Google AdSense per mostrare annunci. Quando richiesto dalla normativa applicabile, la gestione '
            'del consenso pubblicitario viene affidata a una piattaforma di gestione del consenso compatibile con i requisiti Google. '
            'Le preferenze dell’utente possono influire sulla personalizzazione e sulla misurazione degli annunci.',
          ),
        ]),
        el('h2', children: [text('Cookie e archiviazione locale')]),
        el('p', children: [
          text(
            'Il sito può utilizzare tecnologie di archiviazione locale per ricordare le preferenze privacy. Servizi di terze parti '
            'come Analytics o AdSense possono utilizzare cookie o tecnologie analoghe solo secondo le impostazioni di consenso applicabili.',
          ),
        ]),
        el('h2', children: [text('Conservazione')]),
        el('p', children: [
          text(
            'Potube limita la conservazione dei dati tecnici a quanto necessario per erogare e proteggere il servizio. I file di conversione '
            'sono temporanei; eventuali dati gestiti da fornitori terzi seguono i rispettivi criteri di conservazione e le configurazioni adottate.',
          ),
        ]),
        el('h2', children: [text('Diritti e richieste')]),
        el('p', children: [
          text(
            'Per richieste relative a privacy, dati personali o esercizio dei diritti previsti dalla normativa applicabile è necessario '
            'utilizzare il canale di contatto del gestore del sito. Prima dell’attivazione commerciale definitiva verrà pubblicato un recapito dedicato.',
          ),
        ]),
      ]),
    );
  }
}
