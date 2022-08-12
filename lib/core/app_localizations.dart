import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart' as generated;
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';

class AppLocalizations {
  AppLocalizations._();

  static generated.AppLocalizations of(BuildContext context) =>
      generated.AppLocalizations.of(context) ?? AppLocalizationsEn();
}
