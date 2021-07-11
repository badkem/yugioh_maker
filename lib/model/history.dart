part of 'model.dart';

@HiveType(typeId: 0)
class History {
  History({
    required this.cardType,
    required this.type,
    required this.attr,
    required this.name,
    required this.image,
    required this.base64Image,
    this.trapSpellType,
    required this.nameType,
    required this.desc,
    required this.serialNumber,
    required this.level,
    required this.year,
    required this.atk,
    required this.def,
  });

  @HiveField(0)
  int type;
  @HiveField(1)
  int serialNumber;
  @HiveField(2)
  int level;
  @HiveField(3)
  String cardType;
  @HiveField(4)
  String attr;
  @HiveField(5)
  String name;
  @HiveField(6)
  String image;
  @HiveField(7)
  String base64Image;
  @HiveField(8)
  String? trapSpellType;
  @HiveField(9)
  String nameType;
  @HiveField(10)
  String desc;
  @HiveField(11)
  String year;
  @HiveField(12)
  String atk;
  @HiveField(13)
  String def;
  bool isSelected = false;

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
    base64Image: json['base64Image'],
  );

  Map<String, dynamic> toMap() => {
    "cardType": cardType,
    "type": type,
    "attr": attr,
    "trapSpellType": trapSpellType,
    "name": name,
    "image": image,
    'base64Image': base64Image,
    "nameType": nameType,
    "desc": desc,
    "serialNumber": serialNumber,
    "level": level,
    "year": year,
    "atk": atk,
    "def": def,
  };

}
