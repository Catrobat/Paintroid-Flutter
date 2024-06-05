// Package imports:
import 'package:toast/toast.dart';

class ToastUtils {
  const ToastUtils._();

  static void showShortToast({required String message}) {
    Toast.show(message, duration: Toast.lengthShort, gravity: Toast.bottom);
  }
}
