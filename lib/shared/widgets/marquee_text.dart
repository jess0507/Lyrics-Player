import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

/// 單行文字跑馬燈：文字寬度超出可用寬度時，以等速無縫循環水平滾動；
/// 未超出時則靜態顯示（依 [textAlign] 對齊），不滾動。
class MarqueeText extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final style = this.style ?? DefaultTextStyle.of(context).style;

    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: 1,
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
        )..layout();

        // 未超出可用寬度：靜態顯示，不滾動。
        if (!constraints.maxWidth.isFinite ||
            painter.size.width <= constraints.maxWidth) {
          return Text(
            text,
            style: style,
            textAlign: textAlign,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          );
        }

        // Marquee 會填滿可用高度，固定為單行文字高度以維持垂直置中。
        return SizedBox(
          height: painter.size.height,
          child: Marquee(
            text: text,
            style: style,
            blankSpace: gap,
            velocity: velocity,
          ),
        );
      },
    );
  }
}
