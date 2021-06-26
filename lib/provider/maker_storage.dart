part of 'provider.dart';

class MakerStorage {
  String name = 'name';
  String nameType = 'card type';
  String decs = 'card description';
  String atk = '';
  String def = '';
  String year = '2021';
  String initImgLv = 'assets/images/level.png';
  String initRank = 'assets/images/rank.png';
  int initLv = 1;
  int number = 0;

  var initAttr =
      Attribute(name: 'Light', image: 'assets/images/attribute/Light.png');
  var initType =
      CardType(type: 1, name: 'Normal', image: 'assets/images/card_type/1.gif');
  var initTrapSpellType = TrapSpellType(
      name: 'Continuous',
      image: 'assets/images/trap_spell_type/Continuous.png');

  final cardType = <CardType>[
    CardType(type: 1, name: 'Normal', image: 'assets/images/card_type/1.gif'),
    CardType(type: 2, name: 'Effect', image: 'assets/images/card_type/2.gif'),
    CardType(type: 3, name: 'Fusion', image: 'assets/images/card_type/4.gif'),
    CardType(type: 4, name: 'Ritual', image: 'assets/images/card_type/3.gif'),
    CardType(type: 6, name: 'Synchro', image: 'assets/images/card_type/6.gif'),
    CardType(type: 7, name: 'Token', image: 'assets/images/card_type/7.gif'),
    CardType(type: 8, name: 'XYZ', image: 'assets/images/card_type/8.gif'),
    CardType(type: 9, name: 'Spell', image: 'assets/images/card_type/9.gif'),
    CardType(type: 10, name: 'Trap', image: 'assets/images/card_type/10.gif'),
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
