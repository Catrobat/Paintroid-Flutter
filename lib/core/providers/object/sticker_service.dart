import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxidized/oxidized.dart';

import 'package:paintroid/core/models/loggable_mixin.dart';
import 'package:paintroid/core/providers/object/image_service.dart';
import 'package:paintroid/core/utils/failure.dart';
import 'package:paintroid/core/utils/load_image_failure.dart';

abstract class IStickerService {
  Future<Result<ui.Image, Failure>> downloadSticker(String url);

  static final provider = Provider<IStickerService>((ref) {
    final imageService = ref.watch(IImageService.provider);
    return StickerService(imageService);
  });
}

class StickerService with LoggableMixin implements IStickerService {
  final IImageService _imageService;

  StickerService(this._imageService);

  @override
  Future<Result<ui.Image, Failure>> downloadSticker(String url) async {
    final client = HttpClient();
    client.badCertificateCallback = (cert, host, port) => true;

    try {
      final uri = Uri.parse(url);
      logger.info('Downloading sticker from: $uri');

      final request = await client.getUrl(uri);
      final response = await request.close();

      if (response.statusCode != HttpStatus.ok) {
        logger.severe('Sticker download failed with status ${response.statusCode}');
        return const Result.err(LoadImageFailure.unidentified);
      }

      final bytes = await consolidateHttpClientResponseBytes(response);

      if (bytes.isEmpty) {
        logger.severe('Downloaded sticker bytes are empty');
        return const Result.err(LoadImageFailure.invalidImage);
      }

      return await _imageService.import(bytes);
    } catch (e, stacktrace) {
      logger.severe('Error downloading sticker', e, stacktrace);
      return const Result.err(LoadImageFailure.unidentified);
    } finally {
      client.close();
    }
  }
}
