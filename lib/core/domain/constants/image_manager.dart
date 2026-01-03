class ImageManager {
  ImageManager._();
  static final ImageManager _instance = ImageManager._();
  factory ImageManager() => _instance;

  final String iconLogo = 'assets/image/icon.png';
  final String iconLogoZ = 'assets/image/icon-z.png';
  final String onboarding1 = 'assets/image/onboard-1.png';
  final String onboarding2 = 'assets/image/onboard-2.png';
  final String onboarding3 = 'assets/image/onboard-3.png';
  final String getStarted = 'assets/image/get-started.png';
}
