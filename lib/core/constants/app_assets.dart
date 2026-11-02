/// Central asset path registry. Folder declared in pubspec: assets/images/.
abstract final class AppAssets {
  static const String _imagesDir = 'assets/images';

  static const String appIcon = '$_imagesDir/app_icon.png';
  static const String appBanner = '$_imagesDir/app_banner.png';
}
