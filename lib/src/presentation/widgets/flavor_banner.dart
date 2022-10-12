import 'package:flutter/material.dart';

import '../../foundation/common/common.dart';

class FlavorBanner extends StatelessWidget {
  final Widget child;
  final bool show;
  const FlavorBanner({
    Key? key,
    required this.child,
    this.show = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return show
        ? Banner(
            location: BannerLocation.topStart,
            message: Constants.env.name,
            color: Constants.envColor,
            textStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12.0,
              letterSpacing: 1.0,
            ),
            child: child,
          )
        : Container(
            child: child,
          );
  }
}
