import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

Component el(
  String tag, {
  String? classes,
  Map<String, String>? attributes,
  List<Component> children = const [],
}) {
  return Component.element(
    tag: tag,
    classes: classes,
    attributes: attributes,
    children: children,
  );
}

class SiteScaffold extends StatelessComponent {
  const SiteScaffold({required this.child, super.key});

  final Component child;

  @override
  Component build(BuildContext context) {
    return el('div', classes: 'site-shell', children: [
      el('header', classes: 'site-header', children: [
        el('div', classes: 'container header-inner', children: [
          el(
            'a',
            classes: 'brand',
            attributes: {'href': '/', 'aria-label': 'Potube Web · Home'},
            children: [
              el('span', classes: 'brand-mark', attributes: {'aria-hidden': 'true'}, children: [text('P')]),
              el('span', children: [text('Potube')]),
            ],
          ),
          el(
            'nav',
            classes: 'main-nav',
            attributes: {'aria-label': 'Navigazione principale'},
            children: [
              el('a', attributes: {'href': '/#convert'}, children: [text('Converti')]),
              el('a', attributes: {'href': '/guide'}, children: [text('Guide')]),
              el('a', attributes: {'href': '/#faq'}, children: [text('FAQ')]),
            ],
          ),
        ]),
      ]),
      el('main', children: [child]),
      el('footer', classes: 'site-footer', children: [
        el('div', classes: 'container footer-grid footer-grid-polished', children: [
          el('div', classes: 'footer-brand', children: [
            el('strong', children: [text('Potube Web')]),
            el('p', children: [
              text('Uno strumento semplice per convertire i tuoi file multimediali in MP3, con upload temporanei e controlli chiari.'),
            ]),
          ]),
          el('div', classes: 'footer-column', children: [
            el('strong', children: [text('Esplora')]),
            el('a', attributes: {'href': '/#convert'}, children: [text('Convertitore')]),
            el('a', attributes: {'href': '/guide'}, children: [text('Guide audio')]),
            el('a', attributes: {'href': '/#faq'}, children: [text('FAQ')]),
          ]),
          el('div', classes: 'footer-column', children: [
            el('strong', children: [text('Informazioni')]),
            el('a', attributes: {'href': '/privacy'}, children: [text('Privacy')]),
            el('a', attributes: {'href': '/terms'}, children: [text('Termini')]),
            el('a', attributes: {'href': '/copyright'}, children: [text('Copyright')]),
          ]),
        ]),
        el('div', classes: 'container footer-bottom', children: [
          text('© 2026 Potube · Elabora solo contenuti che possiedi o che sei autorizzato a utilizzare.'),
        ]),
      ]),
    ]);
  }
}
