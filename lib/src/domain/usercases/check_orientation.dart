import 'package:flutter/material.dart';

import '../../foundation/themes/theme.dart';

abstract class CheckOrientation {
  Orientation get orientation;
  bool get isLandscape;
  bool get isMobile;
}

class CheckOrientationImpl implements CheckOrientation {
  final Size size;

  CheckOrientationImpl({this.size = Size.zero});

  @override
  Orientation get orientation =>
      size.aspectRatio > 1 ? Orientation.landscape : Orientation.portrait;
  @override
  bool get isLandscape => orientation == Orientation.landscape;

  @override
  bool get isMobile =>
      (isLandscape ? size.height : size.width) * size.aspectRatio <
      AppSize.maxMobileSize;
}
