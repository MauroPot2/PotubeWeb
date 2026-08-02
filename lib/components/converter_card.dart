import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class ConverterCard extends StatelessComponent {
  const ConverterCard({super.key});

  @override
  Component build(BuildContext context) {
    return el('section', classes: 'converter-card', attributes: {'id': 'convert'}, children: [
      el('div', classes: 'converter-heading', children: [
        el('span', classes: 'eyebrow', children: [text('MEDIA → MP3')]),
        el('h2', children: [text('Converti un tuo file in MP3')]),
        el('p', children: [
          text('Il file viene usato solo per la conversione e rimosso dal server al termine della richiesta.'),
        ]),
      ]),
      el('div', classes: 'free-badge', children: [
        el('strong', children: [text('Free beta')]),
        text(' · 3 conversioni ogni 24 ore · max 25 MB · fino a 192 kbps'),
      ]),
      el(
        'form',
        classes: 'converter-form',
        attributes: {
          'action': '/api/convert',
          'method': 'post',
          'enctype': 'multipart/form-data',
        },
        children: [
          el('label', classes: 'dropzone', attributes: {'for': 'media-file'}, children: [
            el('span', classes: 'drop-icon', children: [text('↑')]),
            el('strong', children: [text('Scegli un file audio o video')]),
            el('span', children: [text('MP4, MOV, WEBM, M4A, WAV, FLAC, AAC, MP3 · max 25 MB')]),
            el('input', attributes: {
              'id': 'media-file',
              'name': 'file',
              'type': 'file',
              'accept': 'audio/*,video/*',
              'required': '',
            }),
          ]),
          el('div', classes: 'form-grid', children: [
            el('label', classes: 'field', children: [
              el('span', children: [text('Qualità MP3')]),
              el('select', attributes: {'name': 'quality'}, children: [
                _option('128', '128 kbps'),
                _option('192', '192 kbps', selected: true),
              ]),
              el('small', classes: 'field-hint', children: [text('256 e 320 kbps arriveranno con Potube Pro.')]),
            ]),
            el('div', classes: 'checks', children: [
              _check('normalize', 'Normalizza il volume'),
              _check('metadata', 'Mantieni i metadata', checked: true),
            ]),
          ]),
          el('label', classes: 'legal-check', children: [
            el('input', attributes: {'type': 'checkbox', 'name': 'rights_confirmed', 'value': 'yes', 'required': ''}),
            el('span', children: [
              text('Confermo di avere i diritti o l’autorizzazione necessaria per elaborare questo file.'),
            ]),
          ]),
          el('button', classes: 'primary-button', attributes: {'type': 'submit'}, children: [
            text('Converti in MP3'),
          ]),
          el('p', classes: 'microcopy', children: [
            text('Nessun URL YouTube: Potube Web elabora esclusivamente file caricati direttamente dall’utente.'),
          ]),
        ],
      ),
    ]);
  }

  Component _option(String value, String label, {bool selected = false}) {
    return el(
      'option',
      attributes: {
        'value': value,
        if (selected) 'selected': '',
      },
      children: [text(label)],
    );
  }

  Component _check(String name, String label, {bool checked = false}) {
    return el('label', classes: 'check-row', children: [
      el('input', attributes: {
        'type': 'checkbox',
        'name': name,
        'value': 'yes',
        if (checked) 'checked': '',
      }),
      el('span', children: [text(label)]),
    ]);
  }
}
