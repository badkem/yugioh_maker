part of 'page.dart';

class ThreeCardPage extends StatefulWidget {
  final HistoryStorage storage;
  const ThreeCardPage({Key? key, required this.storage}) : super(key: key);

  @override
  _ThreeCardPageState createState() => _ThreeCardPageState();
}

class _ThreeCardPageState extends State<ThreeCardPage> {
  int initLv1 = 1;
  int initLv2 = 1;
  int initLv3 = 1;

  int number_1 = 0;
  int number_2 = 0;
  int number_3 = 0;

  String atk1 = '';
  String atk2 = '';
  String atk3 = '';

  String def1 = '';
  String def2 = '';
  String def3 = '';

  String year1 = '2021';
  String year2 = '2021';
  String year3 = '2021';

  String name1 = 'name1';
  String name2 = 'name2';
  String name3 = 'name3';

  String nameType1 = 'card type 1';
  String nameType2 = 'card type 2';
  String nameType3 = 'card type 3';

  String decs1 = 'card description 1';
  String decs2 = 'card description 2';
  String decs3 = 'card description 3';

  String lv_1 = 'assets/images/level.png';
  String lv_2 = 'assets/images/level.png';
  String lv_3 = 'assets/images/level.png';

  String rank_1 = 'assets/images/rank.png';
  String rank_2 = 'assets/images/rank.png';
  String rank_3 = 'assets/images/rank.png';

  int fileName = DateTime.now().microsecondsSinceEpoch;

  late double height, width;

  bool attrShow_1 = false;
  bool attrShow_2 = false;
  bool attrShow_3 = false;

  bool lvShow_1 = false;
  bool lvShow_2 = false;
  bool lvShow_3 = false;

  bool trapSpellShow_1 = false;
  bool trapSpellShow_2 = false;
  bool trapSpellShow_3 = false;

  var imgLink = '';

  var isDone = false;
  var isUploadDone = false;
  var isVisible = false;

  var initAttr_1 = Attribute(name: 'Light', image: 'assets/images/attribute/Light.png');
  var initAttr_2 = Attribute(name: 'Dark', image: 'assets/images/attribute/Dark.png');
  var initAttr_3 = Attribute(name: 'Divine', image: 'assets/images/attribute/Divine.png');

  var initType_1 = CardType(type: 1, name: 'Normal', image: 'assets/images/card_type/1.gif');
  var initType_2 = CardType(type: 2, name: 'Normal', image: 'assets/images/card_type/2.gif');
  var initType_3 = CardType(type: 3, name: 'Normal', image: 'assets/images/card_type/3.gif');

  var initTrapSpellType_1 =  TrapSpellType(name: 'Equip', image: 'assets/images/trap_spell_type/Equip.png');
  var initTrapSpellType_2 =  TrapSpellType(name: 'Counter', image: 'assets/images/trap_spell_type/Counter.png');
  var initTrapSpellType_3 =  TrapSpellType(name: 'Continuous', image: 'assets/images/trap_spell_type/Continuous.png');

  var imagePath_1 = File('').path;
  var imagePath_2 = File('').path;
  var imagePath_3 = File('').path;

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

  var listImagePath = <File>[];

  Future _getImage(int index) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        if(index == 1) {
          imagePath_1 = File(pickedFile.path).path;
          listImagePath.add(File(pickedFile.path));
        }
        if(index == 2) {
          imagePath_2 = File(pickedFile.path).path;
          listImagePath.add(File(pickedFile.path));
        }
        if(index == 3) {
          imagePath_3 = File(pickedFile.path).path;
          listImagePath.add(File(pickedFile.path));
        }
      } else {
        print('No image selected.');
      }
      if(listImagePath.length >= 3 ) isDone = true;
    });
  }

  void _save() {
    try {
      scController.capture().then((image) async {
        await ImageGallerySaver.saveImage(image!,
            quality: 100, name: '$fileName');
      });
    } catch (e) {
      print(e);
    } finally {
      final snackBar = SnackBar(
        content: Text('Yay! Successfully!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _randomNumber() {
    var rd = Random();
    setState(() {
      number_1 = rd.nextInt(900000) + 100000;
    });
  }

  void _upload() {
    scController.capture().then((image) async {
      var file = FormData.fromMap(
          {
            'image': MultipartFile.fromBytes(image!, filename: '$fileName', contentType: MediaType('image','png'))
          }
      );
      try {
        setState(() {
          isVisible = true;
        });
        final response = await Dio().postUri(Uri.parse('https://api.imgur.com/3/upload'),
            options: Options(
                headers: {
                  'Authorization' : 'Bearer 72222ea47697f34123a1eea53cc5c1a82c2bfd1d',
                  'Content-Type': 'multipart/form-data'
                }
            ),
            data: file
        );
        if(response.statusCode == 200){
          setState(() {
            imgLink = response.data['data']['link'];
            isVisible = false;
            isUploadDone = true;
          });
          print(response.statusMessage);
        }
      } catch (e) {
        print(e);
      }
    });
  }

  _onShare(BuildContext context) async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    if (imgLink.isNotEmpty) {
      await Share.share(imgLink,
          subject: 'Three Card',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      final bool nativeAppLaunchSucceeded = await launch(
        url,
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      if (!nativeAppLaunchSucceeded) {
        await launch(
          url,
          forceSafariVC: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Long tap card to change type'),
              SizedBox(height: height * 0.1,),
              Center(
                child: Screenshot(
                  controller: scController,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 1
                      GestureDetector(
                        onLongPress: () => showType(1),
                        child: SizedBox(
                          height: height * 0.21,
                          child: Stack(
                            children: [
                              //Scaffold
                              Image.asset(initType_1.image),
                              //Image
                              Positioned(
                                left: 16,
                                bottom: 54,
                                child: InkWell(
                                  onTap: () => _getImage(1),
                                  child: SizedBox(
                                    height: 95,
                                    width: 95,
                                    child: imagePath_1.isEmpty
                                        ? Center(child: Text('?'))
                                        : Image.file(
                                      File(imagePath_1),
                                      width: 249,
                                      height: 249,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              //name
                              Positioned(
                                  top: 12,
                                  left: 15,
                                  child: InkWell(
                                    onTap: () => editName(1),
                                    child: Text(
                                      name1.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 8,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              //Level
                              initType_1.type == 8
                                  ? Positioned(
                                top: 26,
                                left: 12,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          lvShow_1 = true;
                                        });
                                      },
                                      child: SizedBox(
                                        height: 8,
                                        child: ListView.builder(
                                            reverse: true,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: initLv1,
                                            itemBuilder: (context, i) =>
                                                Image.asset(rank_1)),
                                      ),
                                    ),
                                    buildListLevel(1),
                                  ],
                                ),
                              )
                                  : initType_1.type == 9
                                  ? Positioned(
                                top: 26,
                                right: 12,
                                child: Stack(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            trapSpellShow_1 = true;
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              '[spell card '.toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Image.asset(initTrapSpellType_1.image, height: 8, width: 8,),
                                            Text(
                                              ']'.toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )),
                                    buildListTrapSpellType(1),
                                  ],
                                ),
                              )
                                  : initType_1.type == 10
                                  ? Positioned(
                                top: 26,
                                right: 12,
                                child: Stack(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            trapSpellShow_1 = true;
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              '[trap card '.toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Image.asset(initTrapSpellType_1.image, height: 8, width: 8,),
                                            Text(
                                              ']'.toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )),
                                    buildListTrapSpellType(1),
                                  ],
                                ),
                              )
                                  : Positioned(
                                top: 26,
                                right: 12,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          lvShow_1 = true;
                                        });
                                      },
                                      child: SizedBox(
                                        height: 8,
                                        child: ListView.builder(
                                            reverse: true,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: initLv1,
                                            itemBuilder: (context, i) =>
                                                Image.asset(lv_1)),
                                      ),
                                    ),
                                    buildListLevel(1),
                                  ],
                                ),
                              ),
                              //Attribute
                              initType_1.type == 9
                                  ? Positioned(
                                  top: 10,
                                  right: 15,
                                  child: Image.asset(
                                    attribute[7].image,
                                    width: 14,
                                    height: 14,
                                  ))
                                  : initType_1.type == 10
                                  ? Positioned(
                                  top: 10,
                                  right: 15,
                                  child: Image.asset(
                                    attribute[8].image,
                                    width: 14,
                                    height: 14,
                                  ))
                                  : Positioned(
                                  top: 10,
                                  right: 15,
                                  child: Stack(
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              attrShow_1 = true;
                                            });
                                          },
                                          child: Image.asset(
                                            initAttr_1.image,
                                            width: 14,
                                            height: 14,
                                          )),
                                      buildListAttr(1),
                                    ],
                                  )),
                              //Name type
                              Positioned(
                                  bottom: 35,
                                  left: 18,
                                  child: InkWell(
                                    onTap: () => editNameType(1),
                                    child: Text(
                                      '[${nameType1.toLowerCase()}]',
                                      style: TextStyle(
                                          fontSize: 7,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              //Card desc
                              Positioned(
                                  bottom: 30,
                                  left: 15,
                                  child: InkWell(
                                    onTap: () => editDecs(1),
                                    child: Text(
                                      decs1,
                                      style: TextStyle(
                                          fontSize: 7,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  )),
                              //Divider
                              Positioned(
                                  bottom: 12,
                                  left: 11,
                                  child: Container(
                                    width: width * 0.25,
                                    child: Divider(
                                      color: Colors.black,
                                    ),
                                  )),
                              //ATK/DEF
                              Positioned(
                                bottom: 10,
                                right: 25,
                                child: InkWell(
                                  onTap: () => editAtkDef(1),
                                  child: Row(
                                    children: [
                                      Text(
                                        'ATK/$atk1'.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 7,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        'DEF/$def1'.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 7,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              //Year
                              Positioned(
                                bottom: 2,
                                right: 12,
                                child: InkWell(
                                  onTap: () => editYear(1),
                                  child: Text(
                                    '@$year1',
                                    style: TextStyle(
                                        fontSize: 7,
                                        color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              //Serial number
                              Positioned(
                                bottom: 2,
                                left: 12,
                                child: InkWell(
                                  onTap: () => _randomNumber(),
                                  child: Text(
                                    '$number_1',
                                    style: TextStyle(
                                        fontSize: 7,
                                        color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // 2
                      GestureDetector(
                        onLongPress: () => showType(2),
                        child: SizedBox(
                          height: height * 0.21,
                          child: Stack(
                            children: [
                              //Scaffold
                              Image.asset(initType_2.image),
                              //Image
                              Positioned(
                                left: 16,
                                bottom: 54,
                                child: InkWell(
                                  onTap: () => _getImage(2),
                                  child: SizedBox(
                                    height: 95,
                                    width: 95,
                                    child: imagePath_2.isEmpty
                                        ? Center(child: Text('?'))
                                        : Image.file(
                                      File(imagePath_2),
                                      width: 249,
                                      height: 249,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              //name
                              Positioned(
                                  top: 12,
                                  left: 15,
                                  child: InkWell(
                                    onTap: () => editName(2),
                                    child: Text(
                                      name2.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 8,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              //Level
                              initType_2.type == 8
                                  ? Positioned(
                                top: 26,
                                left: 12,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          lvShow_2 = true;
                                        });
                                      },
                                      child: SizedBox(
                                        height: 8,
                                        child: ListView.builder(
                                            reverse: true,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: initLv2,
                                            itemBuilder: (context, i) =>
                                                Image.asset(rank_2)),
                                      ),
                                    ),
                                    buildListLevel(2),
                                  ],
                                ),
                              )
                                  : initType_2.type == 9
                                  ? Positioned(
                                top: 26,
                                right: 12,
                                child: Stack(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            trapSpellShow_2 = true;
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              '[spell card '.toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Image.asset(initTrapSpellType_2.image, height: 8, width: 8,),
                                            Text(
                                              ']'.toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )),
                                    buildListTrapSpellType(2),
                                  ],
                                ),
                              )
                                  : initType_2.type == 10
                                  ? Positioned(
                                top: 26,
                                right: 12,
                                child: Stack(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            trapSpellShow_2 = true;
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              '[trap card '.toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Image.asset(initTrapSpellType_2.image, height: 8, width: 8,),
                                            Text(
                                              ']'.toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )),
                                    buildListTrapSpellType(2),
                                  ],
                                ),
                              )
                                  : Positioned(
                                top: 26,
                                right: 12,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          lvShow_2 = true;
                                        });
                                      },
                                      child: SizedBox(
                                        height: 8,
                                        child: ListView.builder(
                                            reverse: true,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: initLv2,
                                            itemBuilder: (context, i) =>
                                                Image.asset(lv_2)),
                                      ),
                                    ),
                                    buildListLevel(2),
                                  ],
                                ),
                              ),
                              //Attribute
                              initType_2.type == 9
                                  ? Positioned(
                                  top: 10,
                                  right: 15,
                                  child: Image.asset(
                                    attribute[7].image,
                                    width: 14,
                                    height: 14,
                                  ))
                                  : initType_2.type == 10
                                  ? Positioned(
                                  top: 10,
                                  right: 15,
                                  child: Image.asset(
                                    attribute[8].image,
                                    width: 14,
                                    height: 14,
                                  ))
                                  : Positioned(
                                  top: 10,
                                  right: 15,
                                  child: Stack(
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              attrShow_2 = true;
                                            });
                                          },
                                          child: Image.asset(
                                            initAttr_2.image,
                                            width: 14,
                                            height: 14,
                                          )),
                                      buildListAttr(2),
                                    ],
                                  )),
                              //Name type
                              Positioned(
                                  bottom: 35,
                                  left: 18,
                                  child: InkWell(
                                    onTap: () => editNameType(2),
                                    child: Text(
                                      '[${nameType2.toLowerCase()}]',
                                      style: TextStyle(
                                          fontSize: 7,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              //Card desc
                              Positioned(
                                  bottom: 30,
                                  left: 15,
                                  child: InkWell(
                                    onTap: () => editDecs(2),
                                    child: Text(
                                      decs2,
                                      style: TextStyle(
                                          fontSize: 7,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  )),
                              //Divider
                              Positioned(
                                  bottom: 12,
                                  left: 11,
                                  child: Container(
                                    width: width * 0.25,
                                    child: Divider(
                                      color: Colors.black,
                                    ),
                                  )),
                              //ATK/DEF
                              Positioned(
                                bottom: 10,
                                right: 25,
                                child: InkWell(
                                  onTap: () => editAtkDef(2),
                                  child: Row(
                                    children: [
                                      Text(
                                        'ATK/$atk2'.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 7,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        'DEF/$def2'.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 7,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              //Year
                              Positioned(
                                bottom: 2,
                                right: 12,
                                child: InkWell(
                                  onTap: () => editYear(2),
                                  child: Text(
                                    '@$year2',
                                    style: TextStyle(
                                        fontSize: 7,
                                        color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              //Serial number
                              Positioned(
                                bottom: 2,
                                left: 12,
                                child: InkWell(
                                  onTap: () => _randomNumber(),
                                  child: Text(
                                    '$number_2',
                                    style: TextStyle(
                                        fontSize: 7,
                                        color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // 3
                      GestureDetector(
                        onLongPress: () => showType(3),
                        child: SizedBox(
                          height: height * 0.21,
                          child: Stack(
                            children: [
                              //Scaffold
                              Image.asset(initType_3.image),
                              //Image
                              Positioned(
                                left: 16,
                                bottom: 54,
                                child: InkWell(
                                  onTap: () => _getImage(3),
                                  child: SizedBox(
                                    height: 95,
                                    width: 95,
                                    child: imagePath_3.isEmpty
                                        ? Center(child: Text('?'))
                                        : Image.file(
                                      File(imagePath_3),
                                      width: 249,
                                      height: 249,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              //name
                              Positioned(
                                  top: 12,
                                  left: 15,
                                  child: InkWell(
                                    onTap: () => editName(3),
                                    child: Text(
                                      name3.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 8,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              //Level
                              initType_3.type == 8
                                  ? Positioned(
                                top: 26,
                                left: 12,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          lvShow_3 = true;
                                        });
                                      },
                                      child: SizedBox(
                                        height: 8,
                                        child: ListView.builder(
                                            reverse: true,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: initLv3,
                                            itemBuilder: (context, i) =>
                                                Image.asset(rank_3)),
                                      ),
                                    ),
                                    buildListLevel(3),
                                  ],
                                ),
                              )
                                  : initType_3.type == 9
                                  ? Positioned(
                                top: 26,
                                right: 12,
                                child: Stack(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            trapSpellShow_3 = true;
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              '[spell card '.toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Image.asset(initTrapSpellType_3.image, height: 8, width: 8,),
                                            Text(
                                              ']'.toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )),
                                    buildListTrapSpellType(3),
                                  ],
                                ),
                              )
                                  : initType_3.type == 10
                                  ? Positioned(
                                top: 26,
                                right: 12,
                                child: Stack(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            trapSpellShow_3 = true;
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              '[trap card '.toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Image.asset(initTrapSpellType_3.image, height: 8, width: 8,),
                                            Text(
                                              ']'.toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )),
                                    buildListTrapSpellType(3),
                                  ],
                                ),
                              )
                                  : Positioned(
                                top: 26,
                                right: 12,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          lvShow_3 = true;
                                        });
                                      },
                                      child: SizedBox(
                                        height: 8,
                                        child: ListView.builder(
                                            reverse: true,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: initLv3,
                                            itemBuilder: (context, i) =>
                                                Image.asset(lv_3)),
                                      ),
                                    ),
                                    buildListLevel(3),
                                  ],
                                ),
                              ),
                              //Attribute
                              initType_3.type == 9
                                  ? Positioned(
                                  top: 10,
                                  right: 15,
                                  child: Image.asset(
                                    attribute[7].image,
                                    width: 14,
                                    height: 14,
                                  ))
                                  : initType_3.type == 10
                                  ? Positioned(
                                  top: 10,
                                  right: 15,
                                  child: Image.asset(
                                    attribute[8].image,
                                    width: 14,
                                    height: 14,
                                  ))
                                  : Positioned(
                                  top: 10,
                                  right: 15,
                                  child: Stack(
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              attrShow_3 = true;
                                            });
                                          },
                                          child: Image.asset(
                                            initAttr_3.image,
                                            width: 14,
                                            height: 14,
                                          )),
                                      buildListAttr(3),
                                    ],
                                  )),
                              //Name type
                              Positioned(
                                  bottom: 35,
                                  left: 18,
                                  child: InkWell(
                                    onTap: () => editNameType(3),
                                    child: Text(
                                      '[${nameType3.toLowerCase()}]',
                                      style: TextStyle(
                                          fontSize: 7,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              //Card desc
                              Positioned(
                                  bottom: 30,
                                  left: 15,
                                  child: InkWell(
                                    onTap: () => editDecs(3),
                                    child: Text(
                                      decs3,
                                      style: TextStyle(
                                          fontSize: 7,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  )),
                              //Divider
                              Positioned(
                                  bottom: 12,
                                  left: 11,
                                  child: Container(
                                    width: width * 0.25,
                                    child: Divider(
                                      color: Colors.black,
                                    ),
                                  )),
                              //ATK/DEF
                              Positioned(
                                bottom: 10,
                                right: 25,
                                child: InkWell(
                                  onTap: () => editAtkDef(3),
                                  child: Row(
                                    children: [
                                      Text(
                                        'ATK/$atk3'.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 7,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        'DEF/$def3'.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 7,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              //Year
                              Positioned(
                                bottom: 2,
                                right: 12,
                                child: InkWell(
                                  onTap: () => editYear(3),
                                  child: Text(
                                    '@$year3',
                                    style: TextStyle(
                                        fontSize: 7,
                                        color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              //Serial number
                              Positioned(
                                bottom: 2,
                                left: 12,
                                child: InkWell(
                                  onTap: () => _randomNumber(),
                                  child: Text(
                                    '$number_3',
                                    style: TextStyle(
                                        fontSize: 7,
                                        color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * 0.1,),
              isDone == false
                  ? SizedBox()
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isUploadDone == false
                      ? TextButton.icon(
                      onPressed: () => _upload(),
                      icon: Icon(Icons.upload_rounded),
                      label: Text('Upload'))
                      : TextButton.icon(
                      onPressed: () => _onShare(context),
                      icon: Icon(Icons.upload_rounded),
                      label: Text('Share')),
                  TextButton.icon(
                      onPressed: () => _save(),
                      icon: Icon(Icons.save_alt),
                      label: Text('Save')),
                ],
              ),
              Visibility(
                visible: isVisible,
                child: CircularProgressIndicator(),
              ),
              Visibility(
                visible: isUploadDone,
                child: TextButton(
                  onPressed: () => _launchUrl(imgLink),
                  child: Text('Watch it!'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showType(int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: cardType.length,
              itemBuilder: (context, i) {
                final item = cardType[i];
                return ListTile(
                  onTap: () {
                    setState(() {
                      index == 1
                      ? initType_1 = item
                      : index == 2
                      ? initType_2 = item
                      : initType_3 = item;
                    });
                  },
                  contentPadding: EdgeInsets.all(8),
                  leading: Text(item.name),
                  trailing: Image.asset(item.image),
                );
              });
        });
  }

  editName(int index) {
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
                    index == 1
                    ? name1 = nameController.text
                    : index == 2
                    ? name2 = nameController.text
                    : name3 = nameController.text;
                  });
                }
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }

  editNameType(int index) {
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
                    index == 1
                    ? nameType1 = nameTypeController.text
                    : index == 2
                    ? nameType2 = nameTypeController.text
                    : nameType3 = nameTypeController.text;
                  });
                }
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }

  editDecs(int index) {
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
                    index == 1
                    ? decs1 = decsController.text
                    : index == 2
                    ? decs2 = decsController.text
                    : decs3 = decsController.text;
                  });
                }
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }

  editAtkDef(int index) {
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
                    index == 1
                    ? atk1 = atkController.text
                    : index == 2
                    ? atk2 = atkController.text
                    : atk3 = atkController.text;
                  });
                }
                if (defController.text.isNotEmpty) {
                  setState(() {
                    index == 1
                    ? def1 = defController.text
                    : index == 2
                    ? def2 = defController.text
                    : def3 = defController.text;
                  });
                }
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }

  editYear(int index) {
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
                    index == 1
                    ? year1 = yearController.text
                    : index == 2
                    ? year2 = yearController.text
                    : year3 = yearController.text;
                  });
                }
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }

  Widget buildListAttr(int index) {
    return Visibility(
        visible: index == 1 ? attrShow_1
                : index == 2 ? attrShow_2
                : attrShow_3,
        child: Container(
          height: 150,
          width: 50,
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
                    index == 1 ? initAttr_1 = item
                    : index == 2 ? initAttr_2 = item
                    : initAttr_3 = item;

                    index == 1 ? attrShow_1 = false
                    : index == 2 ? attrShow_2 = false
                        : attrShow_3 = false;
                  });
                },
                leading: Image.asset(
                  item.image,
                  width: 15,
                  height: 15,
                ),
              );
            },
          ),
        ));
  }

  Widget buildListLevel(int index) {
    return Visibility(
        visible: index == 1
            ? lvShow_1
            : index == 2
            ? lvShow_2
            : lvShow_3,
        child: Container(
          height: 100,
          width: 24,
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
                    index == 1
                    ? initLv1 = item
                    : index == 2
                    ? initLv2 = item
                    : initLv3 = item;

                    index == 1
                    ? lvShow_1 = false
                    : index == 2
                    ? lvShow_2 = false
                    : lvShow_3 = false;
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

  Widget buildListTrapSpellType(int index) {
    return Visibility(
        visible: index == 1
                  ? trapSpellShow_1
                  : index == 2
                  ? trapSpellShow_2
                  : trapSpellShow_3,
        child: Container(
          height: 150,
          width: 50,
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
                    index == 1
                    ? initTrapSpellType_1 = item
                    : index == 2
                    ? initTrapSpellType_2 = item
                    : initTrapSpellType_3 = item;

                    index == 1
                    ? trapSpellShow_1 = false
                    : index == 2
                    ? trapSpellShow_2 = false
                    : trapSpellShow_3 = false;
                  });
                },
                leading: Image.asset(
                  item.image,
                  width: 15,
                  height: 15,
                ),
              );
            },
          ),
        ));
  }
}
