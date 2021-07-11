part of 'widgets.dart';

class HisItem extends StatefulWidget {
  final History item;
  final ValueChanged<bool> isSelected;

  HisItem({required this.item, required this.isSelected});

  @override
  _HisItemState createState() => _HisItemState();
}

class _HisItemState extends State<HisItem> {
  @override
  Widget build(BuildContext context) {
    Uint8List bytes = base64Decode(widget.item.base64Image);
    return Image.memory(bytes, gaplessPlayback: true);
  }
}