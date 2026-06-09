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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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

  /// No description provided for @pocketpaintAppName.
  ///
  /// In en, this message translates to:
  /// **'Pocket Paint'**
  String get pocketpaintAppName;

  /// No description provided for @buttonUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get buttonUndo;

  /// No description provided for @buttonRedo.
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get buttonRedo;

  /// No description provided for @projectDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get projectDelete;

  /// No description provided for @projectDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get projectDetails;

  /// No description provided for @projectRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get projectRename;

  /// No description provided for @myProjects.
  ///
  /// In en, this message translates to:
  /// **'My Projects'**
  String get myProjects;

  /// No description provided for @projectRenameTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename __name__'**
  String get projectRenameTitle;

  /// No description provided for @projectDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete __name__'**
  String get projectDeleteTitle;

  /// No description provided for @projectDeleteDialog.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete your project?'**
  String get projectDeleteDialog;

  /// No description provided for @detailsResolution.
  ///
  /// In en, this message translates to:
  /// **'Resolution'**
  String get detailsResolution;

  /// No description provided for @detailsLastModified.
  ///
  /// In en, this message translates to:
  /// **'Last modified'**
  String get detailsLastModified;

  /// No description provided for @detailsCreationDate.
  ///
  /// In en, this message translates to:
  /// **'Creation date'**
  String get detailsCreationDate;

  /// No description provided for @detailsSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get detailsSize;

  /// No description provided for @menuHideMenu.
  ///
  /// In en, this message translates to:
  /// **'Fullscreen'**
  String get menuHideMenu;

  /// No description provided for @menuSaveImage.
  ///
  /// In en, this message translates to:
  /// **'Save image'**
  String get menuSaveImage;

  /// No description provided for @menuSaveProject.
  ///
  /// In en, this message translates to:
  /// **'Save project'**
  String get menuSaveProject;

  /// No description provided for @menuLoadImage.
  ///
  /// In en, this message translates to:
  /// **'Load image'**
  String get menuLoadImage;

  /// No description provided for @menuNewImage.
  ///
  /// In en, this message translates to:
  /// **'New image'**
  String get menuNewImage;

  /// No description provided for @menuSaveCopy.
  ///
  /// In en, this message translates to:
  /// **'Save copy'**
  String get menuSaveCopy;

  /// No description provided for @menuDiscardImage.
  ///
  /// In en, this message translates to:
  /// **'Discard image'**
  String get menuDiscardImage;

  /// No description provided for @menuReplaceImage.
  ///
  /// In en, this message translates to:
  /// **'Replace image'**
  String get menuReplaceImage;

  /// No description provided for @menuAddToCurrentLayer.
  ///
  /// In en, this message translates to:
  /// **'Add to current layer'**
  String get menuAddToCurrentLayer;

  /// No description provided for @buttonBrush.
  ///
  /// In en, this message translates to:
  /// **'Brush'**
  String get buttonBrush;

  /// No description provided for @buttonHand.
  ///
  /// In en, this message translates to:
  /// **'Hand'**
  String get buttonHand;

  /// No description provided for @buttonEraser.
  ///
  /// In en, this message translates to:
  /// **'Eraser'**
  String get buttonEraser;

  /// No description provided for @buttonLine.
  ///
  /// In en, this message translates to:
  /// **'Line'**
  String get buttonLine;

  /// No description provided for @buttonShape.
  ///
  /// In en, this message translates to:
  /// **'Shapes'**
  String get buttonShape;

  /// No description provided for @buttonFill.
  ///
  /// In en, this message translates to:
  /// **'Fill'**
  String get buttonFill;

  /// No description provided for @buttonSprayCan.
  ///
  /// In en, this message translates to:
  /// **'Spray can'**
  String get buttonSprayCan;

  /// No description provided for @buttonCursor.
  ///
  /// In en, this message translates to:
  /// **'Cursor'**
  String get buttonCursor;

  /// No description provided for @buttonText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get buttonText;

  /// No description provided for @buttonClipboard.
  ///
  /// In en, this message translates to:
  /// **'Clipboard'**
  String get buttonClipboard;

  /// No description provided for @buttonTransform.
  ///
  /// In en, this message translates to:
  /// **'Transform'**
  String get buttonTransform;

  /// No description provided for @buttonImportImage.
  ///
  /// In en, this message translates to:
  /// **'Import image'**
  String get buttonImportImage;

  /// No description provided for @buttonPipette.
  ///
  /// In en, this message translates to:
  /// **'Pipette'**
  String get buttonPipette;

  /// No description provided for @buttonWatercolor.
  ///
  /// In en, this message translates to:
  /// **'Watercolour'**
  String get buttonWatercolor;

  /// No description provided for @buttonSmudge.
  ///
  /// In en, this message translates to:
  /// **'Smudge'**
  String get buttonSmudge;

  /// No description provided for @buttonClip.
  ///
  /// In en, this message translates to:
  /// **'Clip area'**
  String get buttonClip;

  /// No description provided for @clipboardToolPaste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get clipboardToolPaste;

  /// No description provided for @clipboardToolCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get clipboardToolCopy;

  /// No description provided for @clipboardToolCut.
  ///
  /// In en, this message translates to:
  /// **'Cut'**
  String get clipboardToolCut;

  /// No description provided for @bottomNavigationTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get bottomNavigationTools;

  /// No description provided for @bottomNavigationCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get bottomNavigationCurrent;

  /// No description provided for @bottomNavigationColor.
  ///
  /// In en, this message translates to:
  /// **'Colour'**
  String get bottomNavigationColor;

  /// No description provided for @bottomNavigationLayers.
  ///
  /// In en, this message translates to:
  /// **'Layers'**
  String get bottomNavigationLayers;

  /// No description provided for @bottomNavigationItem.
  ///
  /// In en, this message translates to:
  /// **'Item for bottom navigation'**
  String get bottomNavigationItem;

  /// No description provided for @buttonApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get buttonApply;

  /// No description provided for @buttonCheckmark.
  ///
  /// In en, this message translates to:
  /// **'Checkmark'**
  String get buttonCheckmark;

  /// No description provided for @buttonInfo.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get buttonInfo;

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

  /// No description provided for @noConnectionSticker.
  ///
  /// In en, this message translates to:
  /// **'Stickers not available, check your internet connection.'**
  String get noConnectionSticker;

  /// No description provided for @stickers.
  ///
  /// In en, this message translates to:
  /// **'Stickers'**
  String get stickers;

  /// No description provided for @dialogToolsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get dialogToolsTitle;

  /// No description provided for @dialogErrorSaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Error load/save File'**
  String get dialogErrorSaveTitle;

  /// No description provided for @dialogErrorSdcardText.
  ///
  /// In en, this message translates to:
  /// **'Check Image or SD-Card!'**
  String get dialogErrorSdcardText;

  /// No description provided for @dialogBrushWidthText.
  ///
  /// In en, this message translates to:
  /// **'Stroke Width'**
  String get dialogBrushWidthText;

  /// No description provided for @dialogWarningNewImage.
  ///
  /// In en, this message translates to:
  /// **'Save Changes?'**
  String get dialogWarningNewImage;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get helpTitle;

  /// No description provided for @helpContentEraser.
  ///
  /// In en, this message translates to:
  /// **'Remove parts of the image like with an eraser.'**
  String get helpContentEraser;

  /// No description provided for @helpContentBrush.
  ///
  /// In en, this message translates to:
  /// **'Tap on the symbols on the bottom bar to change the colour or the brush size.'**
  String get helpContentBrush;

  /// No description provided for @helpContentWatercolor.
  ///
  /// In en, this message translates to:
  /// **'Similar to the brush tool with a watercolour effect. However you can also change the strength of the brush with the slider in the colour menu.'**
  String get helpContentWatercolor;

  /// No description provided for @helpContentEyedropper.
  ///
  /// In en, this message translates to:
  /// **'Tap on the image to select a colour.'**
  String get helpContentEyedropper;

  /// No description provided for @helpContentUndo.
  ///
  /// In en, this message translates to:
  /// **'Tap to undo your previous action.'**
  String get helpContentUndo;

  /// No description provided for @helpContentRedo.
  ///
  /// In en, this message translates to:
  /// **'Tap to redo an undone action.'**
  String get helpContentRedo;

  /// No description provided for @helpContentFill.
  ///
  /// In en, this message translates to:
  /// **'Tap on the image to fill an area with the selected colour.'**
  String get helpContentFill;

  /// No description provided for @helpContentCursor.
  ///
  /// In en, this message translates to:
  /// **'Position the cursor where you want to draw. Tap to activate the cursor. Move your finger to draw. Tap again to deactivate.'**
  String get helpContentCursor;

  /// No description provided for @helpContentTransform.
  ///
  /// In en, this message translates to:
  /// **'Use to transform the image.'**
  String get helpContentTransform;

  /// No description provided for @helpContentClipboard.
  ///
  /// In en, this message translates to:
  /// **'Move and resize the rectangle to cover the area you want to stamp. Tap on copy or cut to select the area. Move it, then tap on paste to stamp.'**
  String get helpContentClipboard;

  /// No description provided for @helpContentImportPng.
  ///
  /// In en, this message translates to:
  /// **'Import an image from the gallery to the stamp tool.'**
  String get helpContentImportPng;

  /// No description provided for @helpContentLine.
  ///
  /// In en, this message translates to:
  /// **'Draw a straight line.'**
  String get helpContentLine;

  /// No description provided for @helpContentText.
  ///
  /// In en, this message translates to:
  /// **'Write text and format it. Resize the text box afterwards. Tap on the checkmark to insert the text on the image.'**
  String get helpContentText;

  /// No description provided for @helpContentShape.
  ///
  /// In en, this message translates to:
  /// **'Choose a shape and tap on the checkmark to insert the selected shape.'**
  String get helpContentShape;

  /// No description provided for @helpContentLayer.
  ///
  /// In en, this message translates to:
  /// **'Create new layers or modify existing ones.'**
  String get helpContentLayer;

  /// No description provided for @helpContentColorChooser.
  ///
  /// In en, this message translates to:
  /// **'Select or adjust a colour.'**
  String get helpContentColorChooser;

  /// No description provided for @helpContentHand.
  ///
  /// In en, this message translates to:
  /// **'Move your finger to move the canvas.'**
  String get helpContentHand;

  /// No description provided for @helpContentSprayCan.
  ///
  /// In en, this message translates to:
  /// **'Move your finger on the image to create a spray can pattern.'**
  String get helpContentSprayCan;

  /// No description provided for @helpContentSmudge.
  ///
  /// In en, this message translates to:
  /// **'Move your finger on the image on different drawings to smudge them.'**
  String get helpContentSmudge;

  /// No description provided for @helpContentClip.
  ///
  /// In en, this message translates to:
  /// **'Mark area which should not be erased.'**
  String get helpContentClip;

  /// No description provided for @closingSecurityQuestionTitle.
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get closingSecurityQuestionTitle;

  /// No description provided for @closingSecurityQuestion.
  ///
  /// In en, this message translates to:
  /// **'Save Changes?'**
  String get closingSecurityQuestion;

  /// No description provided for @noLongclickOnHiddenLayer.
  ///
  /// In en, this message translates to:
  /// **'You are only able to merge or reorder if all layers are visible'**
  String get noLongclickOnHiddenLayer;

  /// No description provided for @noToolsOnHiddenLayer.
  ///
  /// In en, this message translates to:
  /// **'No tools are available on hidden layer'**
  String get noToolsOnHiddenLayer;

  /// No description provided for @menuRateUs.
  ///
  /// In en, this message translates to:
  /// **'Rate us!'**
  String get menuRateUs;

  /// No description provided for @menuFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get menuFeedback;

  /// No description provided for @menuExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get menuExport;

  /// No description provided for @menuAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced settings'**
  String get menuAdvanced;

  /// No description provided for @menuZoomSettings.
  ///
  /// In en, this message translates to:
  /// **'Zoom window settings'**
  String get menuZoomSettings;

  /// No description provided for @shareImageMenu.
  ///
  /// In en, this message translates to:
  /// **'Share image'**
  String get shareImageMenu;

  /// No description provided for @shareImageViaText.
  ///
  /// In en, this message translates to:
  /// **'Send image via'**
  String get shareImageViaText;

  /// No description provided for @savedTo.
  ///
  /// In en, this message translates to:
  /// **'Image saved to\n'**
  String get savedTo;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Image saved'**
  String get saved;

  /// No description provided for @copyTo.
  ///
  /// In en, this message translates to:
  /// **'Copy saved to\n'**
  String get copyTo;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy saved'**
  String get copy;

  /// No description provided for @menuQuit.
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get menuQuit;

  /// No description provided for @saveButtonText.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButtonText;

  /// No description provided for @discardButtonText.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discardButtonText;

  /// No description provided for @cancelButtonText.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButtonText;

  /// No description provided for @overwriteButtonText.
  ///
  /// In en, this message translates to:
  /// **'Overwrite'**
  String get overwriteButtonText;

  /// No description provided for @deleteButtonText.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButtonText;

  /// No description provided for @resizeNothingToResize.
  ///
  /// In en, this message translates to:
  /// **'nothing to resize'**
  String get resizeNothingToResize;

  /// No description provided for @resizeCannotResizeToThisSize.
  ///
  /// In en, this message translates to:
  /// **'cannot resize to this size'**
  String get resizeCannotResizeToThisSize;

  /// No description provided for @resizeMaxImageResolutionReached.
  ///
  /// In en, this message translates to:
  /// **'max image resolution reached'**
  String get resizeMaxImageResolutionReached;

  /// No description provided for @textToolDialogUnderlineShortcut.
  ///
  /// In en, this message translates to:
  /// **'U'**
  String get textToolDialogUnderlineShortcut;

  /// No description provided for @textToolDialogItalicShortcut.
  ///
  /// In en, this message translates to:
  /// **'I'**
  String get textToolDialogItalicShortcut;

  /// No description provided for @textToolDialogBoldShortcut.
  ///
  /// In en, this message translates to:
  /// **'B'**
  String get textToolDialogBoldShortcut;

  /// No description provided for @textToolDialogInputHint.
  ///
  /// In en, this message translates to:
  /// **'Tap here to write'**
  String get textToolDialogInputHint;

  /// No description provided for @textToolDialogFontMonospace.
  ///
  /// In en, this message translates to:
  /// **'Monospace'**
  String get textToolDialogFontMonospace;

  /// No description provided for @textToolDialogFontSerif.
  ///
  /// In en, this message translates to:
  /// **'Serif'**
  String get textToolDialogFontSerif;

  /// No description provided for @textToolDialogFontSansSerif.
  ///
  /// In en, this message translates to:
  /// **'Sans Serif'**
  String get textToolDialogFontSansSerif;

  /// No description provided for @textToolDialogFontDubai.
  ///
  /// In en, this message translates to:
  /// **'Dubai'**
  String get textToolDialogFontDubai;

  /// No description provided for @textToolDialogFontArabicStc.
  ///
  /// In en, this message translates to:
  /// **'STC'**
  String get textToolDialogFontArabicStc;

  /// No description provided for @shapeToolDialogRectTitle.
  ///
  /// In en, this message translates to:
  /// **'Rectangle'**
  String get shapeToolDialogRectTitle;

  /// No description provided for @shapeToolDialogEllipseTitle.
  ///
  /// In en, this message translates to:
  /// **'Ellipse'**
  String get shapeToolDialogEllipseTitle;

  /// No description provided for @shapeToolDialogStarTitle.
  ///
  /// In en, this message translates to:
  /// **'Star'**
  String get shapeToolDialogStarTitle;

  /// No description provided for @shapeToolDialogHeartTitle.
  ///
  /// In en, this message translates to:
  /// **'Heart'**
  String get shapeToolDialogHeartTitle;

  /// No description provided for @shapeToolDialogFillTitle.
  ///
  /// In en, this message translates to:
  /// **'Fill'**
  String get shapeToolDialogFillTitle;

  /// No description provided for @shapeToolDialogOutlineTitle.
  ///
  /// In en, this message translates to:
  /// **'Outline'**
  String get shapeToolDialogOutlineTitle;

  /// No description provided for @shapeToolDialogDashed.
  ///
  /// In en, this message translates to:
  /// **'Dashed'**
  String get shapeToolDialogDashed;

  /// No description provided for @shapeToolDialogFillDashed.
  ///
  /// In en, this message translates to:
  /// **'Fill & Dashed'**
  String get shapeToolDialogFillDashed;

  /// No description provided for @strokeTypeRound.
  ///
  /// In en, this message translates to:
  /// **'Round stroke'**
  String get strokeTypeRound;

  /// No description provided for @strokeTypeSquare.
  ///
  /// In en, this message translates to:
  /// **'Square stroke'**
  String get strokeTypeSquare;

  /// No description provided for @fillToolDialogColorToleranceTitle.
  ///
  /// In en, this message translates to:
  /// **'Colour tolerance'**
  String get fillToolDialogColorToleranceTitle;

  /// No description provided for @smudgeToolDialogPressureTitle.
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get smudgeToolDialogPressureTitle;

  /// No description provided for @smudgeToolDialogDragTitle.
  ///
  /// In en, this message translates to:
  /// **'Drag'**
  String get smudgeToolDialogDragTitle;

  /// No description provided for @transformToolRotateLeft.
  ///
  /// In en, this message translates to:
  /// **'rotate left'**
  String get transformToolRotateLeft;

  /// No description provided for @transformToolRotateRight.
  ///
  /// In en, this message translates to:
  /// **'rotate right'**
  String get transformToolRotateRight;

  /// No description provided for @transformToolFlipVertical.
  ///
  /// In en, this message translates to:
  /// **'flip vertical'**
  String get transformToolFlipVertical;

  /// No description provided for @transformToolFlipHorizontal.
  ///
  /// In en, this message translates to:
  /// **'flip horizontal'**
  String get transformToolFlipHorizontal;

  /// No description provided for @transformToolResizeText.
  ///
  /// In en, this message translates to:
  /// **'resize'**
  String get transformToolResizeText;

  /// No description provided for @transformToolAutoCropText.
  ///
  /// In en, this message translates to:
  /// **'crop/enlarge'**
  String get transformToolAutoCropText;

  /// No description provided for @transformWidthText.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get transformWidthText;

  /// No description provided for @transformHeightText.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get transformHeightText;

  /// No description provided for @transformAutoCropText.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get transformAutoCropText;

  /// No description provided for @transformSetCenterText.
  ///
  /// In en, this message translates to:
  /// **'Set center'**
  String get transformSetCenterText;

  /// No description provided for @pixel.
  ///
  /// In en, this message translates to:
  /// **'px'**
  String get pixel;

  /// No description provided for @clipboardToolCopyHint.
  ///
  /// In en, this message translates to:
  /// **'Tap on copy to copy content'**
  String get clipboardToolCopyHint;

  /// No description provided for @layersTitle.
  ///
  /// In en, this message translates to:
  /// **'Layers'**
  String get layersTitle;

  /// No description provided for @layerNew.
  ///
  /// In en, this message translates to:
  /// **'New layer'**
  String get layerNew;

  /// No description provided for @layerDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete layer'**
  String get layerDelete;

  /// No description provided for @layerTooManyLayers.
  ///
  /// In en, this message translates to:
  /// **'Too many layers'**
  String get layerTooManyLayers;

  /// No description provided for @layerMerged.
  ///
  /// In en, this message translates to:
  /// **'Layers merged'**
  String get layerMerged;

  /// No description provided for @layerBackground.
  ///
  /// In en, this message translates to:
  /// **'Layer background'**
  String get layerBackground;

  /// No description provided for @layerPreview.
  ///
  /// In en, this message translates to:
  /// **'Layer preview'**
  String get layerPreview;

  /// No description provided for @dialogLoadingImageFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Error on loading image'**
  String get dialogLoadingImageFailedTitle;

  /// No description provided for @dialogLoadingImageFailedText.
  ///
  /// In en, this message translates to:
  /// **'Not a valid image'**
  String get dialogLoadingImageFailedText;

  /// No description provided for @dialogSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get dialogSettings;

  /// No description provided for @dialogSaveImageName.
  ///
  /// In en, this message translates to:
  /// **'Image name'**
  String get dialogSaveImageName;

  /// No description provided for @dialogSaveImageFormat.
  ///
  /// In en, this message translates to:
  /// **'Image format'**
  String get dialogSaveImageFormat;

  /// No description provided for @dialogSaveProjectName.
  ///
  /// In en, this message translates to:
  /// **'Project name'**
  String get dialogSaveProjectName;

  /// No description provided for @dialogErrorProjectName.
  ///
  /// In en, this message translates to:
  /// **'Please specifiy a project name'**
  String get dialogErrorProjectName;

  /// No description provided for @dialogErrorImageName.
  ///
  /// In en, this message translates to:
  /// **'Please specifiy an image name'**
  String get dialogErrorImageName;

  /// No description provided for @dialogAntialiasing.
  ///
  /// In en, this message translates to:
  /// **'Antialiasing'**
  String get dialogAntialiasing;

  /// No description provided for @dialogSmoothing.
  ///
  /// In en, this message translates to:
  /// **'Smoothing'**
  String get dialogSmoothing;

  /// No description provided for @dialogZoomWindowEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get dialogZoomWindowEnabled;

  /// No description provided for @dialogSaveJpgOptionQuality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get dialogSaveJpgOptionQuality;

  /// No description provided for @pocketpaintJpgMessageDialog.
  ///
  /// In en, this message translates to:
  /// **'Takes up minimal storage space. No transparency is remembered.'**
  String get pocketpaintJpgMessageDialog;

  /// No description provided for @pocketpaintPngMessageDialog.
  ///
  /// In en, this message translates to:
  /// **'Lossless compression. Transparency is preserved.'**
  String get pocketpaintPngMessageDialog;

  /// No description provided for @pocketpaintOraMessageDialog.
  ///
  /// In en, this message translates to:
  /// **'This format remembers <b>layers</b>. <b>It can be opened by apps that support the Openraster format.</b>'**
  String get pocketpaintOraMessageDialog;

  /// No description provided for @pocketpaintCatrobatMessageDialog.
  ///
  /// In en, this message translates to:
  /// **'Pocket Paint\'s native image format. This format remembers commands and layers.'**
  String get pocketpaintCatrobatMessageDialog;

  /// No description provided for @permissionInfoExternalStorageText.
  ///
  /// In en, this message translates to:
  /// **'This app needs the requested permission to function properly. In order to save images to the local memory, the app needs read and write access to it.'**
  String get permissionInfoExternalStorageText;

  /// No description provided for @permissionInfoPermanentDenialText.
  ///
  /// In en, this message translates to:
  /// **'This app needs the requested permission to function properly. In order to save images to the local memory, the app needs read and write access to it.<\b> As you have denied permission with do not ask again, please go to your phone settings and grant the required permissions if you wish to use the associated functions.'**
  String get permissionInfoPermanentDenialText;

  /// No description provided for @setCenterInfoText.
  ///
  /// In en, this message translates to:
  /// **'Tap the screen to define the new center position.'**
  String get setCenterInfoText;

  /// No description provided for @transformInfoText.
  ///
  /// In en, this message translates to:
  /// **'Drag edges to their new position, then tap to enlarge or crop the image area.'**
  String get transformInfoText;

  /// No description provided for @cursorDrawInactive.
  ///
  /// In en, this message translates to:
  /// **'Pan to position, then tap to start painting.'**
  String get cursorDrawInactive;

  /// No description provided for @cursorDrawActive.
  ///
  /// In en, this message translates to:
  /// **'Pan to draw, then tap again to stop painting.'**
  String get cursorDrawActive;

  /// No description provided for @welcomeToPocketPaint.
  ///
  /// In en, this message translates to:
  /// **'Welcome To Pocket Paint'**
  String get welcomeToPocketPaint;

  /// No description provided for @introWelcomeText.
  ///
  /// In en, this message translates to:
  /// **'With Pocket Paint there are no limits to your creativity. If you are new, start the intro, or skip it if you are already familiar with Pocket Paint.'**
  String get introWelcomeText;

  /// No description provided for @introToolMoreInformation.
  ///
  /// In en, this message translates to:
  /// **'Tap on a tool to get more information'**
  String get introToolMoreInformation;

  /// No description provided for @morePossibilities.
  ///
  /// In en, this message translates to:
  /// **'More possibilities'**
  String get morePossibilities;

  /// No description provided for @introPossibilitiesText.
  ///
  /// In en, this message translates to:
  /// **'Use the top bar to open the overflow menu and to undo or redo changes'**
  String get introPossibilitiesText;

  /// No description provided for @landscape.
  ///
  /// In en, this message translates to:
  /// **'Landscape'**
  String get landscape;

  /// No description provided for @introLandscapeText.
  ///
  /// In en, this message translates to:
  /// **'Pocket Paint also supports drawing in landscape mode to give you the best painting experience.'**
  String get introLandscapeText;

  /// No description provided for @enjoyPocketPaint.
  ///
  /// In en, this message translates to:
  /// **'You are all set. Enjoy Pocket Paint.'**
  String get enjoyPocketPaint;

  /// No description provided for @introGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started and create a new masterpiece.'**
  String get introGetStarted;

  /// No description provided for @letsGo.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go'**
  String get letsGo;

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

  /// No description provided for @pocketpaintAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get pocketpaintAboutTitle;

  /// No description provided for @pocketpaintAboutContent.
  ///
  /// In en, this message translates to:
  /// **'Pocket Paint is a picture editing library that is part of the Catrobat project.\n\nCatrobat is a visual programming language and set of creativity tools for smartphones.\n\nThe source code of Pocket Paint is mainly licensed under the __license__.\nFor precise details of the license see the link below.'**
  String get pocketpaintAboutContent;

  /// No description provided for @pocketpaintAboutUrlLicenseDescription.
  ///
  /// In en, this message translates to:
  /// **'Pocket Paint source code license'**
  String get pocketpaintAboutUrlLicenseDescription;

  /// No description provided for @pocketpaintAboutUrlCatrobatDescription.
  ///
  /// In en, this message translates to:
  /// **'About Catrobat'**
  String get pocketpaintAboutUrlCatrobatDescription;

  /// No description provided for @pocketpaintIntro.
  ///
  /// In en, this message translates to:
  /// **'Intro'**
  String get pocketpaintIntro;

  /// No description provided for @pocketpaintIntroSplitScreenNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Intro does not support split screen.'**
  String get pocketpaintIntroSplitScreenNotSupported;

  /// No description provided for @pocketpaintOverwriteTitle.
  ///
  /// In en, this message translates to:
  /// **'Overwrite File?'**
  String get pocketpaintOverwriteTitle;

  /// No description provided for @pocketpaintOverwrite.
  ///
  /// In en, this message translates to:
  /// **'You are about to overwrite an existing project. Save anyway?'**
  String get pocketpaintOverwrite;

  /// No description provided for @pocketpaintLikeUs.
  ///
  /// In en, this message translates to:
  /// **'Do you like Pocket Paint?'**
  String get pocketpaintLikeUs;

  /// No description provided for @pocketpaintRateUs.
  ///
  /// In en, this message translates to:
  /// **'Would you like to rate Pocket Paint?'**
  String get pocketpaintRateUs;

  /// No description provided for @pocketpaintFeedback.
  ///
  /// In en, this message translates to:
  /// **'We are sorry to hear that. If you want to share your experience with us, please write to contact@catrobat.org'**
  String get pocketpaintFeedback;

  /// No description provided for @pocketpaintYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get pocketpaintYes;

  /// No description provided for @pocketpaintNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get pocketpaintNo;

  /// No description provided for @pocketpaintCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get pocketpaintCancel;

  /// No description provided for @pocketpaintNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get pocketpaintNotNow;

  /// No description provided for @pocketpaintRateUsTitle.
  ///
  /// In en, this message translates to:
  /// **'Rate Pocket Paint'**
  String get pocketpaintRateUsTitle;

  /// No description provided for @introBottomNavigationToolsDescription.
  ///
  /// In en, this message translates to:
  /// **'Switch to the tool you want to use.'**
  String get introBottomNavigationToolsDescription;

  /// No description provided for @introBottomNavigationCurrentDescription.
  ///
  /// In en, this message translates to:
  /// **'Shows the currently used tool and opens its options.'**
  String get introBottomNavigationCurrentDescription;

  /// No description provided for @introBottomNavigationColorDescription.
  ///
  /// In en, this message translates to:
  /// **'Shows the currently used colour and opens the colour picker.'**
  String get introBottomNavigationColorDescription;

  /// No description provided for @introBottomNavigationLayersDescription.
  ///
  /// In en, this message translates to:
  /// **'Opens the layer menu and lets you manage your layers.'**
  String get introBottomNavigationLayersDescription;

  /// No description provided for @pocketpaintToolIconDescription.
  ///
  /// In en, this message translates to:
  /// **'Current tool icon'**
  String get pocketpaintToolIconDescription;

  /// No description provided for @dialogScaleTitle.
  ///
  /// In en, this message translates to:
  /// **'Image is too big to load'**
  String get dialogScaleTitle;

  /// No description provided for @dialogScaleMessage.
  ///
  /// In en, this message translates to:
  /// **'The image is too big to load. Tap OK to scale down the image automatically.'**
  String get dialogScaleMessage;

  /// No description provided for @zoomWindowDescription.
  ///
  /// In en, this message translates to:
  /// **'Used to display a zoomed in part of the drawing surface'**
  String get zoomWindowDescription;
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
