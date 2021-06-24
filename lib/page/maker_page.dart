part of 'page.dart';

enum wtf {name, desc, cardType, atk, def, year}

class MakerPage extends StatefulWidget {
  final HistoryStorage storage;
  const MakerPage({Key? key, required this.storage}) : super(key: key);

  @override
  _MakerPageState createState() => _MakerPageState();
}

class _MakerPageState extends State<MakerPage> {
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
  var imagePath = File('').path;

  final picker = ImagePicker();
  final screenController = ScreenshotController();
  final txtController = TextEditingController();

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

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        imagePath = File(pickedFile.path).path;
      } else {
        print('No image selected.');
      }
    });
  }

  void _save() {
    try {
      screenController.capture().then((image) async {
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
              image: imagePath.isNotEmpty
                  ? imagePath
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

  void _randomNumber() {
    var rd = Random();
    setState(() {
      number = rd.nextInt(900000) + 100000;
    });
  }

  _navigateAndDisplayHistorySelection() async {
    final result = await Navigator.push(context,
      MaterialPageRoute(builder: (context) => HistoryPage(storage: widget.storage)),
    );
    if(result != null) {
      var json = jsonDecode(jsonEncode(result));
      History history = History.fromJson(json);
      setState(() {
        name = history.name;
        imagePath = history.image!;
        decs = history.desc;
        atk = history.atk;
        def = history.def;
        year = history.year;
        initLv = history.level;
        number = history.serialNumber;
        initAttr.image = history.attr;
        initType.type = history.type;
        initType.image = history.cardType;
        initTrapSpellType.image = history.trapSpellType!;
      });
    }
  }

  void _toPreview() {
    screenController.capture().then((image) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => PreviewPage(image: image!)
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton.icon(
            onPressed: () => _navigateAndDisplayHistorySelection(),
            icon: Icon(Icons.history),
            label: Text('')),
        elevation: 0.5,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: TextButton.icon(
            onPressed: () => imagePath.isNotEmpty ? _save() : {},
            icon: Icon(Icons.save_alt, color: imagePath.isNotEmpty ? Colors.blue : Colors.grey,),
            label: Text('')),
        actions: [
          TextButton(
            onPressed: () => imagePath.isNotEmpty ? _toPreview() : {},
            child: Text('Next' ,
              style: TextStyle(color: imagePath.isNotEmpty ? Colors.blue : Colors.grey),),
      )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Screenshot(
                controller: screenController,
                child: SizedBox(
                  child: Stack(
                    children: [
                      //Scaffold
                      Image.asset(initType.image),
                      //Image
                      Positioned(
                        left: 42,
                        bottom: 141,
                        child: InkWell(
                          onTap: () => _getImage(),
                          child: SizedBox(
                            height: 249,
                            width: 249,
                            child: imagePath.isEmpty
                                ? Center(child: Text('Tap here to select image'))
                                : Image.file(
                              File(imagePath),
                              width: 249,
                              height: 249,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      //name
                      Positioned(
                          top: 35,
                          left: 40,
                          child: InkWell(
                            onTap: () => editInput(wtf.name),
                            child: Text(
                              name.toUpperCase(),
                              style: TextStyle(
                                  color: initType.type == 8 ? Colors.white70 : Colors.black54,
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
                            onTap: () => editInput(wtf.cardType),
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
                            onTap: () => editInput(wtf.desc),
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
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () => editInput(wtf.atk),
                              child: Text(
                                'ATK/$atk'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () => editInput(wtf.def),
                              child: Text(
                                'DEF/$def'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                      //Year
                      Positioned(
                        bottom: 6,
                        right: 35,
                        child: InkWell(
                          onTap: () => editInput(wtf.year),
                          child: Text(
                            '@$year',
                            style: TextStyle(
                                color: initType.type == 8
                                    ? Colors.white70 : Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      //Serial number
                      Positioned(
                        bottom: 6,
                        left: 35,
                        child: InkWell(
                          onTap: () => _randomNumber(),
                          child: Text(
                            '$number',
                            style: TextStyle(
                                color: initType.type == 8
                                    ? Colors.white70 : Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black12
              ),
              height: 110,
              width: double.infinity,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  itemCount: cardType.length,
                  itemBuilder: (context, index) {
                    final item = cardType[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            initType = item;
                          });
                        },
                        child: Column(
                          children: [
                            Image.asset(item.image, width: 50),
                            Text(item.name),
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  editInput(wtf type) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Your Input"),
          content: TextField(
            controller: txtController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Input',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                switch(type) {
                  case wtf.name:
                    setState(() {
                      name = txtController.text;
                    });
                    break;
                  case wtf.cardType:
                    setState(() {
                      nameType = txtController.text;
                    });
                    break;
                  case wtf.desc:
                    setState(() {
                      decs = txtController.text;
                    });
                    break;
                  case wtf.atk:
                    setState(() {
                      atk = txtController.text;
                    });
                    break;
                  case wtf.def:
                    setState(() {
                      def = txtController.text;
                    });
                    break;
                  case wtf.year:
                    setState(() {
                      year = txtController.text;
                    });
                    break;
                }
                txtController.clear();
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
