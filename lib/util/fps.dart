import 'dart:async';
import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FPS extends StatefulWidget {
  final Widget? child;

  const FPS({Key? key, this.child}) : super(key: key);

  @override
  _FPSState createState() => _FPSState();
}

class _FPSState extends State<FPS> {
  ListQueue<FrameTiming> lastFrames = ListQueue<FrameTiming>(60);

  StreamController<double> _fpsController = StreamController.broadcast();
  late Timer intervalTimer;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addTimingsCallback(timingCallback);
    intervalTimer = Timer.periodic(Duration(microseconds: 1000), (timer) {
      if (lastFrames.length == 0) {
        return;
      }
      _fpsController.add(FPSUtil.fps(lastFrames));
    });
  }

  @override
  void dispose() {
    _fpsController.close();
    SchedulerBinding.instance?.removeTimingsCallback(timingCallback);
    super.dispose();
  }

  void timingCallback(List<FrameTiming> timings) {
    // 把 Queue 当作堆栈用
    for (FrameTiming timing in timings) {
      lastFrames.addFirst(timing);
    }
    while (lastFrames.length > 60) {
      lastFrames.removeLast();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          if (widget.child != null) widget.child!,
          StreamBuilder<double>(
            initialData: 0,
            stream: _fpsController.stream,
            builder: (context, snapshot) {
              return Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 12, top: 12),
                  child: Text(
                    (snapshot.data! ~/ 1).toString(),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class FPSUtil {
  static const REFRESH_RATE = 60;
  static const frameInterval = const Duration(
      microseconds: Duration.microsecondsPerSecond ~/ REFRESH_RATE);

  static double fps(ListQueue<FrameTiming> lastFrames) {
    List<FrameTiming> lastFramesSet = <FrameTiming>[];
    for (FrameTiming timing in lastFrames) {
      if (lastFramesSet.isEmpty) {
        // 首帧
        lastFramesSet.add(timing);
      } else {
        var lastStart =
            lastFramesSet.last.timestampInMicroseconds(FramePhase.buildStart);
        if (lastStart -
                timing.timestampInMicroseconds(FramePhase.rasterFinish) >
            (frameInterval.inMicroseconds * 2)) {
          // in different set
          break;
        }
        lastFramesSet.add(timing);
      }
    }
    var framesCount = lastFramesSet.length;
    var costCount = lastFramesSet.map<int>((t) {
      // 耗时超过 frameInterval 会导致丢帧
      return (t.totalSpan.inMicroseconds ~/ frameInterval.inMicroseconds) + 1;
    }).fold(0, (int a, int b) {
      return a + b;
    });
    return framesCount * REFRESH_RATE / costCount;
  }
}
