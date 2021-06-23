import 'package:blog/module/global/app_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'package:blog/module/global/app_ext.dart';

typedef WidgetBuilder = Widget Function(BuildContext context);

abstract class BasePage extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);

  Widget build(BuildContext context);

  static BasePageState of(BuildContext context) {
    final BasePageState? result =
        context.findAncestorStateOfType<BasePageState>();
    if (result != null) return result;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
          'BasePage.of() called with a context that does not contain a BasePage.'),
      ErrorDescription(
          'No BasePage ancestor could be found starting from the context that was passed to BasePage.of(). '
          'This usually happens when the context provided is from the same StatefulWidget as that '
          'whose build function actually creates the BasePage widget being sought.'),
      context.describeElement('The context used was')
    ]);
  }

  @override
  BasePageState createState() => BasePageState();
}

class BasePageState extends State<BasePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: context.globalBloc,
      builder: (context, state) {
        return widget.build(context);
      },
    );
  }
}

extension RadiusUIExt on num {
  BorderRadius get allCircular => BorderRadius.all(Radius.circular(this * 1.0));

  BorderRadius get topLeftCircular =>
      BorderRadius.only(topLeft: Radius.circular(this * 1.0));

  BorderRadius get topRightCircular =>
      BorderRadius.only(topRight: Radius.circular(this * 1.0));

  BorderRadius get bottomLeftCircular =>
      BorderRadius.only(bottomLeft: Radius.circular(this * 1.0));

  BorderRadius get bottomRightCircular =>
      BorderRadius.only(bottomRight: Radius.circular(this * 1.0));
}

extension BaseStateExt on BuildContext {
  BasePageState get baseState {
    return BasePage.of(this);
  }
}
