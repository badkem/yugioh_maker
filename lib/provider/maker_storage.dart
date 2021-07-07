part of 'provider.dart';

class MakerStorage {
  String name = 'name';
  String nameType = 'name type';
  String decs = 'description';
  String atk = '0000';
  String def = '0000';
  String year = '2021';
  String initImgLv = 'assets/images/level.png';
  String initRank = 'assets/images/rank.png';
  int initLv = 1;
  int number = 0;

  var initAttr =
      Attribute(name: 'Light', image: 'assets/images/attribute/Light.png');
  var initType =
      CardType(type: 1, name: 'Normal', image: 'assets/images/theme/1.png');
  var initTrapSpellType = TrapSpellType(
      name: 'Continuous',
      image: 'assets/images/trap_spell_type/Continuous.png');

  final cardType = <CardType>[
    CardType(type: 1, name: 'Normal', image: 'assets/images/theme/1.png'),
    CardType(type: 2, name: 'Effect', image: 'assets/images/theme/2.png'),
    CardType(type: 3, name: 'Fusion', image: 'assets/images/theme/3.png'),
    CardType(type: 4, name: 'Ritual', image: 'assets/images/theme/4.png'),
    CardType(type: 6, name: 'Synchro', image: 'assets/images/theme/6.png'),
    CardType(type: 7, name: 'Token', image: 'assets/images/theme/7.png'),
    CardType(type: 8, name: 'XYZ', image: 'assets/images/theme/8.png'),
    CardType(type: 9, name: 'Spell', image: 'assets/images/theme/9.png'),
    CardType(type: 10, name: 'Trap', image: 'assets/images/theme/10.png'),
  ];

  final attribute = <Attribute>[
    Attribute(name: 'Light', image: 'assets/images/attribute/Light.png'),
    Attribute(name: 'Dark', image: 'assets/images/attribute/Dark.png'),
    Attribute(name: 'Divine', image: 'assets/images/attribute/Divine.png'),
    Attribute(name: 'Earth', image: 'assets/images/attribute/Earth.png'),
    Attribute(name: 'Fire', image: 'assets/images/attribute/Fire.png'),
    Attribute(name: 'Water', image: 'assets/images/attribute/Water.png'),
    Attribute(name: 'Wind', image: 'assets/images/attribute/Wind.png'),
    Attribute(name: 'Spell', image: 'assets/images/attribute/Spell.png'),
    Attribute(name: 'Trap', image: 'assets/images/attribute/Trap.png'),
  ];

  final trapSpellType = <TrapSpellType>[
    TrapSpellType(
        name: 'Continuous',
        image: 'assets/images/trap_spell_type/Continuous.png'),
    TrapSpellType(
        name: 'Counter', image: 'assets/images/trap_spell_type/Counter.png'),
    TrapSpellType(
        name: 'Equip', image: 'assets/images/trap_spell_type/Equip.png'),
    TrapSpellType(
        name: 'Field', image: 'assets/images/trap_spell_type/Field.png'),
    TrapSpellType(
        name: 'Quick-Play',
        image: 'assets/images/trap_spell_type/Quick-Play.png'),
    TrapSpellType(
        name: 'Ritual', image: 'assets/images/trap_spell_type/Ritual.png'),
  ];

  final levels = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
}
