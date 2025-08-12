import 'dart:ui' as ui;

double get pixelRatio =>
    ui.PlatformDispatcher.instance.views.first.devicePixelRatio;
ui.Size get size =>
    ui.PlatformDispatcher.instance.views.first.physicalSize / pixelRatio;

double get width => size.width;
double get height => size.height;

double get kVerticalMargin => height * 0.02;
double get kHorizontalMargin => width * 0.03;

double getResponsiveFont(double fontSize) {
  final double widthInDp = width;
  final double physicalPixelWidth = width * pixelRatio;

  final double dpi = ((physicalPixelWidth / widthInDp) * 160) - 5;

  if (dpi <= 120) {
    return 0.25 * fontSize;
  } else if (dpi <= 160) {
    return (1 / 3) * fontSize;
  } else if (dpi <= 240) {
    return 0.5 * fontSize;
  } else if (dpi <= 320) {
    return 0.8 * fontSize;
  } else if (dpi <= 480) {
    return fontSize * 0.9;
  } else if (dpi <= 600) {
    return 1.0 * fontSize;
  } else if (dpi <= 640) {
    return (4 / 3) * fontSize;
  } else {
    return 1.8 * fontSize;
  }
}
