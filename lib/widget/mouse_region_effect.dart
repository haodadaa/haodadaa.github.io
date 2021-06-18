import 'package:blog/core/extension/num.dart';
import 'package:flutter/material.dart';

class MouseShadowWidget extends StatefulWidget {
  final Color? color;
  final Color? shadowColor;
  final double? translate;
  final Widget child;

  const MouseShadowWidget({
    Key? key,
    required this.child,
    this.color,
    this.shadowColor,
    this.translate,
  }) : super(key: key);

  @override
  _MouseShadowWidgetState createState() => _MouseShadowWidgetState();
}

class _MouseShadowWidgetState extends State<MouseShadowWidget>
    with SingleTickerProviderStateMixin {
  /// 鼠标区域阴影动画
  late AnimationController shadowAnimController;
  late Animation<double> shadowAnimation;
  late Animation<double> translateAnimation;

  @override
  void initState() {
    super.initState();
    // 鼠标动画
    shadowAnimController = AnimationController(
      vsync: this,
      duration: 300.milliseconds,
    );
    shadowAnimation = CurvedAnimation(
      parent: shadowAnimController,
      curve: Curves.easeOutQuart,
    );
    translateAnimation = Tween<double>(
      begin: 0,
      end: widget.translate ?? 5,
    ).animate(CurvedAnimation(
      parent: shadowAnimController,
      curve: Curves.easeOutQuart,
    ));
  }

  @override
  void dispose() {
    shadowAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        shadowAnimController.forward();
      },
      onExit: (event) {
        shadowAnimController.reverse();
      },
      child: AnimatedBuilder(
        animation: shadowAnimController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, -translateAnimation.value),
            child: Container(
              decoration: BoxDecoration(
                color: widget.color ?? Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: (widget.shadowColor ?? Color(0x61000000))
                        .withOpacity(shadowAnimation.value),
                    blurRadius: 4 * shadowAnimation.value,
                  ),
                ],
              ),
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}

class MouseScaleWidget extends StatefulWidget {
  final Widget child;
  final double? scale;

  const MouseScaleWidget({
    Key? key,
    required this.child,
    this.scale,
  }) : super(key: key);

  @override
  _MouseScaleWidgetState createState() => _MouseScaleWidgetState();
}

class _MouseScaleWidgetState extends State<MouseScaleWidget>
    with SingleTickerProviderStateMixin {
  /// 鼠标区域缩放动画
  late AnimationController scaleAnimController;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    // 鼠标动画
    scaleAnimController = AnimationController(
      vsync: this,
      duration: 300.milliseconds,
    );
    scaleAnimation = Tween<double>(
      begin: 1,
      end: widget.scale ?? 1.1,
    ).animate(CurvedAnimation(
      parent: scaleAnimController,
      curve: Curves.easeOutQuart,
    ));
  }

  @override
  void dispose() {
    scaleAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        scaleAnimController.forward();
      },
      onExit: (event) {
        scaleAnimController.reverse();
      },
      child: AnimatedBuilder(
        animation: scaleAnimController,
        builder: (context, child) {
          return Transform.scale(
            scale: scaleAnimation.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
