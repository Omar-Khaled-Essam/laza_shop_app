import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'blocs/cart/cart_bloc.dart';
import 'blocs/product/product_cubit.dart';
import 'blocs/theme/theme_bloc.dart';
import 'blocs/theme/theme_state.dart';
import 'l10n/app_strings.dart';
import 'models/product_model.dart';
import 'screens/cart_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/sign_up_screen.dart';
import 'services/cache_helper.dart';
import 'services/product_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cache = CacheHelper();
  await cache.init();

  runApp(LazaShopApp(productService: ProductService(cache)));
}

class LazaShopApp extends StatefulWidget {
  const LazaShopApp({super.key, required this.productService});

  final ProductService productService;

  @override
  State<LazaShopApp> createState() => _LazaShopAppState();
}

class _LazaShopAppState extends State<LazaShopApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  Locale _locale = const Locale('en');

  void _toggleLocale() {
    setState(() {
      _locale = _locale.languageCode == 'en'
          ? const Locale('ar')
          : const Locale('en');
    });
  }

  /// Sign Up -> Home with a fade transition.
  void _goHome() {
    _navigatorKey.currentState?.pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) =>
            HomeScreen(onToggleLocale: _toggleLocale),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  ThemeData _theme(Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF9775FA),
        brightness: brightness,
      ),
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/cart':
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const CartScreen(),
        );
      case '/product-details':
        final product = settings.arguments;
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (context) => product is ProductModel
              ? ProductDetailsScreen(product: product)
              : Scaffold(
                  appBar: AppBar(),
                  body: Center(child: Text(context.strings.t('invalidProduct'))),
                ),
        );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeBloc()),
        BlocProvider(create: (_) => CartBloc()),
        BlocProvider(
          create: (_) => ProductCubit(widget.productService)..loadProducts(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            navigatorKey: _navigatorKey,
            debugShowCheckedModeBanner: false,
            onGenerateTitle: (ctx) => ctx.strings.t('appName'),
            locale: _locale,
            supportedLocales: const [Locale('en'), Locale('ar')],
            localizationsDelegates: const [
              AppStrings.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: _theme(Brightness.light),
            darkTheme: _theme(Brightness.dark),
            themeMode: themeState.mode,
            // The app now starts on Sign Up (not the API test screen).
            home: SignUpScreen(
              onComplete: _goHome,
              onToggleLocale: _toggleLocale,
            ),
            onGenerateRoute: _onGenerateRoute,
          );
        },
      ),
    );
  }
}
