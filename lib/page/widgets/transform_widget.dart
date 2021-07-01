part of 'widgets.dart';

class TransformerWidget extends StatefulWidget {
  final Widget child;

  TransformerWidget(this.child, {Key? key}) : super(key: key);

  @override
  _TransformerWidgetState createState() => _TransformerWidgetState();
}

class _TransformerWidgetState extends State<TransformerWidget> {
  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());

  @override
  Widget build(BuildContext context) {
    return MatrixGestureDetector(
      clipChild: false,
      onMatrixUpdate: (m, tm, sm, rm) {
        notifier.value = m;
      },
      child: AnimatedBuilder(
        animation: notifier,
        builder: (ctx, child) {
          return Transform(
            transform: notifier.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}