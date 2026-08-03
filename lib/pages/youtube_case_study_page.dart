import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:potube_web/components/site_scaffold.dart';

class YoutubeCaseStudyPage extends StatelessComponent {
  const YoutubeCaseStudyPage({super.key});

  static const _inputStyle =
      'width:100%;border:1px solid var(--line);background:#10141c;color:var(--text);'
      'border-radius:13px;padding:12px 14px;';

  @override
  Component build(BuildContext context) {
    return SiteScaffold(
      child: el('section', classes: 'section', children: [
        el('div', classes: 'container narrow', children: [
          el('span', classes: 'pill', children: [text('Potube Lab · case study')]),
          el('h1', attributes: {
            'style': 'font-size:clamp(42px,7vw,70px);line-height:1;letter-spacing:-.05em;margin:14px 0 18px;',
          }, children: [text('YouTube → MP3')]),
          el('p', classes: 'article-lead', children: [
            text(
              'Pagina sperimentale non presente nella navigazione pubblica. '
              'Usala esclusivamente con contenuti tuoi, di pubblico dominio o per cui hai ricevuto il permesso al download.',
            ),
          ]),
          el('div', classes: 'free-badge', children: [
            el('strong', children: [text('Accesso protetto · ')]),
            text(
              'la funzionalità è disabilitata se sul backend non è configurata la chiave privata del case study. '
              'La chiave non viene salvata nel sito o nel repository.',
            ),
          ]),
          el('div', classes: 'converter-card', attributes: {
            'style': 'margin-top:28px;',
          }, children: [
            el('div', classes: 'converter-heading', children: [
              el('span', classes: 'eyebrow', children: [text('LAB')]),
              el('h2', children: [text('Estrai una traccia audio')]),
              el('p', children: [
                text('Singolo video, niente playlist, massimo 15 minuti e massimo 192 kbps.'),
              ]),
            ]),
            el(
              'form',
              classes: 'converter-form',
              attributes: {
                'action': '/api/lab/youtube-audio',
                'method': 'post',
              },
              children: [
                el('label', classes: 'field', children: [
                  text('URL YouTube'),
                  el('input', attributes: {
                    'type': 'url',
                    'name': 'url',
                    'placeholder': 'https://www.youtube.com/watch?v=…',
                    'required': 'required',
                    'autocomplete': 'off',
                    'style': _inputStyle,
                  }),
                  el('span', classes: 'field-hint', children: [
                    text('Sono accettati solo youtube.com, music.youtube.com e youtu.be.'),
                  ]),
                ]),
                el('div', classes: 'form-grid', children: [
                  el('label', classes: 'field', children: [
                    text('Qualità MP3'),
                    el('select', attributes: {'name': 'quality'}, children: [
                      el('option', attributes: {'value': '128'}, children: [text('128 kbps')]),
                      el('option', attributes: {'value': '192', 'selected': 'selected'}, children: [text('192 kbps')]),
                    ]),
                  ]),
                  el('label', classes: 'field', children: [
                    text('Chiave case study'),
                    el('input', attributes: {
                      'type': 'password',
                      'name': 'case_study_key',
                      'placeholder': 'Chiave privata',
                      'required': 'required',
                      'autocomplete': 'off',
                      'style': _inputStyle,
                    }),
                  ]),
                ]),
                el('label', classes: 'legal-check', children: [
                  el('input', attributes: {
                    'type': 'checkbox',
                    'name': 'rights_confirmed',
                    'value': 'yes',
                    'required': 'required',
                  }),
                  el('span', children: [
                    text(
                      'Confermo di avere il diritto o il permesso di scaricare ed elaborare questo contenuto.',
                    ),
                  ]),
                ]),
                el('button', classes: 'primary-button', attributes: {'type': 'submit'}, children: [
                  text('Scarica MP3'),
                ]),
                el('p', classes: 'microcopy', children: [
                  text('Il file temporaneo viene eliminato dopo l’invio della risposta.'),
                ]),
              ],
            ),
          ]),
        ]),
      ]),
    );
  }
}
