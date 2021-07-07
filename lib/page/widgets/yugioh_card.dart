part of 'widgets.dart';

class YuGiOhCard extends StatefulWidget {
  const YuGiOhCard({
    Key? key,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
    required this.showBackView,
    this.animationDuration = const Duration(milliseconds: 500),
    this.height,
    this.width,
    this.textStyle,
    this.cardBgColor = const Color(0xff1b447b),
  })  : super(key: key);

  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final TextStyle? textStyle;
  final Color cardBgColor;
  final bool showBackView;
  final Duration animationDuration;
  final double? height;
  final double? width;

  @override
  _YuGiOhCardState createState() => _YuGiOhCardState();
}

class _YuGiOhCardState extends State<YuGiOhCard> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
