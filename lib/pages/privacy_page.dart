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
        el('p', children: [
          text('Informativa tecnica della beta di Potube Web. Prima della pubblicazione definitiva va completata con i dati del titolare, i contatti e gli eventuali fornitori definitivi.'),
        ]),
        el('h2', children: [text('File caricati')]),
        el('p', children: [
          text('Il backend usa file temporanei esclusivamente per eseguire la conversione. La directory temporanea viene eliminata dopo l’invio del risultato o in caso di errore. Potube Web non offre uno storico dei file e non utilizza i file caricati per finalità pubblicitarie o di analytics.'),
        ]),
        el('h2', children: [text('Limite gratuito e protezione dagli abusi')]),
        el('p', children: [
          text('Durante la beta può essere utilizzato l’indirizzo IP, o un identificatore tecnico equivalente fornito dall’infrastruttura, per applicare un limite temporaneo alle conversioni e proteggere il servizio dagli abusi. Il contatore MVP è mantenuto in memoria e può azzerarsi al riavvio dell’istanza.'),
        ]),
        el('h2', children: [text('Analytics')]),
        el('p', children: [
          text('Google Analytics 4 può essere attivato per misurare visite e utilizzo generale del sito. Lo script Analytics viene caricato soltanto dopo il consenso esplicito dell’utente. È possibile rifiutare Analytics scegliendo “Solo necessari”.'),
        ]),
        el('h2', children: [text('Pubblicità e cookie')]),
        el('p', children: [
          text('Gli spazi pubblicitari presenti nella beta sono placeholder e non caricano reti pubblicitarie. Prima dell’attivazione di AdSense o servizi analoghi verrà adottata una CMP adeguata e questa informativa verrà aggiornata.'),
        ]),
      ]),
    );
  }
}
