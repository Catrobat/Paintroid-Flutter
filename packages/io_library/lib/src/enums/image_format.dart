enum ImageFormat {
  png('png'),
  jpg('jpg'),
  catrobatImage('catrobat-image'),
  ora('ora');

  const ImageFormat(this.extension);

  final String extension;
}
