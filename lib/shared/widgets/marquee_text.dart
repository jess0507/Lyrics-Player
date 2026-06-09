import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// 單行文字跑馬燈：文字寬度超出可用寬度時，以等速無縫循環水平滾動；
/// 未超出時則靜態顯示（依 [textAlign] 對齊），不滾動。
class MarqueeText extends StatefulWidget {
  const MarqueeText(
    this.text, {
    super.key,
    this.style,
    this.textAlign = TextAlign.center,
    this.velocity = 30,
    this.gap = 48,
  });

  final String text;
  final TextStyle? style;
  final TextAlign textAlign;

  /// 滾動速度（像素 / 秒）。
  final double velocity;

  /// 循環時兩份文字之間的間隔（像素）。
  final double gap;

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _measure(String text, TextStyle style, TextScaler scaler) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: Directionality.of(context),
      textScaler: scaler,
    )..layout();
    return painter.size.width;
  }

  /// 依當前量測結果於下一幀同步動畫狀態（避免在 build 期間改動畫）。
  void _sync({required bool scroll, Duration? duration}) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (scroll) {
        if (_controller.duration != duration) {
          _controller.duration = duration;
          _controller
            ..reset()
            ..repeat();
        } else if (!_controller.isAnimating) {
          _controller.repeat();
        }
      } else if (_controller.isAnimating) {
        _controller.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? DefaultTextStyle.of(context).style;
    final scaler = MediaQuery.textScalerOf(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final textWidth = _measure(widget.text, style, scaler);
        final maxWidth = constraints.maxWidth;

        Widget line() => Text(
              widget.text,
              style: style,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.visible,
            );

        // 未超出可用寬度：靜態顯示，不滾動。
        if (!maxWidth.isFinite || textWidth <= maxWidth) {
          _sync(scroll: false);
          return Text(
            widget.text,
            style: style,
            textAlign: widget.textAlign,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          );
        }

        // 超出：以兩份文字無縫循環滾動。
        final scrollDistance = textWidth + widget.gap;
        final duration = Duration(
          milliseconds: (scrollDistance / widget.velocity * 1000).round(),
        );
        _sync(scroll: true, duration: duration);

        return ClipRect(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => Transform.translate(
              offset: Offset(-_controller.value * scrollDistance, 0),
              child: child,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                line(),
                SizedBox(width: widget.gap),
                line(),
              ],
            ),
          ),
        );
      },
    );
  }
}
