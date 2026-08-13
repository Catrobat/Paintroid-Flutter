import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stickers_gallery_provider.g.dart';

@riverpod
class StickersGalleryProvider extends _$StickersGalleryProvider {
  @override
  bool build() {
    return false;
  }

  void setLoading(bool loading) {
    state = loading;
  }
}
