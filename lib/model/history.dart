
part of 'model.dart';

class History {
  History({
    required this.cardType,
    required this.type,
    required this.attr,
    required this.name,
    this.image,
    this.trapSpellType,
    required this.nameType,
    required this.desc,
    required this.serialNumber,
    required this.level,
    required this.year,
    required this.atk,
    required this.def,
  });

  int type;
  int serialNumber;
  int level;
  String cardType;
  String attr;
  String name;
  String? image;
  String? trapSpellType;
  String nameType;
  String desc;
  String year;
  String atk;
  String def;

  factory History.fromJson(String str) => History.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory History.fromMap(Map<String, dynamic> json) => History(
    cardType: json["cardType"],
    type: json["type"],
    attr: json["attr"],
    trapSpellType: json["trapSpellType"],
    name: json["name"],
    image: json["image"],
    nameType: json["nameType"],
    desc: json["desc"],
    serialNumber: json["serialNumber"],
    level: json["level"],
    year: json["year"],
    atk: json["atk"],
    def: json["def"],
  );

  Map<String, dynamic> toMap() => {
    "cardType": cardType,
    "type": type,
    "attr": attr,
    "trapSpellType": trapSpellType,
    "name": name,
    "image": image,
    "nameType": nameType,
    "desc": desc,
    "serialNumber": serialNumber,
    "level": level,
    "year": year,
    "atk": atk,
    "def": def,
  };

}
