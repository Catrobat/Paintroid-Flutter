import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
    Locale('en'),
  ];

  /// No description provided for @pocketpaint_app_name.
  ///
  /// In en, this message translates to:
  /// **'Pocket Paint'**
  String get pocketpaint_app_name;

  /// No description provided for @button_undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get button_undo;

  /// No description provided for @button_redo.
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get button_redo;

  /// No description provided for @project_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get project_delete;

  /// No description provided for @project_details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get project_details;

  /// No description provided for @project_rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get project_rename;

  /// No description provided for @my_projects.
  ///
  /// In en, this message translates to:
  /// **'My Projects'**
  String get my_projects;

  /// No description provided for @project_rename_title.
  ///
  /// In en, this message translates to:
  /// **'Rename __name__'**
  String get project_rename_title;

  /// No description provided for @project_delete_title.
  ///
  /// In en, this message translates to:
  /// **'Delete __name__'**
  String get project_delete_title;

  /// No description provided for @project_delete_dialog.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete your project?'**
  String get project_delete_dialog;

  /// No description provided for @details_resolution.
  ///
  /// In en, this message translates to:
  /// **'Resolution'**
  String get details_resolution;

  /// No description provided for @details_last_modified.
  ///
  /// In en, this message translates to:
  /// **'Last modified'**
  String get details_last_modified;

  /// No description provided for @details_creation_date.
  ///
  /// In en, this message translates to:
  /// **'Creation date'**
  String get details_creation_date;

  /// No description provided for @details_size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get details_size;

  /// No description provided for @menu_hide_menu.
  ///
  /// In en, this message translates to:
  /// **'Fullscreen'**
  String get menu_hide_menu;

  /// No description provided for @menu_save_image.
  ///
  /// In en, this message translates to:
  /// **'Save image'**
  String get menu_save_image;

  /// No description provided for @menu_save_project.
  ///
  /// In en, this message translates to:
  /// **'Save project'**
  String get menu_save_project;

  /// No description provided for @menu_load_image.
  ///
  /// In en, this message translates to:
  /// **'Load image'**
  String get menu_load_image;

  /// No description provided for @menu_new_image.
  ///
  /// In en, this message translates to:
  /// **'New image'**
  String get menu_new_image;

  /// No description provided for @menu_save_copy.
  ///
  /// In en, this message translates to:
  /// **'Save copy'**
  String get menu_save_copy;

  /// No description provided for @menu_discard_image.
  ///
  /// In en, this message translates to:
  /// **'Discard image'**
  String get menu_discard_image;

  /// No description provided for @menu_replace_image.
  ///
  /// In en, this message translates to:
  /// **'Replace image'**
  String get menu_replace_image;

  /// No description provided for @menu_add_to_current_layer.
  ///
  /// In en, this message translates to:
  /// **'Add to current layer'**
  String get menu_add_to_current_layer;

  /// No description provided for @button_brush.
  ///
  /// In en, this message translates to:
  /// **'Brush'**
  String get button_brush;

  /// No description provided for @button_hand.
  ///
  /// In en, this message translates to:
  /// **'Hand'**
  String get button_hand;

  /// No description provided for @button_eraser.
  ///
  /// In en, this message translates to:
  /// **'Eraser'**
  String get button_eraser;

  /// No description provided for @button_line.
  ///
  /// In en, this message translates to:
  /// **'Line'**
  String get button_line;

  /// No description provided for @button_shape.
  ///
  /// In en, this message translates to:
  /// **'Shapes'**
  String get button_shape;

  /// No description provided for @button_fill.
  ///
  /// In en, this message translates to:
  /// **'Fill'**
  String get button_fill;

  /// No description provided for @button_spray_can.
  ///
  /// In en, this message translates to:
  /// **'Spray can'**
  String get button_spray_can;

  /// No description provided for @button_cursor.
  ///
  /// In en, this message translates to:
  /// **'Cursor'**
  String get button_cursor;

  /// No description provided for @button_text.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get button_text;

  /// No description provided for @button_clipboard.
  ///
  /// In en, this message translates to:
  /// **'Clipboard'**
  String get button_clipboard;

  /// No description provided for @button_transform.
  ///
  /// In en, this message translates to:
  /// **'Transform'**
  String get button_transform;

  /// No description provided for @button_import_image.
  ///
  /// In en, this message translates to:
  /// **'Import image'**
  String get button_import_image;

  /// No description provided for @button_pipette.
  ///
  /// In en, this message translates to:
  /// **'Pipette'**
  String get button_pipette;

  /// No description provided for @button_watercolor.
  ///
  /// In en, this message translates to:
  /// **'Watercolour'**
  String get button_watercolor;

  /// No description provided for @button_smudge.
  ///
  /// In en, this message translates to:
  /// **'Smudge'**
  String get button_smudge;

  /// No description provided for @button_clip.
  ///
  /// In en, this message translates to:
  /// **'Clip area'**
  String get button_clip;

  /// No description provided for @clipboard_tool_paste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get clipboard_tool_paste;

  /// No description provided for @clipboard_tool_copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get clipboard_tool_copy;

  /// No description provided for @clipboard_tool_cut.
  ///
  /// In en, this message translates to:
  /// **'Cut'**
  String get clipboard_tool_cut;

  /// No description provided for @bottom_navigation_tools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get bottom_navigation_tools;

  /// No description provided for @bottom_navigation_current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get bottom_navigation_current;

  /// No description provided for @bottom_navigation_color.
  ///
  /// In en, this message translates to:
  /// **'Colour'**
  String get bottom_navigation_color;

  /// No description provided for @bottom_navigation_layers.
  ///
  /// In en, this message translates to:
  /// **'Layers'**
  String get bottom_navigation_layers;

  /// No description provided for @bottom_navigation_item.
  ///
  /// In en, this message translates to:
  /// **'Item for bottom navigation'**
  String get bottom_navigation_item;

  /// No description provided for @button_apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get button_apply;

  /// No description provided for @button_checkmark.
  ///
  /// In en, this message translates to:
  /// **'Checkmark'**
  String get button_checkmark;

  /// No description provided for @button_info.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get button_info;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Select image'**
  String get gallery;

  /// No description provided for @no_connection_sticker.
  ///
  /// In en, this message translates to:
  /// **'Stickers not available, check your internet connection.'**
  String get no_connection_sticker;

  /// No description provided for @stickers.
  ///
  /// In en, this message translates to:
  /// **'Stickers'**
  String get stickers;

  /// No description provided for @dialog_tools_title.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get dialog_tools_title;

  /// No description provided for @dialog_error_save_title.
  ///
  /// In en, this message translates to:
  /// **'Error load/save File'**
  String get dialog_error_save_title;

  /// No description provided for @dialog_error_sdcard_text.
  ///
  /// In en, this message translates to:
  /// **'Check Image or SD-Card!'**
  String get dialog_error_sdcard_text;

  /// No description provided for @dialog_brush_width_text.
  ///
  /// In en, this message translates to:
  /// **'Stroke Width'**
  String get dialog_brush_width_text;

  /// No description provided for @dialog_warning_new_image.
  ///
  /// In en, this message translates to:
  /// **'Save Changes?'**
  String get dialog_warning_new_image;

  /// No description provided for @help_title.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help_title;

  /// No description provided for @help_content_eraser.
  ///
  /// In en, this message translates to:
  /// **'Remove parts of the image like with an eraser.'**
  String get help_content_eraser;

  /// No description provided for @help_content_brush.
  ///
  /// In en, this message translates to:
  /// **'Tap on the symbols on the bottom bar to change the colour or the brush size.'**
  String get help_content_brush;

  /// No description provided for @help_content_watercolor.
  ///
  /// In en, this message translates to:
  /// **'Similar to the brush tool with a watercolour effect. However you can also change the strength of the brush with the slider in the colour menu.'**
  String get help_content_watercolor;

  /// No description provided for @help_content_eyedropper.
  ///
  /// In en, this message translates to:
  /// **'Tap on the image to select a colour.'**
  String get help_content_eyedropper;

  /// No description provided for @help_content_undo.
  ///
  /// In en, this message translates to:
  /// **'Tap to undo your previous action.'**
  String get help_content_undo;

  /// No description provided for @help_content_redo.
  ///
  /// In en, this message translates to:
  /// **'Tap to redo an undone action.'**
  String get help_content_redo;

  /// No description provided for @help_content_fill.
  ///
  /// In en, this message translates to:
  /// **'Tap on the image to fill an area with the selected colour.'**
  String get help_content_fill;

  /// No description provided for @help_content_cursor.
  ///
  /// In en, this message translates to:
  /// **'Position the cursor where you want to draw. Tap to activate the cursor. Move your finger to draw. Tap again to deactivate.'**
  String get help_content_cursor;

  /// No description provided for @help_content_transform.
  ///
  /// In en, this message translates to:
  /// **'Use to transform the image.'**
  String get help_content_transform;

  /// No description provided for @help_content_clipboard.
  ///
  /// In en, this message translates to:
  /// **'Move and resize the rectangle to cover the area you want to stamp. Tap on copy or cut to select the area. Move it, then tap on paste to stamp.'**
  String get help_content_clipboard;

  /// No description provided for @help_content_import_png.
  ///
  /// In en, this message translates to:
  /// **'Import an image from the gallery to the stamp tool.'**
  String get help_content_import_png;

  /// No description provided for @help_content_line.
  ///
  /// In en, this message translates to:
  /// **'Draw a straight line.'**
  String get help_content_line;

  /// No description provided for @help_content_text.
  ///
  /// In en, this message translates to:
  /// **'Write text and format it. Resize the text box afterwards. Tap on the checkmark to insert the text on the image.'**
  String get help_content_text;

  /// No description provided for @help_content_shape.
  ///
  /// In en, this message translates to:
  /// **'Choose a shape and tap on the checkmark to insert the selected shape.'**
  String get help_content_shape;

  /// No description provided for @help_content_layer.
  ///
  /// In en, this message translates to:
  /// **'Create new layers or modify existing ones.'**
  String get help_content_layer;

  /// No description provided for @help_content_color_chooser.
  ///
  /// In en, this message translates to:
  /// **'Select or adjust a colour.'**
  String get help_content_color_chooser;

  /// No description provided for @help_content_hand.
  ///
  /// In en, this message translates to:
  /// **'Move your finger to move the canvas.'**
  String get help_content_hand;

  /// No description provided for @help_content_spray_can.
  ///
  /// In en, this message translates to:
  /// **'Move your finger on the image to create a spray can pattern.'**
  String get help_content_spray_can;

  /// No description provided for @help_content_smudge.
  ///
  /// In en, this message translates to:
  /// **'Move your finger on the image on different drawings to smudge them.'**
  String get help_content_smudge;

  /// No description provided for @help_content_clip.
  ///
  /// In en, this message translates to:
  /// **'Mark area which should not be erased.'**
  String get help_content_clip;

  /// No description provided for @closing_security_question_title.
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get closing_security_question_title;

  /// No description provided for @closing_security_question.
  ///
  /// In en, this message translates to:
  /// **'Save Changes?'**
  String get closing_security_question;

  /// No description provided for @no_longclick_on_hidden_layer.
  ///
  /// In en, this message translates to:
  /// **'You are only able to merge or reorder if all layers are visible'**
  String get no_longclick_on_hidden_layer;

  /// No description provided for @no_tools_on_hidden_layer.
  ///
  /// In en, this message translates to:
  /// **'No tools are available on hidden layer'**
  String get no_tools_on_hidden_layer;

  /// No description provided for @menu_rate_us.
  ///
  /// In en, this message translates to:
  /// **'Rate us!'**
  String get menu_rate_us;

  /// No description provided for @menu_feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get menu_feedback;

  /// No description provided for @menu_export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get menu_export;

  /// No description provided for @menu_advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced settings'**
  String get menu_advanced;

  /// No description provided for @menu_zoom_settings.
  ///
  /// In en, this message translates to:
  /// **'Zoom window settings'**
  String get menu_zoom_settings;

  /// No description provided for @share_image_menu.
  ///
  /// In en, this message translates to:
  /// **'Share image'**
  String get share_image_menu;

  /// No description provided for @share_image_via_text.
  ///
  /// In en, this message translates to:
  /// **'Send image via'**
  String get share_image_via_text;

  /// No description provided for @saved_to.
  ///
  /// In en, this message translates to:
  /// **'Image saved to\n'**
  String get saved_to;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Image saved'**
  String get saved;

  /// No description provided for @copy_to.
  ///
  /// In en, this message translates to:
  /// **'Copy saved to\n'**
  String get copy_to;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy saved'**
  String get copy;

  /// No description provided for @menu_quit.
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get menu_quit;

  /// No description provided for @save_button_text.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save_button_text;

  /// No description provided for @discard_button_text.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard_button_text;

  /// No description provided for @cancel_button_text.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel_button_text;

  /// No description provided for @overwrite_button_text.
  ///
  /// In en, this message translates to:
  /// **'Overwrite'**
  String get overwrite_button_text;

  /// No description provided for @delete_button_text.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete_button_text;

  /// No description provided for @resize_nothing_to_resize.
  ///
  /// In en, this message translates to:
  /// **'nothing to resize'**
  String get resize_nothing_to_resize;

  /// No description provided for @resize_cannot_resize_to_this_size.
  ///
  /// In en, this message translates to:
  /// **'cannot resize to this size'**
  String get resize_cannot_resize_to_this_size;

  /// No description provided for @resize_max_image_resolution_reached.
  ///
  /// In en, this message translates to:
  /// **'max image resolution reached'**
  String get resize_max_image_resolution_reached;

  /// No description provided for @text_tool_dialog_underline_shortcut.
  ///
  /// In en, this message translates to:
  /// **'U'**
  String get text_tool_dialog_underline_shortcut;

  /// No description provided for @text_tool_dialog_italic_shortcut.
  ///
  /// In en, this message translates to:
  /// **'I'**
  String get text_tool_dialog_italic_shortcut;

  /// No description provided for @text_tool_dialog_bold_shortcut.
  ///
  /// In en, this message translates to:
  /// **'B'**
  String get text_tool_dialog_bold_shortcut;

  /// No description provided for @text_tool_dialog_input_hint.
  ///
  /// In en, this message translates to:
  /// **'Tap here to write'**
  String get text_tool_dialog_input_hint;

  /// No description provided for @text_tool_dialog_font_monospace.
  ///
  /// In en, this message translates to:
  /// **'Monospace'**
  String get text_tool_dialog_font_monospace;

  /// No description provided for @text_tool_dialog_font_serif.
  ///
  /// In en, this message translates to:
  /// **'Serif'**
  String get text_tool_dialog_font_serif;

  /// No description provided for @text_tool_dialog_font_sans_serif.
  ///
  /// In en, this message translates to:
  /// **'Sans Serif'**
  String get text_tool_dialog_font_sans_serif;

  /// No description provided for @text_tool_dialog_font_dubai.
  ///
  /// In en, this message translates to:
  /// **'Dubai'**
  String get text_tool_dialog_font_dubai;

  /// No description provided for @text_tool_dialog_font_arabic_stc.
  ///
  /// In en, this message translates to:
  /// **'STC'**
  String get text_tool_dialog_font_arabic_stc;

  /// No description provided for @shape_tool_dialog_rect_title.
  ///
  /// In en, this message translates to:
  /// **'Rectangle'**
  String get shape_tool_dialog_rect_title;

  /// No description provided for @shape_tool_dialog_ellipse_title.
  ///
  /// In en, this message translates to:
  /// **'Ellipse'**
  String get shape_tool_dialog_ellipse_title;

  /// No description provided for @shape_tool_dialog_star_title.
  ///
  /// In en, this message translates to:
  /// **'Star'**
  String get shape_tool_dialog_star_title;

  /// No description provided for @shape_tool_dialog_heart_title.
  ///
  /// In en, this message translates to:
  /// **'Heart'**
  String get shape_tool_dialog_heart_title;

  /// No description provided for @shape_tool_dialog_fill_title.
  ///
  /// In en, this message translates to:
  /// **'Fill'**
  String get shape_tool_dialog_fill_title;

  /// No description provided for @shape_tool_dialog_outline_title.
  ///
  /// In en, this message translates to:
  /// **'Outline'**
  String get shape_tool_dialog_outline_title;

  /// No description provided for @shape_tool_dialog_dashed.
  ///
  /// In en, this message translates to:
  /// **'Dashed'**
  String get shape_tool_dialog_dashed;

  /// No description provided for @shape_tool_dialog_fill_dashed.
  ///
  /// In en, this message translates to:
  /// **'Fill & Dashed'**
  String get shape_tool_dialog_fill_dashed;

  /// No description provided for @stroke_type_round.
  ///
  /// In en, this message translates to:
  /// **'Round stroke'**
  String get stroke_type_round;

  /// No description provided for @stroke_type_square.
  ///
  /// In en, this message translates to:
  /// **'Square stroke'**
  String get stroke_type_square;

  /// No description provided for @fill_tool_dialog_color_tolerance_title.
  ///
  /// In en, this message translates to:
  /// **'Colour tolerance'**
  String get fill_tool_dialog_color_tolerance_title;

  /// No description provided for @smudge_tool_dialog_pressure_title.
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get smudge_tool_dialog_pressure_title;

  /// No description provided for @smudge_tool_dialog_drag_title.
  ///
  /// In en, this message translates to:
  /// **'Drag'**
  String get smudge_tool_dialog_drag_title;

  /// No description provided for @transform_tool_rotate_left.
  ///
  /// In en, this message translates to:
  /// **'rotate left'**
  String get transform_tool_rotate_left;

  /// No description provided for @transform_tool_rotate_right.
  ///
  /// In en, this message translates to:
  /// **'rotate right'**
  String get transform_tool_rotate_right;

  /// No description provided for @transform_tool_flip_vertical.
  ///
  /// In en, this message translates to:
  /// **'flip vertical'**
  String get transform_tool_flip_vertical;

  /// No description provided for @transform_tool_flip_horizontal.
  ///
  /// In en, this message translates to:
  /// **'flip horizontal'**
  String get transform_tool_flip_horizontal;

  /// No description provided for @transform_tool_resize_text.
  ///
  /// In en, this message translates to:
  /// **'resize'**
  String get transform_tool_resize_text;

  /// No description provided for @transform_tool_auto_crop_text.
  ///
  /// In en, this message translates to:
  /// **'crop/enlarge'**
  String get transform_tool_auto_crop_text;

  /// No description provided for @transform_width_text.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get transform_width_text;

  /// No description provided for @transform_height_text.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get transform_height_text;

  /// No description provided for @transform_auto_crop_text.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get transform_auto_crop_text;

  /// No description provided for @transform_set_center_text.
  ///
  /// In en, this message translates to:
  /// **'Set center'**
  String get transform_set_center_text;

  /// No description provided for @pixel.
  ///
  /// In en, this message translates to:
  /// **'px'**
  String get pixel;

  /// No description provided for @clipboard_tool_copy_hint.
  ///
  /// In en, this message translates to:
  /// **'Tap on copy to copy content'**
  String get clipboard_tool_copy_hint;

  /// No description provided for @layers_title.
  ///
  /// In en, this message translates to:
  /// **'Layers'**
  String get layers_title;

  /// No description provided for @layer_new.
  ///
  /// In en, this message translates to:
  /// **'New layer'**
  String get layer_new;

  /// No description provided for @layer_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete layer'**
  String get layer_delete;

  /// No description provided for @layer_too_many_layers.
  ///
  /// In en, this message translates to:
  /// **'Too many layers'**
  String get layer_too_many_layers;

  /// No description provided for @layer_merged.
  ///
  /// In en, this message translates to:
  /// **'Layers merged'**
  String get layer_merged;

  /// No description provided for @layer_background.
  ///
  /// In en, this message translates to:
  /// **'Layer background'**
  String get layer_background;

  /// No description provided for @layer_preview.
  ///
  /// In en, this message translates to:
  /// **'Layer preview'**
  String get layer_preview;

  /// No description provided for @dialog_loading_image_failed_title.
  ///
  /// In en, this message translates to:
  /// **'Error on loading image'**
  String get dialog_loading_image_failed_title;

  /// No description provided for @dialog_loading_image_failed_text.
  ///
  /// In en, this message translates to:
  /// **'Not a valid image'**
  String get dialog_loading_image_failed_text;

  /// No description provided for @dialog_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get dialog_settings;

  /// No description provided for @dialog_save_image_name.
  ///
  /// In en, this message translates to:
  /// **'Image name'**
  String get dialog_save_image_name;

  /// No description provided for @dialog_save_image_format.
  ///
  /// In en, this message translates to:
  /// **'Image format'**
  String get dialog_save_image_format;

  /// No description provided for @dialog_save_project_name.
  ///
  /// In en, this message translates to:
  /// **'Project name'**
  String get dialog_save_project_name;

  /// No description provided for @dialog_error_project_name.
  ///
  /// In en, this message translates to:
  /// **'Please specifiy a project name'**
  String get dialog_error_project_name;

  /// No description provided for @dialog_error_image_name.
  ///
  /// In en, this message translates to:
  /// **'Please specifiy an image name'**
  String get dialog_error_image_name;

  /// No description provided for @dialog_antialiasing.
  ///
  /// In en, this message translates to:
  /// **'Antialiasing'**
  String get dialog_antialiasing;

  /// No description provided for @dialog_smoothing.
  ///
  /// In en, this message translates to:
  /// **'Smoothing'**
  String get dialog_smoothing;

  /// No description provided for @dialog_zoom_window_enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get dialog_zoom_window_enabled;

  /// No description provided for @dialog_save_jpg_option_quality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get dialog_save_jpg_option_quality;

  /// No description provided for @pocketpaint_jpg_message_dialog.
  ///
  /// In en, this message translates to:
  /// **'Takes up minimal storage space. No transparency is remembered.'**
  String get pocketpaint_jpg_message_dialog;

  /// No description provided for @pocketpaint_png_message_dialog.
  ///
  /// In en, this message translates to:
  /// **'Lossless compression. Transparency is preserved.'**
  String get pocketpaint_png_message_dialog;

  /// No description provided for @pocketpaint_ora_message_dialog.
  ///
  /// In en, this message translates to:
  /// **'This format remembers <b>layers</b>. <b>It can be opened by apps that support the Openraster format.</b>'**
  String get pocketpaint_ora_message_dialog;

  /// No description provided for @pocketpaint_catrobat_message_dialog.
  ///
  /// In en, this message translates to:
  /// **'Pocket Paint\'s native image format. This format remembers commands and layers.'**
  String get pocketpaint_catrobat_message_dialog;

  /// No description provided for @permission_info_external_storage_text.
  ///
  /// In en, this message translates to:
  /// **'This app needs the requested permission to function properly. In order to save images to the local memory, the app needs read and write access to it.'**
  String get permission_info_external_storage_text;

  /// No description provided for @permission_info_permanent_denial_text.
  ///
  /// In en, this message translates to:
  /// **'This app needs the requested permission to function properly. In order to save images to the local memory, the app needs read and write access to it.<\b> As you have denied permission with do not ask again, please go to your phone settings and grant the required permissions if you wish to use the associated functions.'**
  String get permission_info_permanent_denial_text;

  /// No description provided for @set_center_info_text.
  ///
  /// In en, this message translates to:
  /// **'Tap the screen to define the new center position.'**
  String get set_center_info_text;

  /// No description provided for @transform_info_text.
  ///
  /// In en, this message translates to:
  /// **'Drag edges to their new position, then tap to enlarge or crop the image area.'**
  String get transform_info_text;

  /// No description provided for @cursor_draw_inactive.
  ///
  /// In en, this message translates to:
  /// **'Pan to position, then tap to start painting.'**
  String get cursor_draw_inactive;

  /// No description provided for @cursor_draw_active.
  ///
  /// In en, this message translates to:
  /// **'Pan to draw, then tap again to stop painting.'**
  String get cursor_draw_active;

  /// No description provided for @welcome_to_pocket_paint.
  ///
  /// In en, this message translates to:
  /// **'Welcome To Pocket Paint'**
  String get welcome_to_pocket_paint;

  /// No description provided for @intro_welcome_text.
  ///
  /// In en, this message translates to:
  /// **'With Pocket Paint there are no limits to your creativity. If you are new, start the intro, or skip it if you are already familiar with Pocket Paint.'**
  String get intro_welcome_text;

  /// No description provided for @intro_tool_more_information.
  ///
  /// In en, this message translates to:
  /// **'Tap on a tool to get more information'**
  String get intro_tool_more_information;

  /// No description provided for @more_possibilities.
  ///
  /// In en, this message translates to:
  /// **'More possibilities'**
  String get more_possibilities;

  /// No description provided for @intro_possibilities_text.
  ///
  /// In en, this message translates to:
  /// **'Use the top bar to open the overflow menu and to undo or redo changes'**
  String get intro_possibilities_text;

  /// No description provided for @landscape.
  ///
  /// In en, this message translates to:
  /// **'Landscape'**
  String get landscape;

  /// No description provided for @intro_landscape_text.
  ///
  /// In en, this message translates to:
  /// **'Pocket Paint also supports drawing in landscape mode to give you the best painting experience.'**
  String get intro_landscape_text;

  /// No description provided for @enjoy_pocket_paint.
  ///
  /// In en, this message translates to:
  /// **'You are all set. Enjoy Pocket Paint.'**
  String get enjoy_pocket_paint;

  /// No description provided for @intro_get_started.
  ///
  /// In en, this message translates to:
  /// **'Get started and create a new masterpiece.'**
  String get intro_get_started;

  /// No description provided for @lets_go.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go'**
  String get lets_go;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @pocketpaint_about_title.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get pocketpaint_about_title;

  /// No description provided for @pocketpaint_about_content.
  ///
  /// In en, this message translates to:
  /// **'Pocket Paint is a picture editing library that is part of the Catrobat project.\n\nCatrobat is a visual programming language and set of creativity tools for smartphones.\n\nThe source code of Pocket Paint is mainly licensed under the __license__.\nFor precise details of the license see the link below.'**
  String get pocketpaint_about_content;

  /// No description provided for @pocketpaint_about_url_license_description.
  ///
  /// In en, this message translates to:
  /// **'Pocket Paint source code license'**
  String get pocketpaint_about_url_license_description;

  /// No description provided for @pocketpaint_about_url_catrobat_description.
  ///
  /// In en, this message translates to:
  /// **'About Catrobat'**
  String get pocketpaint_about_url_catrobat_description;

  /// No description provided for @pocketpaint_intro.
  ///
  /// In en, this message translates to:
  /// **'Intro'**
  String get pocketpaint_intro;

  /// No description provided for @pocketpaint_intro_split_screen_not_supported.
  ///
  /// In en, this message translates to:
  /// **'Intro does not support split screen.'**
  String get pocketpaint_intro_split_screen_not_supported;

  /// No description provided for @pocketpaint_overwrite_title.
  ///
  /// In en, this message translates to:
  /// **'Overwrite File?'**
  String get pocketpaint_overwrite_title;

  /// No description provided for @pocketpaint_overwrite.
  ///
  /// In en, this message translates to:
  /// **'You are about to overwrite an existing project. Save anyway?'**
  String get pocketpaint_overwrite;

  /// No description provided for @pocketpaint_like_us.
  ///
  /// In en, this message translates to:
  /// **'Do you like Pocket Paint?'**
  String get pocketpaint_like_us;

  /// No description provided for @pocketpaint_rate_us.
  ///
  /// In en, this message translates to:
  /// **'Would you like to rate Pocket Paint?'**
  String get pocketpaint_rate_us;

  /// No description provided for @pocketpaint_feedback.
  ///
  /// In en, this message translates to:
  /// **'We are sorry to hear that. If you want to share your experience with us, please write to contact@catrobat.org'**
  String get pocketpaint_feedback;

  /// No description provided for @pocketpaint_yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get pocketpaint_yes;

  /// No description provided for @pocketpaint_no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get pocketpaint_no;

  /// No description provided for @pocketpaint_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get pocketpaint_cancel;

  /// No description provided for @pocketpaint_not_now.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get pocketpaint_not_now;

  /// No description provided for @pocketpaint_rate_us_title.
  ///
  /// In en, this message translates to:
  /// **'Rate Pocket Paint'**
  String get pocketpaint_rate_us_title;

  /// No description provided for @intro_bottom_navigation_tools_description.
  ///
  /// In en, this message translates to:
  /// **'Switch to the tool you want to use.'**
  String get intro_bottom_navigation_tools_description;

  /// No description provided for @intro_bottom_navigation_current_description.
  ///
  /// In en, this message translates to:
  /// **'Shows the currently used tool and opens its options.'**
  String get intro_bottom_navigation_current_description;

  /// No description provided for @intro_bottom_navigation_color_description.
  ///
  /// In en, this message translates to:
  /// **'Shows the currently used colour and opens the colour picker.'**
  String get intro_bottom_navigation_color_description;

  /// No description provided for @intro_bottom_navigation_layers_description.
  ///
  /// In en, this message translates to:
  /// **'Opens the layer menu and lets you manage your layers.'**
  String get intro_bottom_navigation_layers_description;

  /// No description provided for @pocketpaint_tool_icon_description.
  ///
  /// In en, this message translates to:
  /// **'Current tool icon'**
  String get pocketpaint_tool_icon_description;

  /// No description provided for @dialog_scale_title.
  ///
  /// In en, this message translates to:
  /// **'Image is too big to load'**
  String get dialog_scale_title;

  /// No description provided for @dialog_scale_message.
  ///
  /// In en, this message translates to:
  /// **'The image is too big to load. Tap OK to scale down the image automatically.'**
  String get dialog_scale_message;

  /// No description provided for @zoom_window_description.
  ///
  /// In en, this message translates to:
  /// **'Used to display a zoomed in part of the drawing surface'**
  String get zoom_window_description;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
