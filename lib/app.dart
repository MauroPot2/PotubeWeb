import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:potube_web/pages/article_bitrate_page.dart';
import 'package:potube_web/pages/copyright_page.dart';
import 'package:potube_web/pages/home_page.dart';
import 'package:potube_web/pages/privacy_page.dart';
import 'package:potube_web/pages/terms_page.dart';

class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    return Router(
      routes: [
        Route(path: '/', builder: (context, state) => const HomePage()),
        Route(path: '/privacy', builder: (context, state) => const PrivacyPage()),
        Route(path: '/terms', builder: (context, state) => const TermsPage()),
        Route(path: '/copyright', builder: (context, state) => const CopyrightPage()),
        Route(path: '/guide/mp3-bitrate', builder: (context, state) => const ArticleBitratePage()),
      ],
    );
  }
}
