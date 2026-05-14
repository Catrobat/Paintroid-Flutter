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

  static ColorPickerLocalizations? of(BuildContext context) {
    return Localizations.of<ColorPickerLocalizations>(
        context, ColorPickerLocalizations);
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

  /// No description provided for @color_picker_title.
  ///
  /// In en, this message translates to:
  /// **'Colour picker'**
  String get color_picker_title;

  /// No description provided for @color_picker_tab_icon.
  ///
  /// In en, this message translates to:
  /// **'Colour picker tab icon'**
  String get color_picker_tab_icon;

  /// No description provided for @color_red.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get color_red;

  /// No description provided for @color_green.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get color_green;

  /// No description provided for @color_blue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get color_blue;

  /// No description provided for @color_alpha.
  ///
  /// In en, this message translates to:
  /// **'Alpha'**
  String get color_alpha;

  /// No description provided for @color_hex.
  ///
  /// In en, this message translates to:
  /// **'HEX'**
  String get color_hex;

  /// No description provided for @color_picker_apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get color_picker_apply;

  /// No description provided for @color_picker_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get color_picker_cancel;

  /// No description provided for @color_picker_current_color.
  ///
  /// In en, this message translates to:
  /// **'current'**
  String get color_picker_current_color;

  /// No description provided for @color_picker_new_color.
  ///
  /// In en, this message translates to:
  /// **'new'**
  String get color_picker_new_color;

  /// No description provided for @color_picker_pipette.
  ///
  /// In en, this message translates to:
  /// **'Pipette'**
  String get color_picker_pipette;

  /// No description provided for @color_picker_save_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Save changes?'**
  String get color_picker_save_dialog_title;

  /// No description provided for @color_picker_save_dialog_msg.
  ///
  /// In en, this message translates to:
  /// **'Do you want to save your changes?'**
  String get color_picker_save_dialog_msg;

  /// No description provided for @color_picker_no.
  ///
  /// In en, this message translates to:
  /// **'no'**
  String get color_picker_no;

  /// No description provided for @color_picker_yes.
  ///
  /// In en, this message translates to:
  /// **'yes'**
  String get color_picker_yes;

  /// No description provided for @color_picker_history_recently_used.
  ///
  /// In en, this message translates to:
  /// **'recently used'**
  String get color_picker_history_recently_used;

  /// No description provided for @color_picker_picker.
  ///
  /// In en, this message translates to:
  /// **'Picker'**
  String get color_picker_picker;

  /// No description provided for @color_picker_wheel.
  ///
  /// In en, this message translates to:
  /// **'Wheel'**
  String get color_picker_wheel;
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
