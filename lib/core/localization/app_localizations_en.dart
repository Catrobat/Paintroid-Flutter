// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get pocketpaintAppName => 'Pocket Paint';

  @override
  String get buttonUndo => 'Undo';

  @override
  String get buttonRedo => 'Redo';

  @override
  String get projectDelete => 'Delete';

  @override
  String get projectDetails => 'Details';

  @override
  String get projectRename => 'Rename';

  @override
  String get myProjects => 'My Projects';

  @override
  String projectRenameTitle(Object name) {
    return 'Rename $name';
  }

  @override
  String projectDeleteTitle(Object name) {
    return 'Delete $name';
  }

  @override
  String get projectDeleteDialog =>
      'Do you really want to delete your project?';

  @override
  String get detailsResolution => 'Resolution';

  @override
  String get detailsLastModified => 'Last modified';

  @override
  String get detailsCreationDate => 'Creation date';

  @override
  String get detailsSize => 'Size';

  @override
  String get menuHideMenu => 'Fullscreen';

  @override
  String get menuSaveImage => 'Save image';

  @override
  String get menuSaveProject => 'Save project';

  @override
  String get menuLoadImage => 'Load image';

  @override
  String get menuNewImage => 'New image';

  @override
  String get menuSaveCopy => 'Save copy';

  @override
  String get menuDiscardImage => 'Discard image';

  @override
  String get menuReplaceImage => 'Replace image';

  @override
  String get menuAddToCurrentLayer => 'Add to current layer';

  @override
  String get buttonBrush => 'Brush';

  @override
  String get buttonHand => 'Hand';

  @override
  String get buttonEraser => 'Eraser';

  @override
  String get buttonLine => 'Line';

  @override
  String get buttonShape => 'Shapes';

  @override
  String get buttonFill => 'Fill';

  @override
  String get buttonSprayCan => 'Spray can';

  @override
  String get buttonCursor => 'Cursor';

  @override
  String get buttonText => 'Text';

  @override
  String get buttonClipboard => 'Clipboard';

  @override
  String get buttonTransform => 'Transform';

  @override
  String get buttonImportImage => 'Import image';

  @override
  String get buttonPipette => 'Pipette';

  @override
  String get buttonWatercolor => 'Watercolour';

  @override
  String get buttonSmudge => 'Smudge';

  @override
  String get buttonClip => 'Clip area';

  @override
  String get clipboardToolPaste => 'Paste';

  @override
  String get clipboardToolCopy => 'Copy';

  @override
  String get clipboardToolCut => 'Cut';

  @override
  String get bottomNavigationTools => 'Tools';

  @override
  String get bottomNavigationCurrent => 'Current';

  @override
  String get bottomNavigationColor => 'Colour';

  @override
  String get bottomNavigationLayers => 'Layers';

  @override
  String get bottomNavigationItem => 'Item for bottom navigation';

  @override
  String get buttonApply => 'Apply';

  @override
  String get buttonCheckmark => 'Checkmark';

  @override
  String get buttonInfo => 'Information';

  @override
  String get done => 'Done';

  @override
  String get gallery => 'Select image';

  @override
  String get noConnectionSticker =>
      'Stickers not available, check your internet connection.';

  @override
  String get stickers => 'Stickers';

  @override
  String get dialogToolsTitle => 'Tools';

  @override
  String get dialogErrorSaveTitle => 'Error load/save File';

  @override
  String get dialogErrorSdcardText => 'Check Image or SD-Card!';

  @override
  String get dialogBrushWidthText => 'Stroke Width';

  @override
  String get dialogWarningNewImage => 'Save Changes?';

  @override
  String get helpTitle => 'Help';

  @override
  String get helpContentEraser =>
      'Remove parts of the image like with an eraser.';

  @override
  String get helpContentBrush =>
      'Tap on the symbols on the bottom bar to change the colour or the brush size.';

  @override
  String get helpContentWatercolor =>
      'Similar to the brush tool with a watercolour effect. However you can also change the strength of the brush with the slider in the colour menu.';

  @override
  String get helpContentEyedropper => 'Tap on the image to select a colour.';

  @override
  String get helpContentUndo => 'Tap to undo your previous action.';

  @override
  String get helpContentRedo => 'Tap to redo an undone action.';

  @override
  String get helpContentFill =>
      'Tap on the image to fill an area with the selected colour.';

  @override
  String get helpContentCursor =>
      'Position the cursor where you want to draw. Tap to activate the cursor. Move your finger to draw. Tap again to deactivate.';

  @override
  String get helpContentTransform => 'Use to transform the image.';

  @override
  String get helpContentClipboard =>
      'Move and resize the rectangle to cover the area you want to stamp. Tap on copy or cut to select the area. Move it, then tap on paste to stamp.';

  @override
  String get helpContentImportPng =>
      'Import an image from the gallery to the stamp tool.';

  @override
  String get helpContentLine => 'Draw a straight line.';

  @override
  String get helpContentText =>
      'Write text and format it. Resize the text box afterwards. Tap on the checkmark to insert the text on the image.';

  @override
  String get helpContentShape =>
      'Choose a shape and tap on the checkmark to insert the selected shape.';

  @override
  String get helpContentLayer => 'Create new layers or modify existing ones.';

  @override
  String get helpContentColorChooser => 'Select or adjust a colour.';

  @override
  String get helpContentHand => 'Move your finger to move the canvas.';

  @override
  String get helpContentSprayCan =>
      'Move your finger on the image to create a spray can pattern.';

  @override
  String get helpContentSmudge =>
      'Move your finger on the image on different drawings to smudge them.';

  @override
  String get helpContentClip => 'Mark area which should not be erased.';

  @override
  String get closingSecurityQuestionTitle => 'Quit';

  @override
  String get closingSecurityQuestion => 'Save Changes?';

  @override
  String get noLongclickOnHiddenLayer =>
      'You are only able to merge or reorder if all layers are visible';

  @override
  String get noToolsOnHiddenLayer => 'No tools are available on hidden layer';

  @override
  String get menuRateUs => 'Rate us!';

  @override
  String get menuFeedback => 'Feedback';

  @override
  String get menuExport => 'Export';

  @override
  String get menuAdvanced => 'Advanced settings';

  @override
  String get menuZoomSettings => 'Zoom window settings';

  @override
  String get shareImageMenu => 'Share image';

  @override
  String get shareImageViaText => 'Send image via';

  @override
  String get savedTo => 'Image saved to\n';

  @override
  String get saved => 'Image saved';

  @override
  String get copyTo => 'Copy saved to\n';

  @override
  String get copy => 'Copy saved';

  @override
  String get menuQuit => 'Quit';

  @override
  String get saveButtonText => 'Save';

  @override
  String get discardButtonText => 'Discard';

  @override
  String get cancelButtonText => 'Cancel';

  @override
  String get overwriteButtonText => 'Overwrite';

  @override
  String get deleteButtonText => 'Delete';

  @override
  String get resizeNothingToResize => 'nothing to resize';

  @override
  String get resizeCannotResizeToThisSize => 'cannot resize to this size';

  @override
  String get resizeMaxImageResolutionReached => 'max image resolution reached';

  @override
  String get textToolDialogUnderlineShortcut => 'U';

  @override
  String get textToolDialogItalicShortcut => 'I';

  @override
  String get textToolDialogBoldShortcut => 'B';

  @override
  String get textToolDialogInputHint => 'Tap here to write';

  @override
  String get textToolDialogFontMonospace => 'Monospace';

  @override
  String get textToolDialogFontSerif => 'Serif';

  @override
  String get textToolDialogFontSansSerif => 'Sans Serif';

  @override
  String get textToolDialogFontDubai => 'Dubai';

  @override
  String get textToolDialogFontArabicStc => 'STC';

  @override
  String get shapeToolDialogRectTitle => 'Rectangle';

  @override
  String get shapeToolDialogEllipseTitle => 'Ellipse';

  @override
  String get shapeToolDialogStarTitle => 'Star';

  @override
  String get shapeToolDialogHeartTitle => 'Heart';

  @override
  String get shapeToolDialogFillTitle => 'Fill';

  @override
  String get shapeToolDialogOutlineTitle => 'Outline';

  @override
  String get shapeToolDialogDashed => 'Dashed';

  @override
  String get shapeToolDialogFillDashed => 'Fill & Dashed';

  @override
  String get strokeTypeRound => 'Round stroke';

  @override
  String get strokeTypeSquare => 'Square stroke';

  @override
  String get fillToolDialogColorToleranceTitle => 'Colour tolerance';

  @override
  String get smudgeToolDialogPressureTitle => 'Pressure';

  @override
  String get smudgeToolDialogDragTitle => 'Drag';

  @override
  String get transformToolRotateLeft => 'rotate left';

  @override
  String get transformToolRotateRight => 'rotate right';

  @override
  String get transformToolFlipVertical => 'flip vertical';

  @override
  String get transformToolFlipHorizontal => 'flip horizontal';

  @override
  String get transformToolResizeText => 'resize';

  @override
  String get transformToolAutoCropText => 'crop/enlarge';

  @override
  String get transformWidthText => 'Width';

  @override
  String get transformHeightText => 'Height';

  @override
  String get transformAutoCropText => 'Auto';

  @override
  String get transformSetCenterText => 'Set center';

  @override
  String get pixel => 'px';

  @override
  String get clipboardToolCopyHint => 'Tap on copy to copy content';

  @override
  String get layersTitle => 'Layers';

  @override
  String get layerNew => 'New layer';

  @override
  String get layerDelete => 'Delete layer';

  @override
  String get layerTooManyLayers => 'Too many layers';

  @override
  String get layerMerged => 'Layers merged';

  @override
  String get layerBackground => 'Layer background';

  @override
  String get layerPreview => 'Layer preview';

  @override
  String get dialogLoadingImageFailedTitle => 'Error on loading image';

  @override
  String get dialogLoadingImageFailedText => 'Not a valid image';

  @override
  String get dialogSettings => 'Settings';

  @override
  String get dialogSaveImageName => 'Image name';

  @override
  String get dialogSaveImageFormat => 'Image format';

  @override
  String get dialogSaveProjectName => 'Project name';

  @override
  String get dialogErrorProjectName => 'Please specifiy a project name';

  @override
  String get dialogErrorImageName => 'Please specifiy an image name';

  @override
  String get dialogAntialiasing => 'Antialiasing';

  @override
  String get dialogSmoothing => 'Smoothing';

  @override
  String get dialogZoomWindowEnabled => 'Enabled';

  @override
  String get dialogSaveJpgOptionQuality => 'Quality';

  @override
  String get pocketpaintJpgMessageDialog =>
      'Takes up minimal storage space. No transparency is remembered.';

  @override
  String get pocketpaintPngMessageDialog =>
      'Lossless compression. Transparency is preserved.';

  @override
  String get pocketpaintOraMessageDialog =>
      'This format remembers <b>layers</b>. <b>It can be opened by apps that support the Openraster format.</b>';

  @override
  String get pocketpaintCatrobatMessageDialog =>
      'Pocket Paint\'s native image format. This format remembers commands and layers.';

  @override
  String get permissionInfoExternalStorageText =>
      'This app needs the requested permission to function properly. In order to save images to the local memory, the app needs read and write access to it.';

  @override
  String get permissionInfoPermanentDenialText =>
      'This app needs the requested permission to function properly. In order to save images to the local memory, the app needs read and write access to it.<\b> As you have denied permission with do not ask again, please go to your phone settings and grant the required permissions if you wish to use the associated functions.';

  @override
  String get setCenterInfoText =>
      'Tap the screen to define the new center position.';

  @override
  String get transformInfoText =>
      'Drag edges to their new position, then tap to enlarge or crop the image area.';

  @override
  String get cursorDrawInactive =>
      'Pan to position, then tap to start painting.';

  @override
  String get cursorDrawActive =>
      'Pan to draw, then tap again to stop painting.';

  @override
  String get welcomeToPocketPaint => 'Welcome To Pocket Paint';

  @override
  String get introWelcomeText =>
      'With Pocket Paint there are no limits to your creativity. If you are new, start the intro, or skip it if you are already familiar with Pocket Paint.';

  @override
  String get introToolMoreInformation =>
      'Tap on a tool to get more information';

  @override
  String get morePossibilities => 'More possibilities';

  @override
  String get introPossibilitiesText =>
      'Use the top bar to open the overflow menu and to undo or redo changes';

  @override
  String get landscape => 'Landscape';

  @override
  String get introLandscapeText =>
      'Pocket Paint also supports drawing in landscape mode to give you the best painting experience.';

  @override
  String get enjoyPocketPaint => 'You are all set. Enjoy Pocket Paint.';

  @override
  String get introGetStarted => 'Get started and create a new masterpiece.';

  @override
  String get letsGo => 'Let\'s go';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get pocketpaintAboutTitle => 'About';

  @override
  String pocketpaintAboutContent(Object license) {
    return 'Pocket Paint is a picture editing library that is part of the Catrobat project.\n\nCatrobat is a visual programming language and set of creativity tools for smartphones.\n\nThe source code of Pocket Paint is mainly licensed under the $license.\nFor precise details of the license see the link below.';
  }

  @override
  String get pocketpaintAboutUrlLicenseDescription =>
      'Pocket Paint source code license';

  @override
  String get pocketpaintAboutUrlCatrobatDescription => 'About Catrobat';

  @override
  String get pocketpaintIntro => 'Intro';

  @override
  String get pocketpaintIntroSplitScreenNotSupported =>
      'Intro does not support split screen.';

  @override
  String get pocketpaintOverwriteTitle => 'Overwrite File?';

  @override
  String get pocketpaintOverwrite =>
      'You are about to overwrite an existing project. Save anyway?';

  @override
  String get pocketpaintLikeUs => 'Do you like Pocket Paint?';

  @override
  String get pocketpaintRateUs => 'Would you like to rate Pocket Paint?';

  @override
  String get pocketpaintFeedback =>
      'We are sorry to hear that. If you want to share your experience with us, please write to contact@catrobat.org';

  @override
  String get pocketpaintYes => 'Yes';

  @override
  String get pocketpaintNo => 'No';

  @override
  String get pocketpaintCancel => 'Cancel';

  @override
  String get pocketpaintNotNow => 'Not now';

  @override
  String get pocketpaintRateUsTitle => 'Rate Pocket Paint';

  @override
  String get introBottomNavigationToolsDescription =>
      'Switch to the tool you want to use.';

  @override
  String get introBottomNavigationCurrentDescription =>
      'Shows the currently used tool and opens its options.';

  @override
  String get introBottomNavigationColorDescription =>
      'Shows the currently used colour and opens the colour picker.';

  @override
  String get introBottomNavigationLayersDescription =>
      'Opens the layer menu and lets you manage your layers.';

  @override
  String get pocketpaintToolIconDescription => 'Current tool icon';

  @override
  String get dialogScaleTitle => 'Image is too big to load';

  @override
  String get dialogScaleMessage =>
      'The image is too big to load. Tap OK to scale down the image automatically.';

  @override
  String get zoomWindowDescription =>
      'Used to display a zoomed in part of the drawing surface';
}
