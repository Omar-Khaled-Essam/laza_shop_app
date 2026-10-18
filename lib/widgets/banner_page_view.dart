import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';

class BannerPageView extends StatefulWidget {
  const BannerPageView({super.key});
  @override
  State<BannerPageView> createState() => _BannerPageViewState();
}

class _BannerPageViewState extends State<BannerPageView> {
  final PageController _controller = PageController(viewportFraction: .92);
  int _index = 0;
  final List<String> _images = const [
    'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg',
    'https://fakestoreapi.com/img/71li-9x2X-L._AC_UL320_.jpg',
    'https://fakestoreapi.com/img/71YXzeOuslL._AC_UY879_.jpg',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 158,
          child: PageView.builder(
            controller: _controller,
            itemCount: _images.length,
            onPageChanged: (index) => setState(() => _index = index),
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    _images[index],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                  Container(
                    padding: const EdgeInsets.all(18),
                    alignment: context.strings.isArabic
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: context.strings.isArabic
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        end: context.strings.isArabic
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        colors: [Colors.black.withValues(alpha: .7), Colors.transparent],
                      ),
                    ),
                    child: Text(
                      context.strings.t('hotOffers'),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _images.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: index == _index ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: index == _index
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
