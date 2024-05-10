// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:toast/toast.dart';

// Project imports:
import 'package:paintroid/ui/pages/onboarding_page/screens/screen1.dart';
import 'package:paintroid/ui/pages/onboarding_page/screens/screen2.dart';
import 'package:paintroid/ui/pages/onboarding_page/screens/screen3.dart';
import 'package:paintroid/ui/pages/onboarding_page/screens/screen4.dart';
import 'package:paintroid/ui/pages/onboarding_page/screens/screen5.dart';
import 'package:paintroid/ui/theme/theme.dart';

class OnboardingPage extends StatefulWidget {
  final Widget? navigateTo;

  const OnboardingPage({super.key, this.navigateTo});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  bool _isLastPage = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );
    super.dispose();
  }

  Future<void> finish() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('showOnboarding', false);
    if (mounted) {
      if (widget.navigateTo == null) {
        Navigator.pop(context);
      } else {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => widget.navigateTo!,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() => _isLastPage = index == 4);
                },
                children: const [
                  Screen1(),
                  Screen2(),
                  Screen3(),
                  Screen4(),
                  Screen5(),
                ],
              ),
            ),
            Container(
              height: 1,
              color: PaintroidTheme.of(context).onSurfaceColor,
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: PaintroidTheme.of(context).surfaceColor,
        height: 40,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: TextButton(
                onPressed: () => finish(),
                child: Text(
                  _isLastPage ? '' : 'SKIP',
                  style: TextStyle(
                    color: PaintroidTheme.of(context).onSurfaceColor,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            SmoothPageIndicator(
              count: 5,
              controller: _controller,
              effect: SlideEffect(
                dotColor:
                    PaintroidTheme.of(context).onSurfaceColor.withOpacity(0.2),
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: PaintroidTheme.of(context).onSurfaceColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: TextButton(
                onPressed: () async {
                  if (_isLastPage) {
                    finish();
                  } else {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: Text(
                  _isLastPage ? "LET'S GO" : 'NEXT',
                  style: TextStyle(
                    color: PaintroidTheme.of(context).onSurfaceColor,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
