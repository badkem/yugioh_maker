part of 'theme.dart';

class AppColors {
  static final Color dropdownButton = HexColor.fromHex('F2CB8D');
  static final Color placeHolder = HexColor.fromHex('EFE0B6');
}

class HexColor {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    // ignore: always_put_control_body_on_new_line
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}