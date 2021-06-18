
part of 'page.dart';

class MakerPage extends StatefulWidget {
  final HistoryStorage storage;
  const MakerPage({Key? key, required this.storage}) : super(key: key);

  @override
  _MakerPageState createState() => _MakerPageState();
}

class _MakerPageState extends State<MakerPage> {
  File? _image;
  String name = 'name';
  String nameType = 'card type';
  String decs = 'card description';
  String atk = '';
  String def = '';
  String year = '2021';
  String initImgLv = 'assets/images/level.png';
  String initRank = 'assets/images/rank.png';
  int fileName = DateTime.now().microsecondsSinceEpoch;
  int initLv = 1;
  int number = 0;

  bool attrShow = false;
  bool lvShow = false;
  bool trapSpellShow = false;

  var initAttr = Attribute(name: 'Light', image: 'assets/images/attribute/Light.png');
  var initType = CardType(type: 1, name: 'Normal', image: 'assets/images/card_type/1.gif');
  var initTrapSpellType =  TrapSpellType(name: 'Continuous', image: 'assets/images/trap_spell_type/Continuous.png');

  final picker = ImagePicker();
  final scController = ScreenshotController();
  final nameController = TextEditingController();
  final nameTypeController = TextEditingController();
  final decsController = TextEditingController();
  final atkController = TextEditingController();
  final defController = TextEditingController();
  final yearController = TextEditingController();

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
    TrapSpellType(name: 'Continuous', image: 'assets/images/trap_spell_type/Continuous.png'),
    TrapSpellType(name: 'Counter', image: 'assets/images/trap_spell_type/Counter.png'),
    TrapSpellType(name: 'Equip', image: 'assets/images/trap_spell_type/Equip.png'),
    TrapSpellType(name: 'Field', image: 'assets/images/trap_spell_type/Field.png'),
    TrapSpellType(name: 'Quick-Play', image: 'assets/images/trap_spell_type/Quick-Play.png'),
    TrapSpellType(name: 'Ritual', image: 'assets/images/trap_spell_type/Ritual.png'),
  ];

  final levels = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void save() {
    try {
      scController.capture().then((image) async {
        await ImageGallerySaver.saveImage(image!,
            quality: 100, name: '$fileName');
      });
    } catch (e) {
      print(e);
    } finally {
      widget.storage.saveHistory(
          History(
              cardType: initType.image,
              type: initType.type,
              attr: initAttr.image,
              level: initLv,
              name: name,
              image: _image != null
                  ? '${_image!.path}'
                  : null,
              trapSpellType: initTrapSpellType.image,
              nameType: nameType,
              desc: decs,
              serialNumber: number,
              year: year,
              atk: atk,
              def: def)
      );
      final snackBar = SnackBar(
        content: Text('Yay! Successfully!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void randomNumber() {
    var rd = Random();
    setState(() {
      number = rd.nextInt(900000) + 100000;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Screenshot(
                controller: scController,
                child: SizedBox(
                  child: Stack(
                    children: [
                      //Scaffold
                      Image.asset(initType.image),
                      //Image
                      Positioned(
                        left: 42,
                        bottom: 141,
                        child: SizedBox(
                          height: 249,
                          width: 249,
                          child: _image == null
                              ? Center(child: Text('No image selected'))
                              : Image.file(
                            _image!,
                            width: 249,
                            height: 249,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      //name
                      Positioned(
                          top: 35,
                          left: 40,
                          child: InkWell(
                            onTap: () => editName(),
                            child: Text(
                              name.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                      //Level
                      initType.type == 8
                      ? Positioned(
                        top: 68,
                        left: 35,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  lvShow = true;
                                });
                              },
                              child: SizedBox(
                                height: 22,
                                child: ListView.builder(
                                    reverse: true,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: initLv,
                                    itemBuilder: (context, i) =>
                                        Image.asset(initRank)),
                              ),
                            ),
                            buildListLevel(),
                          ],
                        ),
                      )
                      : initType.type == 9
                      ? Positioned(
                        top: 68,
                        right: 35,
                        child: Stack(
                          children: [
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    trapSpellShow = true;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      '[spell card '.toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Image.asset(initTrapSpellType.image, height: 22, width: 22,),
                                    Text(
                                      ']'.toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )),
                            buildListTrapSpellType(),
                          ],
                        ),
                      )
                      : initType.type == 10
                      ? Positioned(
                        top: 68,
                        right: 35,
                        child: Stack(
                          children: [
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    trapSpellShow = true;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      '[trap card '.toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Image.asset(initTrapSpellType.image, height: 22, width: 22,),
                                    Text(
                                      ']'.toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )),
                            buildListTrapSpellType(),
                          ],
                        ),
                      )
                      : Positioned(
                        top: 68,
                        right: 35,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  lvShow = true;
                                });
                              },
                              child: SizedBox(
                                height: 22,
                                child: ListView.builder(
                                    reverse: true,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: initLv,
                                    itemBuilder: (context, i) =>
                                        Image.asset(initImgLv)),
                              ),
                            ),
                            buildListLevel(),
                          ],
                        ),
                      ),
                      //Attribute
                      initType.type == 9
                      ? Positioned(
                          top: 25,
                          right: 40,
                          child: Image.asset(
                            attribute[7].image,
                            width: 35,
                            height: 35,
                          ))
                      : initType.type == 10
                      ? Positioned(
                          top: 25,
                          right: 40,
                          child: Image.asset(
                            attribute[8].image,
                            width: 35,
                            height: 35,
                          ))
                      : Positioned(
                          top: 25,
                          right: 40,
                          child: Stack(
                            children: [
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      attrShow = true;
                                    });
                                  },
                                  child: Image.asset(
                                    initAttr.image,
                                    width: 35,
                                    height: 35,
                                  )),
                              buildListAttr(),
                            ],
                          )),
                      //Name type
                      Positioned(
                          bottom: 90,
                          left: 40,
                          child: InkWell(
                            onTap: () => editNameType(),
                            child: Text(
                              '[${nameType.toLowerCase()}]',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                      //Card desc
                      Positioned(
                          bottom: 70,
                          left: 40,
                          child: InkWell(
                            onTap: () => editDecs(),
                            child: Text(
                              decs,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400),
                            ),
                          )),
                      //Divider
                      Positioned(
                          bottom: 40,
                          left: 28,
                          child: Container(
                            width: 276,
                            child: Divider(
                              color: Colors.black,
                            ),
                          )),
                      //ATK/DEF
                      Positioned(
                        bottom: 25,
                        right: 35,
                        child: InkWell(
                          onTap: () => editAtkDef(),
                          child: Row(
                            children: [
                              Text(
                                'ATK/$atk'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'DEF/$def'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                      //Year
                      Positioned(
                        bottom: 6,
                        right: 35,
                        child: InkWell(
                          onTap: () => editYear(),
                          child: Text(
                            '@$year',
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      //Serial number
                      Positioned(
                        bottom: 6,
                        left: 35,
                        child: InkWell(
                          onTap: () => randomNumber(),
                          child: Text(
                            '$number',
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            TextButton.icon(
                onPressed: () => save(),
                icon: Icon(Icons.download_rounded),
                label: Text('Save'))
          ],
        ),
      ),
      floatingActionButton: ExpandableFab(
        distance: 112.0,
        children: [
          ActionButton(
            onPressed: () => showType(),
            icon: const Icon(Icons.screen_lock_landscape),
          ),
          ActionButton(
            onPressed: () => getImage(),
            icon: const Icon(Icons.insert_photo),
          ),
          ActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryPage(storage: widget.storage,)),
              );
            },
            icon: const Icon(Icons.history),
          ),
        ],
      ),

    );
  }

  showType() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: cardType.length,
              itemBuilder: (context, index) {
                final item = cardType[index];
                return ListTile(
                  onTap: () {
                    setState(() {
                      initType = item;
                    });
                  },
                  contentPadding: EdgeInsets.all(8),
                  leading: Text(item.name),
                  trailing: Image.asset(item.image),
                );
              });
        });
  }

  editName() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Input your name"),
              content: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      setState(() {
                        name = nameController.text;
                      });
                    }
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  editNameType() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Input your name"),
              content: TextField(
                controller: nameTypeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    if (nameTypeController.text.isNotEmpty) {
                      setState(() {
                        nameType = nameTypeController.text;
                      });
                    }
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  editDecs() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Input your description"),
              content: TextField(
                controller: decsController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    if (decsController.text.isNotEmpty) {
                      setState(() {
                        decs = decsController.text;
                      });
                    }
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  editAtkDef() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Input your ATK/DEF"),
              content: Container(
                height: 170,
                child: Column(
                  children: [
                    TextField(
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      controller: atkController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'ATK',
                      ),
                    ),
                    TextField(
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      controller: defController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'DEF',
                      ),
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    if (atkController.text.isNotEmpty) {
                      setState(() {
                        atk = atkController.text;
                      });
                    }
                    if (defController.text.isNotEmpty) {
                      setState(() {
                        def = defController.text;
                      });
                    }
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  editYear() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Input your year"),
              content: TextField(
                maxLength: 4,
                keyboardType: TextInputType.number,
                controller: yearController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Year',
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    if (yearController.text.isNotEmpty) {
                      setState(() {
                        year = yearController.text;
                      });
                    }
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  Widget buildListAttr() {
    return Visibility(
        visible: attrShow,
        child: Container(
          height: 250,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: attribute.length,
            itemBuilder: (context, i) {
              final item = attribute[i];
              return ListTile(
                onTap: () {
                  setState(() {
                    initAttr = item;
                    attrShow = false;
                  });
                },
                leading: Image.asset(
                  item.image,
                  width: 35,
                  height: 35,
                ),
                title: Text(item.name),
              );
            },
          ),
        ));
  }

  Widget buildListLevel() {
    return Visibility(
        visible: lvShow,
        child: Container(
          height: 250,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: levels.length,
            itemBuilder: (context, i) {
              final item = levels[i];
              return InkWell(
                onTap: () {
                  setState(() {
                    initLv = item;
                    lvShow = false;
                  });
                },
                child: Text(
                  '$item',
                  style: TextStyle(fontSize: 20),
                ),
              );
            },
          ),
        ));
  }

  Widget buildListTrapSpellType() {
    return Visibility(
        visible: trapSpellShow,
        child: Container(
          height: 250,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: trapSpellType.length,
            itemBuilder: (context, i) {
              final item = trapSpellType[i];
              return ListTile(
                onTap: () {
                  setState(() {
                    initTrapSpellType = item;
                    trapSpellShow = false;
                  });
                },
                leading: Image.asset(
                  item.image,
                  width: 35,
                  height: 35,
                ),
                title: Text(item.name),
              );
            },
          ),
        ));
  }

}
