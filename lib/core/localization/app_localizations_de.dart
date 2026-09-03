// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get pocketpaintAppName => 'Pocket Paint';

  @override
  String get buttonUndo => 'Rückgängig';

  @override
  String get buttonRedo => 'Wiederholen';

  @override
  String get projectDelete => 'Löschen';

  @override
  String get projectDetails => 'Details';

  @override
  String get projectRename => 'Umbenennen';

  @override
  String get myProjects => 'Meine Projekte';

  @override
  String projectRenameTitle(Object name) {
    return '$name umbenennen';
  }

  @override
  String projectDeleteTitle(Object name) {
    return '$name löschen';
  }

  @override
  String get projectDeleteDialog => 'Projekt wirklich löschen?';

  @override
  String get detailsResolution => 'Auflösung';

  @override
  String get detailsLastModified => 'Letzte Änderung';

  @override
  String get detailsCreationDate => 'Erstelldatum';

  @override
  String get detailsSize => 'Größe';

  @override
  String get menuHideMenu => 'Vollbild';

  @override
  String get menuSaveImage => 'Bild speichern';

  @override
  String get menuSaveProject => 'Projekt speichern';

  @override
  String get menuLoadImage => 'Bild laden';

  @override
  String get menuNewImage => 'Neues Bild';

  @override
  String get menuSaveCopy => 'Kopie speichern';

  @override
  String get menuDiscardImage => 'Bild verwerfen';

  @override
  String get menuReplaceImage => 'Bild ersetzen';

  @override
  String get menuAddToCurrentLayer => 'Zur aktuellen Ebene hinzufügen';

  @override
  String get buttonBrush => 'Pinsel';

  @override
  String get buttonHand => 'Hand';

  @override
  String get buttonEraser => 'Radiergummi';

  @override
  String get buttonLine => 'Linie';

  @override
  String get buttonShape => 'Formen';

  @override
  String get buttonFill => 'Füllen';

  @override
  String get buttonSprayCan => 'Sprühdose';

  @override
  String get buttonCursor => 'Eingabezeiger';

  @override
  String get buttonText => 'Text';

  @override
  String get buttonClipboard => 'Zwischenablage';

  @override
  String get buttonTransform => 'Transformieren';

  @override
  String get buttonImportImage => 'Bild importieren';

  @override
  String get buttonPipette => 'Pipette';

  @override
  String get buttonWatercolor => 'Wasserfarben';

  @override
  String get buttonSmudge => 'Verwischen';

  @override
  String get buttonClip => 'Zuschneidebereich';

  @override
  String get clipboardToolPaste => 'Einfügen';

  @override
  String get clipboardToolCopy => 'Kopieren';

  @override
  String get clipboardToolCut => 'Ausschneiden';

  @override
  String get bottomNavigationTools => 'Werkzeuge';

  @override
  String get bottomNavigationCurrent => 'Aktuell';

  @override
  String get bottomNavigationColor => 'Farbe';

  @override
  String get bottomNavigationLayers => 'Ebenen';

  @override
  String get bottomNavigationItem => 'Element für die untere Navigation';

  @override
  String get buttonApply => 'Anwenden';

  @override
  String get buttonCheckmark => 'Häkchen';

  @override
  String get buttonInfo => 'Information';

  @override
  String get done => 'Fertig';

  @override
  String get gallery => 'Galerie';

  @override
  String get noConnectionSticker =>
      'Sticker nicht verfügbar. Bitte überprüfe deine Internetverbindung';

  @override
  String get stickers => 'Sticker';

  @override
  String get dialogToolsTitle => 'Werkzeuge';

  @override
  String get dialogErrorSaveTitle => 'Fehler Laden/Speichern Datei';

  @override
  String get dialogErrorSdcardText => 'Überprüfe das Bild oder die SD-Karte!';

  @override
  String get dialogBrushWidthText => 'Strichstärke';

  @override
  String get dialogWarningNewImage => 'Änderungen speichern?';

  @override
  String get helpTitle => 'Hilfe';

  @override
  String get helpContentEraser =>
      'Entferne Teile des Bildes mit einem Radiergummi.';

  @override
  String get helpContentBrush =>
      'Tippe auf die Symbole auf der unteren Leiste, um die Farbe oder die Größe des Pinsels zu ändern.';

  @override
  String get helpContentWatercolor =>
      'Ähnlich dem Pinselwerkzeug mit einem Aquarell-Effekt. Du kannst jedoch auch die Stärke des Pinsels mit dem Schieberegler im Farbmenü ändern.';

  @override
  String get helpContentEyedropper =>
      'Tippe auf das Bild, um eine Farbe auszuwählen.';

  @override
  String get helpContentUndo =>
      'Tippe, um deine vorherige Aktion rückgängig zu machen.';

  @override
  String get helpContentRedo =>
      'Tippe, um eine rückgängig gemachte Aktion wiederherzustellen.';

  @override
  String get helpContentFill =>
      'Tippe auf das Bild, um einen Bereich mit der ausgewählten Farbe zu füllen.';

  @override
  String get helpContentCursor =>
      'Positioniere den Zeiger dort wo du zeichnen willst. Tippe um den Zeiger zu aktivieren. Bewege den Finger um zu zeichnen. Tippe erneut, um dies zu deaktivieren.';

  @override
  String get helpContentTransform =>
      'Benutze dies um das Bild zu transformieren.';

  @override
  String get helpContentClipboard =>
      'Verschiebe und skaliere das Rechteck, um den Bereich abzudecken, den du stempeln möchtest. Tippe auf ‚Kopieren‘ oder ‚Ausschneiden‘, um den Bereich auszuwählen. Verschiebe ihn und tippe dann auf ‚Einfügen‘, um den Inhalt aus der Zwischenablage einzufügen.';

  @override
  String get helpContentImportPng =>
      'Importiere ein Bild aus der Galerie auf das Stempel-Werkzeug.';

  @override
  String get helpContentLine => 'Zeichne eine gerade Linie.';

  @override
  String get helpContentText =>
      'Schreibe und formatiere Text. Verändere danach die Größe der Textbox. Tippe, um den Text ins Bild zu malen.';

  @override
  String get helpContentShape =>
      'Wähle eine Form und tipp sie an, um die ausgewählte Form einzufügen';

  @override
  String get helpContentLayer =>
      'Erstelle neue Ebenen oder verändere bestehende';

  @override
  String get helpContentColorChooser => 'Wähle eine Farbe oder passe sie an';

  @override
  String get helpContentHand => 'Bewege deinen Finger um das Bild zu bewegen.';

  @override
  String get helpContentSprayCan =>
      'Bewegen deinen Finger auf das Bild, um ein Spray kann Muster zu erstellen.';

  @override
  String get helpContentSmudge =>
      'Bewege deinen Finger über das Bild, um die Zeichnungen zu verwischen.';

  @override
  String get helpContentClip =>
      'Markiere den Bereich, der erhalten bleiben soll.';

  @override
  String get closingSecurityQuestionTitle => 'Verlassen';

  @override
  String get closingSecurityQuestion => 'Änderungen speichern?';

  @override
  String get noLongclickOnHiddenLayer =>
      'Du kannst nur zusammenführen oder neu anordnen, wenn alle Ebenen sichtbar sind';

  @override
  String get noToolsOnHiddenLayer =>
      'Keine Werkzeuge auf versteckter Ebene verfügbar';

  @override
  String get menuRateUs => 'Bewerte uns!';

  @override
  String get menuFeedback => 'Feedback';

  @override
  String get menuExport => 'Exportieren';

  @override
  String get menuAdvanced => 'Erweiterte Einstellungen';

  @override
  String get menuZoomSettings => 'Zoomfenster Einstellungen';

  @override
  String get shareImageMenu => 'Bild teilen';

  @override
  String get shareImageViaText => 'Bild senden über';

  @override
  String get savedTo => 'Bild gespeichert untern';

  @override
  String get saved => 'Bild gespeichert\n';

  @override
  String get copyTo => 'Kopie gespeichert in\n';

  @override
  String get copy => 'Kopie gespeichert';

  @override
  String get menuQuit => 'Verlassen';

  @override
  String get saveButtonText => 'Speichern';

  @override
  String get discardButtonText => 'Verwerfen';

  @override
  String get cancelButtonText => 'Abbrechen';

  @override
  String get overwriteButtonText => 'Überschreiben';

  @override
  String get deleteButtonText => 'Löschen';

  @override
  String get resizeNothingToResize => 'nichts zu verändern';

  @override
  String get resizeCannotResizeToThisSize =>
      'Kann nicht auf diese Größe angepasst werden';

  @override
  String get resizeMaxImageResolutionReached =>
      'Maximale Bildauflösung erreicht';

  @override
  String get textToolDialogUnderlineShortcut => 'U';

  @override
  String get textToolDialogItalicShortcut => 'K';

  @override
  String get textToolDialogBoldShortcut => 'F';

  @override
  String get textToolDialogInputHint => 'Tippe hier, um zu schreiben';

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
  String get shapeToolDialogRectTitle => 'Rechteck';

  @override
  String get shapeToolDialogEllipseTitle => 'Ellipse';

  @override
  String get shapeToolDialogStarTitle => 'Stern';

  @override
  String get shapeToolDialogHeartTitle => 'Herz';

  @override
  String get shapeToolDialogFillTitle => 'Füllen';

  @override
  String get shapeToolDialogOutlineTitle => 'Kontur';

  @override
  String get shapeToolDialogDashed => 'Gestrichelt';

  @override
  String get shapeToolDialogFillDashed => 'Gefüllt & gestrichelt';

  @override
  String get strokeTypeRound => 'Runder Strich';

  @override
  String get strokeTypeSquare => 'Eckiger Strich';

  @override
  String get fillToolDialogColorToleranceTitle => 'Farbtoleranz';

  @override
  String get smudgeToolDialogPressureTitle => 'Druck';

  @override
  String get smudgeToolDialogDragTitle => 'Ziehen';

  @override
  String get transformToolRotateLeft => 'Nach links drehen';

  @override
  String get transformToolRotateRight => 'Nach rechts drehen';

  @override
  String get transformToolFlipVertical => 'Vertikal spiegeln';

  @override
  String get transformToolFlipHorizontal => 'Horizontal spiegeln';

  @override
  String get transformToolResizeText => 'Größe anpassen';

  @override
  String get transformToolAutoCropText => 'Zuschneiden/Vergrößern';

  @override
  String get transformWidthText => 'Breite';

  @override
  String get transformHeightText => 'Höhe';

  @override
  String get transformAutoCropText => 'automatisch';

  @override
  String get transformSetCenterText => 'Mitte setzen';

  @override
  String get pixel => 'px';

  @override
  String get clipboardToolCopyHint =>
      'Tippe auf ‚Kopieren‘, um den Inhalt zu kopieren.';

  @override
  String get layersTitle => 'Ebenen';

  @override
  String get layerNew => 'Neue Ebene';

  @override
  String get layerDelete => 'Ebene löschen';

  @override
  String get layerTooManyLayers => 'Zu viele Ebenen';

  @override
  String get layerMerged => 'Ebenen zusammengefügt';

  @override
  String get layerBackground => 'Ebenenhintergrund';

  @override
  String get layerPreview => 'Ebenenvorschau';

  @override
  String get dialogLoadingImageFailedTitle => 'Fehler beim Laden vom Bild';

  @override
  String get dialogLoadingImageFailedText => 'Kein gültiges Bild';

  @override
  String get dialogSettings => 'Einstellungen';

  @override
  String get dialogSaveImageName => 'Bildname';

  @override
  String get dialogSaveImageFormat => 'Bildformat';

  @override
  String get dialogSaveProjectName => 'Projektname';

  @override
  String get dialogErrorProjectName => 'Bitte gib einen Projektnamen ein';

  @override
  String get dialogErrorImageName => 'Bitte gib einen Bildnamen ein';

  @override
  String get dialogAntialiasing => 'Antialiasing';

  @override
  String get dialogSmoothing => 'Glättung';

  @override
  String get dialogZoomWindowEnabled => 'Aktiviert';

  @override
  String get dialogSaveJpgOptionQuality => 'Qualität';

  @override
  String get pocketpaintJpgMessageDialog =>
      'Verwendet minimalen Speicherplatz. Keine Transparenz wird gespeichert.';

  @override
  String get pocketpaintPngMessageDialog =>
      'Verlustfreie Kompression. Transparenz bleibt erhalten.';

  @override
  String get pocketpaintOraMessageDialog => 'Dieses Format erinnert sich an ';

  @override
  String get pocketpaintCatrobatMessageDialog =>
      'Das native Bildformat von Pocket Paint. Dieses Format merkt sich Befehle und Ebenen.';

  @override
  String get permissionInfoExternalStorageText =>
      'Diese App benötigt die angeforderte Berechtigung, um richtig zu funktionieren. Um Bilder im lokalen Speicher zu speichern, benötigt die App Lese- und Schreibzugriff.';

  @override
  String get permissionInfoPermanentDenialText =>
      'Diese App benötigt die angeforderte Berechtigung, um richtig zu funktionieren. Um Bilder im lokalen Speicher zu speichern, benötigt die App Lese- und Schreibzugriff.\n        Da du die Erlaubnis mit nicht erneut fragen verweigert hast , geh bitte zu deinen Telefoneinstellungen und erteile die erforderlichen Berechtigungen, wenn du die zugehörigen Funktionen nutzen möchtest.';

  @override
  String get setCenterInfoText =>
      'Tippe auf den Bildschirm, um den neuen Mittelpunkt festzulegen.';

  @override
  String get transformInfoText =>
      'Ziehe die Kanten an ihre neue Position und tipp dann, um den Bildbereich zu vergrößern oder zu verkleinern.';

  @override
  String get cursorDrawInactive =>
      'Verschieben, dann tippen, um mit dem Malen beginnen.';

  @override
  String get cursorDrawActive =>
      'Verschieben um zu zeichnen, dann tippen um Malen zu stoppen.';

  @override
  String get welcomeToPocketPaint => 'Willkommen bei Pocket Paint';

  @override
  String get introWelcomeText =>
      'Mit Pocket Paint sind deiner Kreativität keine Grenzen gesetzt. Wenn du hier neu bist, starte das Intro oder überspringe es, wenn du bereits mit Pocket Paint vertraut bist.';

  @override
  String get introToolMoreInformation =>
      'Tippe auf ein Werkzeug, um weitere Informationen zu erhalten';

  @override
  String get morePossibilities => 'Mehr Möglichkeiten';

  @override
  String get introPossibilitiesText =>
      'Verwende die obere Leiste, um das Hauptmenü zu öffnen und Änderungen rückgängig zu machen';

  @override
  String get landscape => 'Querformat';

  @override
  String get introLandscapeText =>
      'Pocket Paint unterstützt auch zeichnen im Querformatmodus, um das beste Malerlebnis zu bieten.';

  @override
  String get enjoyPocketPaint =>
      'Es kann losgehen. Viel Spaß mit Pocket Paint.';

  @override
  String get introGetStarted => 'Lege los und gestalte ein neues Meisterwerk.';

  @override
  String get letsGo => 'Los geht\'s';

  @override
  String get next => 'Weiter';

  @override
  String get skip => 'Überspringen';

  @override
  String get pocketpaintAboutTitle => 'Über';

  @override
  String pocketpaintAboutContent(Object license) {
    return 'Pocket Paint ist ein Bild-Editor, der Teil des Catrobat Projektes ist.\n\nCatrobat ist eine visuelle Programmiersprache welche kreative Tools für Smartphones bereitstellt.\n\n Der Source-Code von Pocket Paint steht hauptsächlich unter der $license Lizenz.\n Für genaue Angaben zu der Lizenz, beachte den Link unten.';
  }

  @override
  String get pocketpaintAboutUrlLicenseDescription =>
      'Pocket Code Source Code Lizenz';

  @override
  String get pocketpaintAboutUrlCatrobatDescription => 'Über Catrobat';

  @override
  String get pocketpaintIntro => 'Intro';

  @override
  String get pocketpaintIntroSplitScreenNotSupported =>
      'Das Teilen des Bildschirms wird im Intro nicht unterstützt';

  @override
  String get pocketpaintOverwriteTitle => 'Datei überschreiben?';

  @override
  String get pocketpaintOverwrite =>
      'Du bist dabei ein vorhandenes Projekt zu überschreiben. Trotzdem speichern?';

  @override
  String get pocketpaintLikeUs => 'Gefällt dir Pocket Paint?';

  @override
  String get pocketpaintRateUs => 'Möchtest du Pocket Paint bewerten?';

  @override
  String get pocketpaintFeedback =>
      'Es tut uns leid, das zu hören. Wenn du deine Erfahrungen mit uns teilen möchtest, schreib uns an contact@catrobat.org';

  @override
  String get pocketpaintYes => 'Ja';

  @override
  String get pocketpaintNo => 'Nein';

  @override
  String get pocketpaintCancel => 'Abbrechen';

  @override
  String get pocketpaintNotNow => 'Nicht jetzt';

  @override
  String get pocketpaintRateUsTitle => 'Bewerte Pocket Paint';

  @override
  String get introBottomNavigationToolsDescription =>
      'Wechsle zum Werkzeug das du verwenden willst.';

  @override
  String get introBottomNavigationCurrentDescription =>
      'Zeigt das aktuell verwendete Werkzeug an und öffnet seine Optionen.';

  @override
  String get introBottomNavigationColorDescription =>
      'Zeigt die aktuell verwendete Farbe an und öffnet den Farbwähler.';

  @override
  String get introBottomNavigationLayersDescription =>
      'Öffnet das Ebenenmenü und lässt dich deine Ebenen verwalten.';

  @override
  String get pocketpaintToolIconDescription => 'Aktuelles Werkzeug Symbol';

  @override
  String get dialogScaleTitle => 'Bild ist zu groß zum laden';

  @override
  String get dialogScaleMessage =>
      'Das Bild ist zu groß zum Laden. Klicke auf OK, um das Bild automatisch zu verkleinern.';

  @override
  String get zoomWindowDescription =>
      'Zeigt einen vergrößerten Bereich der Zeichenfläche an.';

  @override
  String get pipette => 'PIPETTE';

  @override
  String get saveChanges => 'Save changes?';

  @override
  String get saveChangesContent => 'Do you want to save your changes?';

  @override
  String get yes => 'YES';

  @override
  String get no => 'NO';
}
