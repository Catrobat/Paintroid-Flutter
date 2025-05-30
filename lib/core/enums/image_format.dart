enum ImageFormat {
  png('png'),
  jpg('jpg'),
  ora('ora'),
  catrobatImage('catrobat-image');

  const ImageFormat(this.extension);

  final String extension;
}
