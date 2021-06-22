import 'dart:math';

import 'package:blog/widget/mouse_region_effect.dart';
import 'package:flutter/material.dart';
import 'package:blog/core/extension/num.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 主题风格切换按钮
class DayNightSwitcher extends StatefulWidget {
  final List<String> assets;
  final Function(int index)? onTap;

  const DayNightSwitcher({Key? key, this.onTap, required this.assets})
      : super(key: key);

  @override
  _DarkSwitchState createState() => _DarkSwitchState();
}

class _DarkSwitchState extends State<DayNightSwitcher>
    with SingleTickerProviderStateMixin {
  /// 切换动画
  int currentIndex = 0;
  late AnimationController rotateAnimController;
  late Animation<double> rotateAnimation;

  @override
  void initState() {
    super.initState();
    // 点击旋转动画
    rotateAnimController = AnimationController(
      vsync: this,
      duration: 300.milliseconds,
    );
    rotateAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(rotateAnimController);
  }

  @override
  void dispose() {
    rotateAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (rotateAnimController.status == AnimationStatus.forward) {
          return;
        }
        if (currentIndex == 0) {
          rotateAnimController.reset();
        }
        rotateAnimController.animateTo(
          (currentIndex + 1) / widget.assets.length,
          duration: 300.milliseconds,
          curve: Curves.easeOutExpo,
        );
        currentIndex = (currentIndex + 1) % widget.assets.length;
        widget.onTap?.call(currentIndex);
      },
      child: MouseShadowWidget(
        translate: 4,
        child: ClipRect(
          child: Container(
            alignment: Alignment.center,
            width: 46,
            height: 37,
            child: ThemeDiskWidget(widget.assets, rotateAnimation),
          ),
        ),
      ),
    );
  }
}

class ThemeDiskWidget extends StatelessWidget {
  final List<String> assets;
  final Animation<double> rotateAnimation;

  const ThemeDiskWidget(this.assets, this.rotateAnimation, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      Size size = constraints.biggest;
      Offset circleCenter;
      if (assets.length < 3) {
        circleCenter = Offset(0, size.height / 2);
      } else {
        double angle = 360 / assets.length;
        double extraWidth = size.height / 2 / cos(angle / 2) * sin(angle / 2);
        double radius =
            size.height / 2 * ((size.width / 2 + extraWidth) / extraWidth);
        circleCenter = Offset(0, radius);
      }
      return AnimatedBuilder(
        animation: rotateAnimation,
        builder: (context, child) {
          return Transform.rotate(
            alignment: Alignment.bottomCenter,
            origin: circleCenter,
            angle: rotateAnimation.value,
            child: Stack(
              children: List.generate(
                assets.length,
                (index) {
                  return Transform.rotate(
                    alignment: Alignment.bottomCenter,
                    origin: circleCenter,
                    angle: index / assets.length * 2 * pi,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: SvgPicture.asset(assets[index]),
                    ),
                  );
                },
              ),
            ),
          );
        },
      );
    });
  }
}
