part of 'page.dart';

enum wtf { name, desc, cardType, atk, def, year, degree }

class MakerPage extends StatefulWidget {
  final List<YugiohCard> cards;
  final int mode;

  const MakerPage({Key? key, required this.mode, required this.cards})
      : super(key: key);

  @override
  _MakerPageState createState() => _MakerPageState();
}

class _MakerPageState extends State<MakerPage> {
  late double height, width;
  String degree = '0';
  int fileName = DateTime.now().millisecondsSinceEpoch;

  bool attrShow = false;
  bool lvShow = false;
  bool trapSpellShow = false;
  bool isLargerScreen = false;

  var imagePath = File('').path;
  var image1Path = File('').path;
  var image2Path = File('').path;

  final picker = ImagePicker();
  final screenController = ScreenshotController();
  final txtController = TextEditingController();
  final _makerStorage = MakerStorage();
  final _historyStorage = HistoryStorage();

  Future _getImage(int index) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        switch (index) {
          case 0:
            imagePath = File(pickedFile.path).path;
            break;
          case 1:
            image1Path = File(pickedFile.path).path;
            break;
          case 2:
            image2Path = File(pickedFile.path).path;
            break;
        }
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
      _historyStorage.saveHistory(History(
          cardType: _makerStorage.initType.image,
          type: _makerStorage.initType.type,
          attr: _makerStorage.initAttr.image,
          level: _makerStorage.initLv,
          name: _makerStorage.name,
          image: imagePath.isNotEmpty ? imagePath : null,
          trapSpellType: _makerStorage.initTrapSpellType.image,
          nameType: _makerStorage.nameType,
          desc: _makerStorage.decs,
          serialNumber: _makerStorage.number,
          year: _makerStorage.year,
          atk: _makerStorage.atk,
          def: _makerStorage.def));
      final snackBar = SnackBar(
        content: Text('Yay! Successfully!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _randomNumber() {
    var rd = Random();
    setState(() {
      _makerStorage.number = rd.nextInt(900000) + 100000;
    });
  }

  _navigateAndDisplayHistorySelection() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HistoryPage(storage: _historyStorage)),
    );
    if (result != null) {
      var json = jsonDecode(jsonEncode(result));
      History history = History.fromJson(json);
      setState(() {
        _makerStorage.name = history.name;
        imagePath = history.image!;
        _makerStorage.decs = history.desc;
        _makerStorage.atk = history.atk;
        _makerStorage.def = history.def;
        _makerStorage.year = history.year;
        _makerStorage.initLv = history.level;
        _makerStorage.number = history.serialNumber;
        _makerStorage.initAttr.image = history.attr;
        _makerStorage.initType.type = history.type;
        _makerStorage.initType.image = history.cardType;
        _makerStorage.initTrapSpellType.image = history.trapSpellType!;
      });
    }
  }

  void _toPreview() {
    screenController.capture().then((image) async {
      widget.cards.add(YugiohCard(image!, int.parse(degree)));
      final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PreviewPage(
                    mode: widget.mode,
                    cards: widget.cards,
                  )));
      if (result == true) widget.cards.clear();
    });
  }

  void _toNextPage() {
    screenController.capture().then((image) {
      widget.cards.add(YugiohCard(image!, int.parse(degree)));
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MakerPage(
                    mode: widget.mode,
                    cards: widget.cards,
                  )));
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.5,
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton.icon(
                  onPressed: () {
                    if(imagePath.isNotEmpty) {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Back!"),
                          content: Text("Your current card will be lost!"),
                          actions: [
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: Text('Ok'),
                              onPressed: () {
                                if(widget.cards.isNotEmpty) {
                                  widget.cards.removeLast();
                                }
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      );
                    } else {
                      if(widget.cards.isNotEmpty) {
                        widget.cards.removeLast();
                      }
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(Icons.arrow_back),
                  label: Text('')),
              TextButton.icon(
                  onPressed: () => _navigateAndDisplayHistorySelection(),
                  icon: Icon(Icons.history),
                  label: Text('')),
            ],
          ),
          actions: [
            TextButton.icon(
                onPressed: () => imagePath.isNotEmpty ? _save() : {},
                icon: Icon(
                  Icons.save_alt,
                  color: imagePath.isNotEmpty ? Colors.blue : Colors.grey,
                ),
                label: Text('')),
            imagePath.isNotEmpty
                ? TextButton(
              onPressed: () {
                if (widget.mode == 0) {
                  widget.cards.clear();
                  _toPreview();
                }

                if (widget.mode == 1) {
                  if (widget.cards.length < 4) {
                    _toNextPage();
                  } else {
                    _toPreview();
                  }
                }

                if (widget.mode == 2) {
                  widget.cards.clear();
                  _toPreview();
                }

                if (widget.mode == 3) {
                  if (widget.cards.length < 2) {
                    _toNextPage();
                  } else {
                    _toPreview();
                  }
                }

                if (widget.mode == 4) {
                  if (widget.cards.length < 2) {
                    _toNextPage();
                  } else {
                    _toPreview();
                  }
                }
              },
              child: Text(
                'Next',
                style: TextStyle(color: Colors.blue),
              ),
            )
                : TextButton(
              onPressed: () {},
              child: Text(
                'Next',
                style: TextStyle(color: Colors.grey),
              ),
            )
          ],
        ),
        body: OrientationBuilder(
          builder: (ctx, orientation) {
            if (width > 400) {
              isLargerScreen = true;
            } else {
              isLargerScreen = false;
            }
            return isLargerScreen ? _buildMediumLayout() : _buildSmallLayout();
          },
        ),
        bottomSheet: widget.mode == 1
            ? SizedBox()
            : widget.mode == 2
            ? SizedBox()
            : widget.mode == 3
            ? Container(
          decoration: BoxDecoration(color: Colors.black12),
          height: isLargerScreen ? height * 0.150 : height * 0.140,
          width: double.infinity,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 5),
              itemCount: _makerStorage.cardType.length,
              itemBuilder: (context, index) {
                final item = _makerStorage.cardType[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _makerStorage.initType = item;
                      });
                    },
                    child: Column(
                      children: [
                        Image.asset(item.image,
                            width: isLargerScreen ? 50 : 35),
                        Text(
                          item.name,
                          style: TextStyle(
                              fontSize: isLargerScreen ? 18 : 14),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        )
            : Container(
          decoration: BoxDecoration(color: Colors.black12),
          height: isLargerScreen ? height * 0.150 : height * 0.140,
          width: double.infinity,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 5),
              itemCount: _makerStorage.cardType.length,
              itemBuilder: (context, index) {
                final item = _makerStorage.cardType[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _makerStorage.initType = item;
                      });
                    },
                    child: Column(
                      children: [
                        Image.asset(item.image,
                            width: isLargerScreen ? 50 : 35),
                        Text(
                          item.name,
                          style: TextStyle(
                              fontSize: isLargerScreen ? 18 : 14),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }

  editInput(wtf type) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: type == wtf.name
                  ? Text("Name")
                  : type == wtf.cardType
                      ? Text("Name type")
                      : type == wtf.desc
                          ? Text("Description")
                          : type == wtf.atk
                              ? Text("ATK")
                              : type == wtf.def
                                  ? Text("Def")
                                  : type == wtf.year
                                      ? Text("Year")
                                      : type == wtf.degree
                                          ? Text('Degree')
                                          : Text(''),
              content: TextField(
                keyboardType: type == wtf.degree
                    ? TextInputType.numberWithOptions(decimal: true)
                    : type == wtf.year
                        ? TextInputType.number
                        : type == wtf.atk
                            ? TextInputType.number
                            : type == wtf.def
                                ? TextInputType.number
                                : TextInputType.text,
                maxLength: type == wtf.name ? 20 : 4,
                inputFormatters: type == wtf.degree
                    ? <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp('[0-9-,]+'))
                      ]
                    : <TextInputFormatter>[],
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
                    if (txtController.text.isNotEmpty) {
                      switch (type) {
                        case wtf.degree:
                          setState(() {
                            degree = txtController.text;
                          });
                          break;
                        case wtf.name:
                          setState(() {
                            _makerStorage.name = txtController.text;
                          });
                          break;
                        case wtf.cardType:
                          setState(() {
                            _makerStorage.nameType = txtController.text;
                          });
                          break;
                        case wtf.desc:
                          setState(() {
                            _makerStorage.decs = txtController.text;
                          });
                          break;
                        case wtf.atk:
                          setState(() {
                            _makerStorage.atk = txtController.text;
                          });
                          break;
                        case wtf.def:
                          setState(() {
                            _makerStorage.def = txtController.text;
                          });
                          break;
                        case wtf.year:
                          setState(() {
                            _makerStorage.year = txtController.text;
                          });
                          break;
                      }
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
            itemCount: _makerStorage.attribute.length,
            itemBuilder: (context, i) {
              final item = _makerStorage.attribute[i];
              return ListTile(
                onTap: () {
                  setState(() {
                    _makerStorage.initAttr = item;
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
          height: isLargerScreen ? 250 : 200,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _makerStorage.levels.length,
            itemBuilder: (context, i) {
              final item = _makerStorage.levels[i];
              return Center(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _makerStorage.initLv = item;
                      lvShow = false;
                    });
                  },
                  child: Text(
                    '$item',
                    style: TextStyle(fontSize: 20),
                  ),
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
            itemCount: _makerStorage.trapSpellType.length,
            itemBuilder: (context, i) {
              final item = _makerStorage.trapSpellType[i];
              return ListTile(
                onTap: () {
                  setState(() {
                    _makerStorage.initTrapSpellType = item;
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

  _buildMediumLayout() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.mode == 1
              ? Text(
                  '${widget.cards.length + 1}/5',
                  style: TextStyle(color: Colors.black54, fontSize: 20),
                )
              : widget.mode == 2
                  ? SizedBox()
                  : widget.mode == 3
                      ? Text(
                          '${widget.cards.length + 1}/3',
                          style: TextStyle(color: Colors.black54, fontSize: 20),
                        )
                      : widget.mode == 4
                          ? Text(
                              '${widget.cards.length + 1}/3',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 20),
                            )
                          : SizedBox(),
          SizedBox(
            height: height * 0.025,
          ),
          widget.mode == 1
              ? Center(
                  child: Screenshot(
                    controller: screenController,
                    child: SizedBox(
                      child: Stack(
                        children: [
                          //Scaffold
                          widget.cards.length == 1
                              ? Image.asset(_makerStorage.cardType[1].image)
                              : Image.asset(_makerStorage.cardType[0].image),
                          //Image
                          Positioned(
                            left: 42,
                            bottom: 141,
                            child: InkWell(
                              onTap: () => _getImage(0),
                              child: SizedBox(
                                height: 249,
                                width: 249,
                                child: imagePath.isEmpty
                                    ? Center(
                                        child: Text('Tap here to select image'))
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
                                  _makerStorage.name.toUpperCase(),
                                  style: TextStyle(
                                      color: _makerStorage.initType.type == 8
                                          ? Colors.white70
                                          : Colors.black54,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          //Level
                          Positioned(
                            top: 68,
                            right: 35,
                            child: SizedBox(
                              height: 22,
                              child: widget.cards.length == 1
                                  ? ListView.builder(
                                      reverse: true,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 3,
                                      itemBuilder: (context, i) =>
                                          Image.asset(_makerStorage.initImgLv))
                                  : Image.asset(_makerStorage.initImgLv),
                            ),
                          ),
                          //Attribute
                          Positioned(
                              top: 25,
                              right: 40,
                              child: Image.asset(
                                _makerStorage.attribute[1].image,
                                height: 35,
                              )),
                          //Name type
                          Positioned(
                              bottom: 90,
                              left: 40,
                              child: InkWell(
                                onTap: () => editInput(wtf.cardType),
                                child: Text(
                                  '[${_makerStorage.nameType.toLowerCase()}]',
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
                                  _makerStorage.decs,
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
                                width: width * 0.8,
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
                                    'ATK/${_makerStorage.atk}'.toUpperCase(),
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
                                    'DEF/${_makerStorage.def}'.toUpperCase(),
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
                                '@${_makerStorage.year}',
                                style: TextStyle(
                                    color: _makerStorage.initType.type == 8
                                        ? Colors.white70
                                        : Colors.black,
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
                                '${_makerStorage.number}',
                                style: TextStyle(
                                    color: _makerStorage.initType.type == 8
                                        ? Colors.white70
                                        : Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : widget.mode == 2
                  ? Center(
                      child: Screenshot(
                        controller: screenController,
                        child: Container(
                          color: Colors.white38,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () => _getImage(0),
                                    child: Container(
                                      height: height * 0.18,
                                      width: width * 0.35,
                                      color: Colors.grey.withOpacity(0.2),
                                      child: imagePath.isEmpty
                                          ? Center(child: Text('?'))
                                          : Image.file(
                                              File(imagePath),
                                              width: width * 0.25,
                                              height: height * 0.25,
                                              fit: BoxFit.fill,
                                            ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => _getImage(1),
                                    child: Container(
                                      height: height * 0.18,
                                      width: width * 0.35,
                                      color: Colors.grey.withOpacity(0.2),
                                      child: image1Path.isEmpty
                                          ? Center(child: Text('?'))
                                          : Image.file(
                                              File(image1Path),
                                              width: width * 0.25,
                                              height: height * 0.25,
                                              fit: BoxFit.fill,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                child: Icon(Icons.arrow_downward),
                                height: height * 0.025,
                              ),
                              Image.asset('assets/images/fusion.png',
                                  height: height * 0.15),
                              SizedBox(
                                child: Icon(Icons.arrow_downward),
                                height: height * 0.025,
                              ),
                              InkWell(
                                onTap: () => _getImage(2),
                                child: Container(
                                  height: height * 0.25,
                                  width: width * 0.50,
                                  color: Colors.grey.withOpacity(0.2),
                                  child: image2Path.isEmpty
                                      ? Center(child: Text('?'))
                                      : Image.file(
                                          File(image2Path),
                                          width: width * 0.25,
                                          height: height * 0.25,
                                          fit: BoxFit.fill,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : widget.mode == 3
                      ? Center(
                          child: Screenshot(
                            controller: screenController,
                            child: SizedBox(
                              child: Stack(
                                children: [
                                  //Scaffold
                                  Image.asset(_makerStorage.initType.image),
                                  //Image
                                  Positioned(
                                    left: 42,
                                    bottom: 141,
                                    child: InkWell(
                                      onTap: () => _getImage(0),
                                      child: SizedBox(
                                        height: 249,
                                        width: 249,
                                        child: imagePath.isEmpty
                                            ? Center(
                                                child: Text(
                                                    'Tap here to select image'))
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
                                          _makerStorage.name.toUpperCase(),
                                          style: TextStyle(
                                              color:
                                                  _makerStorage.initType.type ==
                                                          8
                                                      ? Colors.white70
                                                      : Colors.black54,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                  //Level
                                  _makerStorage.initType.type == 8
                                      ? Positioned(
                                          top: 68,
                                          left: 35,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          _makerStorage.initLv,
                                                      itemBuilder: (context,
                                                              i) =>
                                                          Image.asset(
                                                              _makerStorage
                                                                  .initRank)),
                                                ),
                                              ),
                                              buildListLevel(),
                                            ],
                                          ),
                                        )
                                      : _makerStorage.initType.type == 9
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
                                                            '[spell card '
                                                                .toUpperCase(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Image.asset(
                                                              _makerStorage
                                                                  .initTrapSpellType
                                                                  .image,
                                                              height: 22),
                                                          Text(
                                                            ']'.toUpperCase(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      )),
                                                  buildListTrapSpellType(),
                                                ],
                                              ),
                                            )
                                          : _makerStorage.initType.type == 10
                                              ? Positioned(
                                                  top: 68,
                                                  right: 35,
                                                  child: Stack(
                                                    children: [
                                                      InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              trapSpellShow =
                                                                  true;
                                                            });
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                '[trap card '
                                                                    .toUpperCase(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Image.asset(
                                                                  _makerStorage
                                                                      .initTrapSpellType
                                                                      .image,
                                                                  height: 22),
                                                              Text(
                                                                ']'.toUpperCase(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
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
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
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
                                                              scrollDirection:
                                                                  Axis
                                                                      .horizontal,
                                                              itemCount:
                                                                  _makerStorage
                                                                      .initLv,
                                                              itemBuilder: (context,
                                                                      i) =>
                                                                  Image.asset(
                                                                      _makerStorage
                                                                          .initImgLv)),
                                                        ),
                                                      ),
                                                      buildListLevel(),
                                                    ],
                                                  ),
                                                ),
                                  //Attribute
                                  _makerStorage.initType.type == 9
                                      ? Positioned(
                                          top: 25,
                                          right: 40,
                                          child: Image.asset(
                                            _makerStorage.attribute[7].image,
                                            height: 35,
                                          ))
                                      : _makerStorage.initType.type == 10
                                          ? Positioned(
                                              top: 25,
                                              right: 40,
                                              child: Image.asset(
                                                _makerStorage
                                                    .attribute[8].image,
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
                                                        _makerStorage
                                                            .initAttr.image,
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
                                          '[${_makerStorage.nameType.toLowerCase()}]',
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
                                          _makerStorage.decs,
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
                                        width: width * 0.8,
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
                                            'ATK/${_makerStorage.atk}'
                                                .toUpperCase(),
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
                                            'DEF/${_makerStorage.def}'
                                                .toUpperCase(),
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
                                        '@${_makerStorage.year}',
                                        style: TextStyle(
                                            color:
                                                _makerStorage.initType.type == 8
                                                    ? Colors.white70
                                                    : Colors.black,
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
                                        '${_makerStorage.number}',
                                        style: TextStyle(
                                            color:
                                                _makerStorage.initType.type == 8
                                                    ? Colors.white70
                                                    : Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : widget.mode == 4
                          ? Center(
                              child: Screenshot(
                                controller: screenController,
                                child: SizedBox(
                                  child: Stack(
                                    children: [
                                      //Scaffold
                                      Image.asset(_makerStorage.initType.image),
                                      //Image
                                      Positioned(
                                        left: 42,
                                        bottom: 141,
                                        child: InkWell(
                                          onTap: () => _getImage(0),
                                          child: SizedBox(
                                            height: 249,
                                            width: 249,
                                            child: imagePath.isEmpty
                                                ? Center(
                                                    child: Text(
                                                        'Tap here to select image'))
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
                                              _makerStorage.name.toUpperCase(),
                                              style: TextStyle(
                                                  color: _makerStorage
                                                              .initType.type ==
                                                          8
                                                      ? Colors.white70
                                                      : Colors.black54,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                      //Level
                                      _makerStorage.initType.type == 8
                                          ? Positioned(
                                              top: 68,
                                              left: 35,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
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
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemCount:
                                                              _makerStorage
                                                                  .initLv,
                                                          itemBuilder: (context,
                                                                  i) =>
                                                              Image.asset(
                                                                  _makerStorage
                                                                      .initRank)),
                                                    ),
                                                  ),
                                                  buildListLevel(),
                                                ],
                                              ),
                                            )
                                          : _makerStorage.initType.type == 9
                                              ? Positioned(
                                                  top: 68,
                                                  right: 35,
                                                  child: Stack(
                                                    children: [
                                                      InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              trapSpellShow =
                                                                  true;
                                                            });
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                '[spell card '
                                                                    .toUpperCase(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Image.asset(
                                                                  _makerStorage
                                                                      .initTrapSpellType
                                                                      .image,
                                                                  height: 22),
                                                              Text(
                                                                ']'.toUpperCase(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          )),
                                                      buildListTrapSpellType(),
                                                    ],
                                                  ),
                                                )
                                              : _makerStorage.initType.type ==
                                                      10
                                                  ? Positioned(
                                                      top: 68,
                                                      right: 35,
                                                      child: Stack(
                                                        children: [
                                                          InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  trapSpellShow =
                                                                      true;
                                                                });
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    '[trap card '
                                                                        .toUpperCase(),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black54,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Image.asset(
                                                                      _makerStorage
                                                                          .initTrapSpellType
                                                                          .image,
                                                                      height:
                                                                          22),
                                                                  Text(
                                                                    ']'.toUpperCase(),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black54,
                                                                        fontWeight:
                                                                            FontWeight.bold),
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
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
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
                                                                  shrinkWrap:
                                                                      true,
                                                                  scrollDirection: Axis
                                                                      .horizontal,
                                                                  itemCount:
                                                                      _makerStorage
                                                                          .initLv,
                                                                  itemBuilder: (context,
                                                                          i) =>
                                                                      Image.asset(
                                                                          _makerStorage
                                                                              .initImgLv)),
                                                            ),
                                                          ),
                                                          buildListLevel(),
                                                        ],
                                                      ),
                                                    ),
                                      //Attribute
                                      _makerStorage.initType.type == 9
                                          ? Positioned(
                                              top: 25,
                                              right: 40,
                                              child: Image.asset(
                                                _makerStorage
                                                    .attribute[7].image,
                                                height: 35,
                                              ))
                                          : _makerStorage.initType.type == 10
                                              ? Positioned(
                                                  top: 25,
                                                  right: 40,
                                                  child: Image.asset(
                                                    _makerStorage
                                                        .attribute[8].image,
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
                                                            _makerStorage
                                                                .initAttr.image,
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
                                            onTap: () =>
                                                editInput(wtf.cardType),
                                            child: Text(
                                              '[${_makerStorage.nameType.toLowerCase()}]',
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
                                              _makerStorage.decs,
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
                                            width: width * 0.8,
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
                                                'ATK/${_makerStorage.atk}'
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            InkWell(
                                              onTap: () => editInput(wtf.def),
                                              child: Text(
                                                'DEF/${_makerStorage.def}'
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                            '@${_makerStorage.year}',
                                            style: TextStyle(
                                                color: _makerStorage
                                                            .initType.type ==
                                                        8
                                                    ? Colors.white70
                                                    : Colors.black,
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
                                            '${_makerStorage.number}',
                                            style: TextStyle(
                                                color: _makerStorage
                                                            .initType.type ==
                                                        8
                                                    ? Colors.white70
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Screenshot(
                                controller: screenController,
                                child: SizedBox(
                                  child: Stack(
                                    children: [
                                      //Scaffold
                                      Image.asset(_makerStorage.initType.image),
                                      //Image
                                      Positioned(
                                        left: 42,
                                        bottom: 141,
                                        child: InkWell(
                                          onTap: () => _getImage(0),
                                          child: SizedBox(
                                            height: 249,
                                            width: 249,
                                            child: imagePath.isEmpty
                                                ? Center(
                                                    child: Text(
                                                        'Tap here to select image'))
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
                                              _makerStorage.name.toUpperCase(),
                                              style: TextStyle(
                                                  color: _makerStorage
                                                              .initType.type ==
                                                          8
                                                      ? Colors.white70
                                                      : Colors.black54,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                      //Level
                                      _makerStorage.initType.type == 8
                                          ? Positioned(
                                              top: 68,
                                              left: 35,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
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
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemCount:
                                                              _makerStorage
                                                                  .initLv,
                                                          itemBuilder: (context,
                                                                  i) =>
                                                              Image.asset(
                                                                  _makerStorage
                                                                      .initRank)),
                                                    ),
                                                  ),
                                                  buildListLevel(),
                                                ],
                                              ),
                                            )
                                          : _makerStorage.initType.type == 9
                                              ? Positioned(
                                                  top: 68,
                                                  right: 35,
                                                  child: Stack(
                                                    children: [
                                                      InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              trapSpellShow =
                                                                  true;
                                                            });
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                '[spell card '
                                                                    .toUpperCase(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Image.asset(
                                                                  _makerStorage
                                                                      .initTrapSpellType
                                                                      .image,
                                                                  height: 22),
                                                              Text(
                                                                ']'.toUpperCase(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          )),
                                                      buildListTrapSpellType(),
                                                    ],
                                                  ),
                                                )
                                              : _makerStorage.initType.type ==
                                                      10
                                                  ? Positioned(
                                                      top: 68,
                                                      right: 35,
                                                      child: Stack(
                                                        children: [
                                                          InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  trapSpellShow =
                                                                      true;
                                                                });
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    '[trap card '
                                                                        .toUpperCase(),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black54,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Image.asset(
                                                                      _makerStorage
                                                                          .initTrapSpellType
                                                                          .image,
                                                                      height:
                                                                          22),
                                                                  Text(
                                                                    ']'.toUpperCase(),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black54,
                                                                        fontWeight:
                                                                            FontWeight.bold),
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
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
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
                                                                  shrinkWrap:
                                                                      true,
                                                                  scrollDirection: Axis
                                                                      .horizontal,
                                                                  itemCount:
                                                                      _makerStorage
                                                                          .initLv,
                                                                  itemBuilder: (context,
                                                                          i) =>
                                                                      Image.asset(
                                                                          _makerStorage
                                                                              .initImgLv)),
                                                            ),
                                                          ),
                                                          buildListLevel(),
                                                        ],
                                                      ),
                                                    ),
                                      //Attribute
                                      _makerStorage.initType.type == 9
                                          ? Positioned(
                                              top: 25,
                                              right: 40,
                                              child: Image.asset(
                                                _makerStorage
                                                    .attribute[7].image,
                                                height: 35,
                                              ))
                                          : _makerStorage.initType.type == 10
                                              ? Positioned(
                                                  top: 25,
                                                  right: 40,
                                                  child: Image.asset(
                                                    _makerStorage
                                                        .attribute[8].image,
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
                                                            _makerStorage
                                                                .initAttr.image,
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
                                            onTap: () =>
                                                editInput(wtf.cardType),
                                            child: Text(
                                              '[${_makerStorage.nameType.toLowerCase()}]',
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
                                              _makerStorage.decs,
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
                                            width: width * 0.8,
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
                                                'ATK/${_makerStorage.atk}'
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            InkWell(
                                              onTap: () => editInput(wtf.def),
                                              child: Text(
                                                'DEF/${_makerStorage.def}'
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                            '@${_makerStorage.year}',
                                            style: TextStyle(
                                                color: _makerStorage
                                                            .initType.type ==
                                                        8
                                                    ? Colors.white70
                                                    : Colors.black,
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
                                            '${_makerStorage.number}',
                                            style: TextStyle(
                                                color: _makerStorage
                                                            .initType.type ==
                                                        8
                                                    ? Colors.white70
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
          widget.mode == 4
              ? Column(
                  children: [
                    SizedBox(
                      height: height * 0.0300,
                      child: Text(
                        'Your input degree here',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.125,
                      child: InkWell(
                        onTap: () => editInput(wtf.degree),
                        child: Text(
                          '$degree °',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                )
              : SizedBox(
                  height: height * 0.1,
                )
        ],
      ),
    );
  }

  _buildSmallLayout() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          widget.mode == 1
              ? Text(
                  '${widget.cards.length + 1}/5',
                  style: TextStyle(color: Colors.black54, fontSize: 20),
                )
              : widget.mode == 2
                  ? SizedBox()
                  : widget.mode == 3
                      ? Text(
                          '${widget.cards.length + 1}/3',
                          style: TextStyle(color: Colors.black54, fontSize: 20),
                        )
                      : widget.mode == 4
                          ? Text(
                              '${widget.cards.length + 1}/3',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 20),
                            )
                          : SizedBox(),
          SizedBox(
            height: height * 0.025,
          ),
          widget.mode == 1
              ? Center(
                  child: Screenshot(
                    controller: screenController,
                    child: SizedBox(
                      height: height * 0.60,
                      child: Stack(
                        children: [
                          //Scaffold
                          widget.cards.length == 1
                              ? Image.asset(_makerStorage.cardType[1].image)
                              : Image.asset(_makerStorage.cardType[0].image),
                          //Image
                          Positioned(
                            left: 32,
                            bottom: 110,
                            child: InkWell(
                              onTap: () => _getImage(0),
                              child: SizedBox(
                                height: 195,
                                width: 195,
                                child: imagePath.isEmpty
                                    ? Center(
                                        child: Text('Tap here to select image'))
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
                              top: 25,
                              left: 35,
                              child: InkWell(
                                onTap: () => editInput(wtf.name),
                                child: Text(
                                  _makerStorage.name.toUpperCase(),
                                  style: TextStyle(
                                      color: _makerStorage.initType.type == 8
                                          ? Colors.white70
                                          : Colors.black54,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          //Level
                          Positioned(
                            top: 52,
                            right: 30,
                            child: SizedBox(
                              height: 18,
                              child: widget.cards.length == 1
                                  ? ListView.builder(
                                      reverse: true,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 3,
                                      itemBuilder: (context, i) =>
                                          Image.asset(_makerStorage.initImgLv))
                                  : Image.asset(_makerStorage.initImgLv),
                            ),
                          ),
                          //Attribute
                          Positioned(
                              top: 22,
                              right: 34,
                              child: Image.asset(
                                _makerStorage.attribute[1].image,
                                height: 25,
                              )),
                          //Name type
                          Positioned(
                              bottom: 70,
                              left: 40,
                              child: InkWell(
                                onTap: () => editInput(wtf.cardType),
                                child: Text(
                                  '[${_makerStorage.nameType.toLowerCase()}]',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          //Card desc
                          Positioned(
                              bottom: 56,
                              left: 34,
                              child: InkWell(
                                onTap: () => editInput(wtf.desc),
                                child: Text(
                                  _makerStorage.decs,
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w400),
                                ),
                              )),
                          //Divider
                          Positioned(
                              bottom: 35,
                              left: 22,
                              child: Container(
                                width: width * 0.6,
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
                                    'ATK/${_makerStorage.atk}'.toUpperCase(),
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
                                    'DEF/${_makerStorage.def}'.toUpperCase(),
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
                            bottom: 4,
                            right: 35,
                            child: InkWell(
                              onTap: () => editInput(wtf.year),
                              child: Text(
                                '@${_makerStorage.year}',
                                style: TextStyle(
                                    color: _makerStorage.initType.type == 8
                                        ? Colors.white70
                                        : Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          //Serial number
                          Positioned(
                            bottom: 4,
                            left: 35,
                            child: InkWell(
                              onTap: () => _randomNumber(),
                              child: Text(
                                '${_makerStorage.number}',
                                style: TextStyle(
                                    color: _makerStorage.initType.type == 8
                                        ? Colors.white70
                                        : Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : widget.mode == 2
                  ? Center(
                      child: Screenshot(
                        controller: screenController,
                        child: Container(
                          color: Colors.white38,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () => _getImage(0),
                                    child: Container(
                                      height: height * 0.18,
                                      width: width * 0.35,
                                      color: Colors.grey.withOpacity(0.2),
                                      child: imagePath.isEmpty
                                          ? Center(child: Text('?'))
                                          : Image.file(
                                              File(imagePath),
                                              width: width * 0.25,
                                              height: height * 0.25,
                                              fit: BoxFit.fill,
                                            ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => _getImage(1),
                                    child: Container(
                                      height: height * 0.18,
                                      width: width * 0.35,
                                      color: Colors.grey.withOpacity(0.2),
                                      child: image1Path.isEmpty
                                          ? Center(child: Text('?'))
                                          : Image.file(
                                              File(image1Path),
                                              width: width * 0.25,
                                              height: height * 0.25,
                                              fit: BoxFit.fill,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                child: Icon(Icons.arrow_downward),
                                height: height * 0.050,
                              ),
                              Image.asset('assets/images/fusion.png',
                                  height: height * 0.15),
                              SizedBox(
                                child: Icon(Icons.arrow_downward),
                                height: height * 0.050,
                              ),
                              InkWell(
                                onTap: () => _getImage(2),
                                child: Container(
                                  height: height * 0.25,
                                  width: width * 0.50,
                                  color: Colors.grey.withOpacity(0.2),
                                  child: image2Path.isEmpty
                                      ? Center(child: Text('?'))
                                      : Image.file(
                                          File(image2Path),
                                          width: width * 0.25,
                                          height: height * 0.25,
                                          fit: BoxFit.fill,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : widget.mode == 3
                      ? Center(
                          child: Screenshot(
                            controller: screenController,
                            child: SizedBox(
                              height: height * 0.60,
                              child: Stack(
                                children: [
                                  //Scaffold
                                  Image.asset(_makerStorage.initType.image),
                                  //Image
                                  Positioned(
                                    left: 32,
                                    bottom: 110,
                                    child: InkWell(
                                      onTap: () => _getImage(0),
                                      child: SizedBox(
                                        height: 195,
                                        width: 195,
                                        child: imagePath.isEmpty
                                            ? Center(
                                                child: Text(
                                                    'Tap here to select image'))
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
                                      top: 25,
                                      left: 35,
                                      child: InkWell(
                                        onTap: () => editInput(wtf.name),
                                        child: Text(
                                          _makerStorage.name.toUpperCase(),
                                          style: TextStyle(
                                              color:
                                                  _makerStorage.initType.type ==
                                                          8
                                                      ? Colors.white70
                                                      : Colors.black54,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                  //Level
                                  _makerStorage.initType.type == 8
                                      ? Positioned(
                                          top: 52,
                                          left: 30,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    lvShow = true;
                                                  });
                                                },
                                                child: SizedBox(
                                                  height: 18,
                                                  child: ListView.builder(
                                                      reverse: true,
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          _makerStorage.initLv,
                                                      itemBuilder: (context,
                                                              i) =>
                                                          Image.asset(
                                                              _makerStorage
                                                                  .initRank)),
                                                ),
                                              ),
                                              buildListLevel(),
                                            ],
                                          ),
                                        )
                                      : _makerStorage.initType.type == 9
                                          ? Positioned(
                                              top: 52,
                                              right: 30,
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
                                                            '[spell card '
                                                                .toUpperCase(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Image.asset(
                                                              _makerStorage
                                                                  .initTrapSpellType
                                                                  .image,
                                                              height: 18),
                                                          Text(
                                                            ']'.toUpperCase(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      )),
                                                  buildListTrapSpellType(),
                                                ],
                                              ),
                                            )
                                          : _makerStorage.initType.type == 10
                                              ? Positioned(
                                                  top: 52,
                                                  right: 30,
                                                  child: Stack(
                                                    children: [
                                                      InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              trapSpellShow =
                                                                  true;
                                                            });
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                '[trap card '
                                                                    .toUpperCase(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Image.asset(
                                                                  _makerStorage
                                                                      .initTrapSpellType
                                                                      .image,
                                                                  height:
                                                                      isLargerScreen
                                                                          ? 22
                                                                          : 18),
                                                              Text(
                                                                ']'.toUpperCase(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          )),
                                                      buildListTrapSpellType(),
                                                    ],
                                                  ),
                                                )
                                              : Positioned(
                                                  top: 52,
                                                  right: 30,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            lvShow = true;
                                                          });
                                                        },
                                                        child: SizedBox(
                                                          height: isLargerScreen
                                                              ? 22
                                                              : 18,
                                                          child: ListView.builder(
                                                              reverse: true,
                                                              shrinkWrap: true,
                                                              scrollDirection:
                                                                  Axis
                                                                      .horizontal,
                                                              itemCount:
                                                                  _makerStorage
                                                                      .initLv,
                                                              itemBuilder: (context,
                                                                      i) =>
                                                                  Image.asset(
                                                                      _makerStorage
                                                                          .initImgLv)),
                                                        ),
                                                      ),
                                                      buildListLevel(),
                                                    ],
                                                  ),
                                                ),
                                  //Attribute
                                  _makerStorage.initType.type == 9
                                      ? Positioned(
                                          top: 22,
                                          right: 34,
                                          child: Image.asset(
                                            _makerStorage.attribute[7].image,
                                            height: 25,
                                          ))
                                      : _makerStorage.initType.type == 10
                                          ? Positioned(
                                              top: 22,
                                              right: 34,
                                              child: Image.asset(
                                                _makerStorage
                                                    .attribute[8].image,
                                                height: 25,
                                              ))
                                          : Positioned(
                                              top: 22,
                                              right: 34,
                                              child: Stack(
                                                children: [
                                                  InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          attrShow = true;
                                                        });
                                                      },
                                                      child: Image.asset(
                                                        _makerStorage
                                                            .initAttr.image,
                                                        height: 25,
                                                      )),
                                                  buildListAttr(),
                                                ],
                                              )),
                                  //Name type
                                  Positioned(
                                      bottom: 70,
                                      left: 40,
                                      child: InkWell(
                                        onTap: () => editInput(wtf.cardType),
                                        child: Text(
                                          '[${_makerStorage.nameType.toLowerCase()}]',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                  //Card desc
                                  Positioned(
                                      bottom: 56,
                                      left: 34,
                                      child: InkWell(
                                        onTap: () => editInput(wtf.desc),
                                        child: Text(
                                          _makerStorage.decs,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      )),
                                  //Divider
                                  Positioned(
                                      bottom: 35,
                                      left: 22,
                                      child: Container(
                                        width: width * 0.6,
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
                                            'ATK/${_makerStorage.atk}'
                                                .toUpperCase(),
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
                                            'DEF/${_makerStorage.def}'
                                                .toUpperCase(),
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
                                    bottom: 4,
                                    right: 35,
                                    child: InkWell(
                                      onTap: () => editInput(wtf.year),
                                      child: Text(
                                        '@${_makerStorage.year}',
                                        style: TextStyle(
                                            color:
                                                _makerStorage.initType.type == 8
                                                    ? Colors.white70
                                                    : Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  //Serial number
                                  Positioned(
                                    bottom: 4,
                                    left: 35,
                                    child: InkWell(
                                      onTap: () => _randomNumber(),
                                      child: Text(
                                        '${_makerStorage.number}',
                                        style: TextStyle(
                                            color:
                                                _makerStorage.initType.type == 8
                                                    ? Colors.white70
                                                    : Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : widget.mode == 4
                          ? Center(
                              child: Screenshot(
                                controller: screenController,
                                child: SizedBox(
                                  height: height * 0.60,
                                  child: Stack(
                                    children: [
                                      //Scaffold
                                      Image.asset(_makerStorage.initType.image),
                                      //Image
                                      Positioned(
                                        left: 32,
                                        bottom: 110,
                                        child: InkWell(
                                          onTap: () => _getImage(0),
                                          child: SizedBox(
                                            height: 195,
                                            width: 195,
                                            child: imagePath.isEmpty
                                                ? Center(
                                                    child: Text(
                                                        'Tap here to select image'))
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
                                          top: 25,
                                          left: 35,
                                          child: InkWell(
                                            onTap: () => editInput(wtf.name),
                                            child: Text(
                                              _makerStorage.name.toUpperCase(),
                                              style: TextStyle(
                                                  color: _makerStorage
                                                              .initType.type ==
                                                          8
                                                      ? Colors.white70
                                                      : Colors.black54,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                      //Level
                                      _makerStorage.initType.type == 8
                                          ? Positioned(
                                              top: 52,
                                              left: 30,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        lvShow = true;
                                                      });
                                                    },
                                                    child: SizedBox(
                                                      height: 18,
                                                      child: ListView.builder(
                                                          reverse: true,
                                                          shrinkWrap: true,
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemCount:
                                                              _makerStorage
                                                                  .initLv,
                                                          itemBuilder: (context,
                                                                  i) =>
                                                              Image.asset(
                                                                  _makerStorage
                                                                      .initRank)),
                                                    ),
                                                  ),
                                                  buildListLevel(),
                                                ],
                                              ),
                                            )
                                          : _makerStorage.initType.type == 9
                                              ? Positioned(
                                                  top: 52,
                                                  right: 30,
                                                  child: Stack(
                                                    children: [
                                                      InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              trapSpellShow =
                                                                  true;
                                                            });
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                '[spell card '
                                                                    .toUpperCase(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Image.asset(
                                                                  _makerStorage
                                                                      .initTrapSpellType
                                                                      .image,
                                                                  height: 18),
                                                              Text(
                                                                ']'.toUpperCase(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          )),
                                                      buildListTrapSpellType(),
                                                    ],
                                                  ),
                                                )
                                              : _makerStorage.initType.type ==
                                                      10
                                                  ? Positioned(
                                                      top: 52,
                                                      right: 30,
                                                      child: Stack(
                                                        children: [
                                                          InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  trapSpellShow =
                                                                      true;
                                                                });
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    '[trap card '
                                                                        .toUpperCase(),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black54,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Image.asset(
                                                                      _makerStorage
                                                                          .initTrapSpellType
                                                                          .image,
                                                                      height: isLargerScreen
                                                                          ? 22
                                                                          : 18),
                                                                  Text(
                                                                    ']'.toUpperCase(),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black54,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ],
                                                              )),
                                                          buildListTrapSpellType(),
                                                        ],
                                                      ),
                                                    )
                                                  : Positioned(
                                                      top: 52,
                                                      right: 30,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                lvShow = true;
                                                              });
                                                            },
                                                            child: SizedBox(
                                                              height:
                                                                  isLargerScreen
                                                                      ? 22
                                                                      : 18,
                                                              child: ListView.builder(
                                                                  reverse: true,
                                                                  shrinkWrap:
                                                                      true,
                                                                  scrollDirection: Axis
                                                                      .horizontal,
                                                                  itemCount:
                                                                      _makerStorage
                                                                          .initLv,
                                                                  itemBuilder: (context,
                                                                          i) =>
                                                                      Image.asset(
                                                                          _makerStorage
                                                                              .initImgLv)),
                                                            ),
                                                          ),
                                                          buildListLevel(),
                                                        ],
                                                      ),
                                                    ),
                                      //Attribute
                                      _makerStorage.initType.type == 9
                                          ? Positioned(
                                              top: 22,
                                              right: 34,
                                              child: Image.asset(
                                                _makerStorage
                                                    .attribute[7].image,
                                                height: 25,
                                              ))
                                          : _makerStorage.initType.type == 10
                                              ? Positioned(
                                                  top: 22,
                                                  right: 34,
                                                  child: Image.asset(
                                                    _makerStorage
                                                        .attribute[8].image,
                                                    height: 25,
                                                  ))
                                              : Positioned(
                                                  top: 22,
                                                  right: 34,
                                                  child: Stack(
                                                    children: [
                                                      InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              attrShow = true;
                                                            });
                                                          },
                                                          child: Image.asset(
                                                            _makerStorage
                                                                .initAttr.image,
                                                            height: 25,
                                                          )),
                                                      buildListAttr(),
                                                    ],
                                                  )),
                                      //Name type
                                      Positioned(
                                          bottom: 70,
                                          left: 40,
                                          child: InkWell(
                                            onTap: () =>
                                                editInput(wtf.cardType),
                                            child: Text(
                                              '[${_makerStorage.nameType.toLowerCase()}]',
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                      //Card desc
                                      Positioned(
                                          bottom: 56,
                                          left: 34,
                                          child: InkWell(
                                            onTap: () => editInput(wtf.desc),
                                            child: Text(
                                              _makerStorage.decs,
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          )),
                                      //Divider
                                      Positioned(
                                          bottom: 35,
                                          left: 22,
                                          child: Container(
                                            width: width * 0.6,
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
                                                'ATK/${_makerStorage.atk}'
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            InkWell(
                                              onTap: () => editInput(wtf.def),
                                              child: Text(
                                                'DEF/${_makerStorage.def}'
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      //Year
                                      Positioned(
                                        bottom: 4,
                                        right: 35,
                                        child: InkWell(
                                          onTap: () => editInput(wtf.year),
                                          child: Text(
                                            '@${_makerStorage.year}',
                                            style: TextStyle(
                                                color: _makerStorage
                                                            .initType.type ==
                                                        8
                                                    ? Colors.white70
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      //Serial number
                                      Positioned(
                                        bottom: 4,
                                        left: 35,
                                        child: InkWell(
                                          onTap: () => _randomNumber(),
                                          child: Text(
                                            '${_makerStorage.number}',
                                            style: TextStyle(
                                                color: _makerStorage
                                                            .initType.type ==
                                                        8
                                                    ? Colors.white70
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Screenshot(
                                controller: screenController,
                                child: SizedBox(
                                  height: height * 0.60,
                                  child: Stack(
                                    children: [
                                      //Scaffold
                                      Image.asset(_makerStorage.initType.image),
                                      //Image
                                      Positioned(
                                        left: 32,
                                        bottom: 110,
                                        child: InkWell(
                                          onTap: () => _getImage(0),
                                          child: SizedBox(
                                            height: 195,
                                            width: 195,
                                            child: imagePath.isEmpty
                                                ? Center(
                                                    child: Text(
                                                        'Tap here to select image'))
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
                                          top: 25,
                                          left: 35,
                                          child: InkWell(
                                            onTap: () => editInput(wtf.name),
                                            child: Text(
                                              _makerStorage.name.toUpperCase(),
                                              style: TextStyle(
                                                  color: _makerStorage
                                                              .initType.type ==
                                                          8
                                                      ? Colors.white70
                                                      : Colors.black54,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                      //Level
                                      _makerStorage.initType.type == 8
                                          ? Positioned(
                                              top: 52,
                                              left: 30,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        lvShow = true;
                                                      });
                                                    },
                                                    child: SizedBox(
                                                      height: 18,
                                                      child: ListView.builder(
                                                          reverse: true,
                                                          shrinkWrap: true,
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemCount:
                                                              _makerStorage
                                                                  .initLv,
                                                          itemBuilder: (context,
                                                                  i) =>
                                                              Image.asset(
                                                                  _makerStorage
                                                                      .initRank)),
                                                    ),
                                                  ),
                                                  buildListLevel(),
                                                ],
                                              ),
                                            )
                                          : _makerStorage.initType.type == 9
                                              ? Positioned(
                                                  top: 52,
                                                  right: 30,
                                                  child: Stack(
                                                    children: [
                                                      InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              trapSpellShow =
                                                                  true;
                                                            });
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                '[spell card '
                                                                    .toUpperCase(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Image.asset(
                                                                  _makerStorage
                                                                      .initTrapSpellType
                                                                      .image,
                                                                  height: 18),
                                                              Text(
                                                                ']'.toUpperCase(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          )),
                                                      buildListTrapSpellType(),
                                                    ],
                                                  ),
                                                )
                                              : _makerStorage.initType.type ==
                                                      10
                                                  ? Positioned(
                                                      top: 52,
                                                      right: 30,
                                                      child: Stack(
                                                        children: [
                                                          InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  trapSpellShow =
                                                                      true;
                                                                });
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    '[trap card '
                                                                        .toUpperCase(),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black54,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Image.asset(
                                                                      _makerStorage
                                                                          .initTrapSpellType
                                                                          .image,
                                                                      height: isLargerScreen
                                                                          ? 22
                                                                          : 18),
                                                                  Text(
                                                                    ']'.toUpperCase(),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black54,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ],
                                                              )),
                                                          buildListTrapSpellType(),
                                                        ],
                                                      ),
                                                    )
                                                  : Positioned(
                                                      top: 52,
                                                      right: 30,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                lvShow = true;
                                                              });
                                                            },
                                                            child: SizedBox(
                                                              height:
                                                                  isLargerScreen
                                                                      ? 22
                                                                      : 18,
                                                              child: ListView.builder(
                                                                  reverse: true,
                                                                  shrinkWrap:
                                                                      true,
                                                                  scrollDirection: Axis
                                                                      .horizontal,
                                                                  itemCount:
                                                                      _makerStorage
                                                                          .initLv,
                                                                  itemBuilder: (context,
                                                                          i) =>
                                                                      Image.asset(
                                                                          _makerStorage
                                                                              .initImgLv)),
                                                            ),
                                                          ),
                                                          buildListLevel(),
                                                        ],
                                                      ),
                                                    ),
                                      //Attribute
                                      _makerStorage.initType.type == 9
                                          ? Positioned(
                                              top: 22,
                                              right: 34,
                                              child: Image.asset(
                                                _makerStorage
                                                    .attribute[7].image,
                                                height: 25,
                                              ))
                                          : _makerStorage.initType.type == 10
                                              ? Positioned(
                                                  top: 22,
                                                  right: 34,
                                                  child: Image.asset(
                                                    _makerStorage
                                                        .attribute[8].image,
                                                    height: 25,
                                                  ))
                                              : Positioned(
                                                  top: 22,
                                                  right: 34,
                                                  child: Stack(
                                                    children: [
                                                      InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              attrShow = true;
                                                            });
                                                          },
                                                          child: Image.asset(
                                                            _makerStorage
                                                                .initAttr.image,
                                                            height: 25,
                                                          )),
                                                      buildListAttr(),
                                                    ],
                                                  )),
                                      //Name type
                                      Positioned(
                                          bottom: 70,
                                          left: 40,
                                          child: InkWell(
                                            onTap: () =>
                                                editInput(wtf.cardType),
                                            child: Text(
                                              '[${_makerStorage.nameType.toLowerCase()}]',
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                      //Card desc
                                      Positioned(
                                          bottom: 56,
                                          left: 34,
                                          child: InkWell(
                                            onTap: () => editInput(wtf.desc),
                                            child: Text(
                                              _makerStorage.decs,
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          )),
                                      //Divider
                                      Positioned(
                                          bottom: 35,
                                          left: 22,
                                          child: Container(
                                            width: width * 0.6,
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
                                                'ATK/${_makerStorage.atk}'
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            InkWell(
                                              onTap: () => editInput(wtf.def),
                                              child: Text(
                                                'DEF/${_makerStorage.def}'
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      //Year
                                      Positioned(
                                        bottom: 4,
                                        right: 35,
                                        child: InkWell(
                                          onTap: () => editInput(wtf.year),
                                          child: Text(
                                            '@${_makerStorage.year}',
                                            style: TextStyle(
                                                color: _makerStorage
                                                            .initType.type ==
                                                        8
                                                    ? Colors.white70
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      //Serial number
                                      Positioned(
                                        bottom: 4,
                                        left: 35,
                                        child: InkWell(
                                          onTap: () => _randomNumber(),
                                          child: Text(
                                            '${_makerStorage.number}',
                                            style: TextStyle(
                                                color: _makerStorage
                                                            .initType.type ==
                                                        8
                                                    ? Colors.white70
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
          widget.mode == 4
              ? Column(
                  children: [
                    SizedBox(
                      height: height * 0.0300,
                      child: Text(
                        'Your input degree here',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.125,
                      child: InkWell(
                        onTap: () => editInput(wtf.degree),
                        child: Text(
                          '$degree °',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                )
              : SizedBox(
                  height: height * 0.1,
                )
        ],
      ),
    );
  }
}

