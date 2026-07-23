import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'colorpicker_localizations_de.dart';
import 'colorpicker_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of ColorPickerLocalizations
/// returned by `ColorPickerLocalizations.of(context)`.
///
/// Applications need to include `ColorPickerLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/colorpicker_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: ColorPickerLocalizations.localizationsDelegates,
///   supportedLocales: ColorPickerLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the ColorPickerLocalizations.supportedLocales
/// property.
abstract class ColorPickerLocalizations {
  ColorPickerLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static ColorPickerLocalizations of(BuildContext context) {
    return Localizations.of<ColorPickerLocalizations>(
        context, ColorPickerLocalizations)!;
  }

  static const LocalizationsDelegate<ColorPickerLocalizations> delegate =
      _ColorPickerLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @colorPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Colour picker'**
  String get colorPickerTitle;

  /// No description provided for @colorPickerTabIcon.
  ///
  /// In en, this message translates to:
  /// **'Colour picker tab icon'**
  String get colorPickerTabIcon;

  /// No description provided for @colorRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get colorRed;

  /// No description provided for @colorGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get colorGreen;

  /// No description provided for @colorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get colorBlue;

  /// No description provided for @colorAlpha.
  ///
  /// In en, this message translates to:
  /// **'Alpha'**
  String get colorAlpha;

  /// No description provided for @colorHex.
  ///
  /// In en, this message translates to:
  /// **'HEX'**
  String get colorHex;

  /// No description provided for @colorPickerApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get colorPickerApply;

  /// No description provided for @colorPickerCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get colorPickerCancel;

  /// No description provided for @colorPickerCurrentColor.
  ///
  /// In en, this message translates to:
  /// **'current'**
  String get colorPickerCurrentColor;

  /// No description provided for @colorPickerNewColor.
  ///
  /// In en, this message translates to:
  /// **'new'**
  String get colorPickerNewColor;

  /// No description provided for @colorPickerPipette.
  ///
  /// In en, this message translates to:
  /// **'Pipette'**
  String get colorPickerPipette;

  /// No description provided for @colorPickerSaveDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Save changes?'**
  String get colorPickerSaveDialogTitle;

  /// No description provided for @colorPickerSaveDialogMsg.
  ///
  /// In en, this message translates to:
  /// **'Do you want to save your changes?'**
  String get colorPickerSaveDialogMsg;

  /// No description provided for @colorPickerNo.
  ///
  /// In en, this message translates to:
  /// **'no'**
  String get colorPickerNo;

  /// No description provided for @colorPickerYes.
  ///
  /// In en, this message translates to:
  /// **'yes'**
  String get colorPickerYes;

  /// No description provided for @colorPickerHistoryRecentlyUsed.
  ///
  /// In en, this message translates to:
  /// **'recently used'**
  String get colorPickerHistoryRecentlyUsed;

  /// No description provided for @colorPickerPicker.
  ///
  /// In en, this message translates to:
  /// **'Picker'**
  String get colorPickerPicker;

  /// No description provided for @colorPickerWheel.
  ///
  /// In en, this message translates to:
  /// **'Wheel'**
  String get colorPickerWheel;
}

class _ColorPickerLocalizationsDelegate
    extends LocalizationsDelegate<ColorPickerLocalizations> {
  const _ColorPickerLocalizationsDelegate();

  @override
  Future<ColorPickerLocalizations> load(Locale locale) {
    return SynchronousFuture<ColorPickerLocalizations>(
        lookupColorPickerLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_ColorPickerLocalizationsDelegate old) => false;
}

ColorPickerLocalizations lookupColorPickerLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return ColorPickerLocalizationsDe();
    case 'en':
      return ColorPickerLocalizationsEn();
  }

  throw FlutterError(
      'ColorPickerLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
