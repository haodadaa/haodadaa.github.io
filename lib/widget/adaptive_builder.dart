import 'package:flutter/widgets.dart';

enum ScreenType {
  small,
  medium,
  large,
}

class AdaptiveBuilder extends StatelessWidget {
  final Function(BuildContext context, ScreenInfo screenInfo, Size widgetSize)
      builder;

  const AdaptiveBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      Size screenSize = MediaQuery.of(context).size;
      ScreenType screenType = getScreenTypeFromSize(screenSize);
      return builder(
        context,
        ScreenInfo(screenType: screenType, screenSize: screenSize),
        constraints.biggest,
      );
    });
  }

  ScreenType getScreenTypeFromSize(Size size) {
    double aspectRatio = size.width / size.height;
    if (aspectRatio < 3 / 4) {
      return ScreenType.small;
    } else if (aspectRatio < 1) {
      return ScreenType.medium;
    } else {
      return ScreenType.large;
    }
  }
}

class ScreenInfo {
  final ScreenType screenType;
  final Size screenSize;

  ScreenInfo({required this.screenType, required this.screenSize});
}
