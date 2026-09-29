
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import 'package:paintroid/core/providers/object/sticker_service.dart';
import 'package:paintroid/core/providers/state/stickers_gallery_provider.dart';

class StickersGalleryPage extends ConsumerStatefulWidget {
  const StickersGalleryPage({super.key});

  @override
  ConsumerState<StickersGalleryPage> createState() => _StickersGalleryPageState();
}

class _StickersGalleryPageState extends ConsumerState<StickersGalleryPage> {
  late final WebViewController _controller;

  static const String _figuresUrl = 'https://catrobat.org/figures-download/';

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => ref.read(stickersGalleryProvider.notifier).setLoading(true),
          onPageFinished: (url) async {
            if (!mounted) return;
            ref.read(stickersGalleryProvider.notifier).setLoading(false);

            await _controller.runJavaScript('''
              const buttons = document.querySelectorAll('a, button');
              buttons.forEach(function(element) {
                const text = element.innerText.trim().toLowerCase();
                if (text === 'show figures') {
                  element.click();
                }
              });
            ''');
          },
          onWebResourceError: (error) {
            debugPrint('WebView error: ${error.description}');
          },
          onNavigationRequest: (request) {
            final url = request.url;
            if (_isImageUrl(url)) {
              _downloadAndReturnImage(url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(_figuresUrl));
  }

  bool _isImageUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    final path = uri.path.toLowerCase();
    return path.endsWith('.png') ||
        path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.webp');
  }

  Future<void> _downloadAndReturnImage(String url) async {
    final notifier = ref.read(stickersGalleryProvider.notifier);
    notifier.setLoading(true);

    final stickerService = ref.read(IStickerService.provider);
    final result = await stickerService.downloadSticker(url);

    result.match(
      (image) {
        if (mounted) {
          Navigator.of(context).pop(image);
        } else {
          image.dispose();
        }
      },
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to download sticker.')),
          );
        }
      },
    );

    if (mounted) {
      notifier.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(stickersGalleryProvider);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _buildWebView(),
            if (isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget _buildWebView() {
    if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      return WebViewWidget.fromPlatformCreationParams(
        key: const ValueKey('stickers_webview'),
        params: AndroidWebViewWidgetCreationParams(
          controller: _controller.platform,
          displayWithHybridComposition: true,
        ),
      );
    }
    return WebViewWidget(controller: _controller);
  }
}
