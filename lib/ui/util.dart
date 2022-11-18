import 'package:url_launcher/url_launcher.dart';

void openUrl(url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}
