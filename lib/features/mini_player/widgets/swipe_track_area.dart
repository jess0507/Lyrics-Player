import 'package:flutter/material.dart';

/// 判定為切歌的最低甩動速度（像素 / 秒）。
const _flingVelocity = 200.0;

/// 未達甩動速度時，拖曳位移超過寬度的此比例也判定為切歌。
const _switchFraction = 1 / 3;

/// 水平滑動切換曲目的區域，帶跟手位移與淡出效果。
///
/// 拖曳時 [child] 跟著手指水平移動並漸淡；放開時若超過門檻
/// （甩動夠快或位移夠遠）則滑出畫面、觸發 [onNext] / [onPrevious]，
/// 新內容再從另一側滑入，否則彈回原位。
/// 只註冊水平拖曳手勢，點擊會穿透給外層（例如展開播放器的 InkWell）。
class SwipeTrackArea extends StatefulWidget {
  const SwipeTrackArea({
    super.key,
    required this.onPrevious,
    required this.onNext,
    required this.child,
  });

  /// 向右滑（回上一首）超過門檻時觸發。
  final VoidCallback onPrevious;

  /// 向左滑（跳下一首）超過門檻時觸發。
  final VoidCallback onNext;

  final Widget child;

  @override
  State<SwipeTrackArea> createState() => _SwipeTrackAreaState();
}

class _SwipeTrackAreaState extends State<SwipeTrackArea>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  /// child 目前的水平位移（像素，正值向右）。
  double _offset = 0;

  /// 目前掛在 controller 上的動畫 listener；
  /// 動畫可能被拖曳中斷（stop），下次動畫前需手動移除。
  VoidCallback? _tick;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 將 [_offset] 動畫到 [target]，完成後執行 [onCompleted]。
  void _animateTo(double target, {VoidCallback? onCompleted}) {
    if (_tick != null) _controller.removeListener(_tick!);
    final animation = Tween(begin: _offset, end: target).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _tick = () => setState(() => _offset = animation.value);
    _controller
      ..stop()
      ..reset()
      ..addListener(_tick!);
    // 動畫被拖曳中斷（stop）時 TickerFuture 不會 complete，
    // onCompleted 只在真正跑完時觸發。
    _controller.forward().whenComplete(() => onCompleted?.call());
  }

  /// 滑出到 [edge]（±寬度）後切歌，新內容從另一側滑入。
  void _switchTrack(double edge, VoidCallback onSwitch) {
    _animateTo(
      edge,
      onCompleted: () {
        onSwitch();
        setState(() => _offset = -edge);
        _animateTo(0);
      },
    );
  }

  void _onDragEnd(DragEndDetails details, double width) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity <= -_flingVelocity ||
        (velocity < _flingVelocity && _offset <= -width * _switchFraction)) {
      _switchTrack(-width, widget.onNext);
    } else if (velocity >= _flingVelocity ||
        _offset >= width * _switchFraction) {
      _switchTrack(width, widget.onPrevious);
    } else {
      _animateTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: (_) => _controller.stop(),
          onHorizontalDragUpdate: (details) =>
              setState(() => _offset += details.delta.dx),
          onHorizontalDragEnd: (details) => _onDragEnd(details, width),
          // Transform.translate 只是繪製位移，不會被父層佈局約束擋住；
          // 用 ClipRect 裁切，位移中的內容才不會畫到旁邊的封面 / 按鈕上。
          child: ClipRect(
            child: Transform.translate(
              offset: Offset(_offset, 0),
              child: Opacity(
                opacity: (1 - _offset.abs() / width).clamp(0.0, 1.0),
                // 撐滿可用寬高，內容較小時也有足夠的滑動命中區域。
                child: SizedBox(
                  width: width,
                  height: constraints.maxHeight.isFinite
                      ? constraints.maxHeight
                      : null,
                  child: widget.child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
