import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:potube_web/components/site_scaffold.dart';

class AdSlot extends StatelessComponent {
  const AdSlot({this.label = 'Pubblicità', super.key});

  final String label;

  @override
  Component build(BuildContext context) {
    return el(
      'aside',
      classes: 'ad-slot',
      attributes: {
        'aria-label': label,
        'data-ad-placeholder': 'true',
      },
      children: [
        el('span', classes: 'ad-label', children: [text(label)]),
        el('div', classes: 'ad-placeholder', children: [text('Spazio pubblicitario')]),
      ],
    );
  }
}
