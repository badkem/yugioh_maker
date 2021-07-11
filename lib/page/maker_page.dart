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
  late Box<History> dataBox;
  late Timer timer;

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
        await ImageGallerySaver.saveImage(image!, quality: 100, name: '$fileName');
        String base64Image = base64Encode(image);
        History data = History(
            cardType: _makerStorage.initType.image,
            type: _makerStorage.initType.type,
            attr: _makerStorage.initAttr.image,
            level: _makerStorage.initLv,
            name: _makerStorage.name,
            image: imagePath,
            base64Image: base64Image,
            trapSpellType: _makerStorage.initTrapSpellType.image,
            nameType: _makerStorage.nameType,
            desc: _makerStorage.decs,
            serialNumber: _makerStorage.number,
            year: _makerStorage.year,
            atk: _makerStorage.atk,
            def: _makerStorage.def);
        dataBox.add(data);
      });
    } catch (e) {
      print(e);
    } finally {
      showDialog(
          context: context,
          builder: (BuildContext builderContext) {
            timer = Timer(Duration(milliseconds: 800), () {
              Navigator.of(context).pop();
            });

            return Dialog(
              backgroundColor: Colors.transparent,
             child: SizedBox.expand(
               child: Container(
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Icon(Icons.check_sharp, size: 35, color: Colors.green,),
                     Text('saved'.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 35, fontFamily: 'Caps-1', fontWeight: FontWeight.bold),),
                   ],
                 ),
               ),
             ),
            );
          }
      ).then((val){
        if (timer.isActive) {
          timer.cancel();
        }
      });
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
          builder: (context) => HistoryPage()),
    );
    if (result != null) {
      var json = jsonDecode(jsonEncode(result));
      History history = History.fromJson(json);
      setState(() {
        imagePath = history.image;
        _makerStorage.name = history.name;
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
      widget.cards.add(YugiohCard(image!, double.parse(degree)));
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
      widget.cards.add(YugiohCard(image!, double.parse(degree)));
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
  void initState() {
    dataBox = Hive.box<History>(dataBoxName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mode = widget.mode;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/background.png')
            )
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0.5,
            backgroundColor: Colors.white.withOpacity(0.3),
            leading: TextButton.icon(
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
                icon: Image.asset('assets/images/btn_back.png', width: 30,),
                label: Text('')),
            centerTitle: true,
            title: mode == 0
                ? Text('normal'.toUpperCase(), style: TextStyle(fontFamily: 'Caps-1', fontSize: 30, color: Colors.black87),)
                : mode == 1
                ? Text('exodia'.toUpperCase(), style: TextStyle(fontFamily: 'Caps-1', fontSize: 30, color: Colors.black87),)
                : mode == 2
                ? Text('meme fusion'.toUpperCase(), style: TextStyle(fontFamily: 'Caps-1', fontSize: 30, color: Colors.black87),)
                : mode == 3
                ? Text('3 cards'.toUpperCase(), style: TextStyle(fontFamily: 'Caps-1', fontSize: 30, color: Colors.black87),)
                : mode == 4
                ? Text('3 cards stack'.toUpperCase(), style: TextStyle(fontFamily: 'Caps-1', fontSize: 30, color: Colors.black87),)
                : SizedBox(),
            actions: [
              imagePath.isNotEmpty
                  ? TextButton.icon(
                onPressed: () {
                  if (mode == 0) {
                    widget.cards.clear();
                    _toPreview();
                  }

                  if (mode == 1) {
                    if (widget.cards.length < 4) {
                      _toNextPage();
                    } else {
                      _toPreview();
                    }
                  }

                  if (mode == 2) {
                    widget.cards.clear();
                    _toPreview();
                  }

                  if (mode == 3) {
                    if (widget.cards.length < 2) {
                      _toNextPage();
                    } else {
                      _toPreview();
                    }
                  }

                  if (mode == 4) {
                    if (widget.cards.length < 2) {
                      _toNextPage();
                    } else {
                      _toPreview();
                    }
                  }
                },
                icon: Image.asset('assets/images/btn_next.png', width: 30,),
                label: Text(''),
              ) : TextButton.icon(
                onPressed: () {},
                label: Text(''),
                icon: Image.asset('assets/images/btn_next.png', width: 30,),
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
              return isLargerScreen ? _buildMediumLayout(mode) : _buildSmallLayout(mode);
            },
          ),
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
                maxLength: type == wtf.name ? 20
                          : type == wtf.cardType ? 25
                          : type == wtf.desc ? 100 : 4,
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
          width: isLargerScreen ? 150 : 100,
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
                  width: isLargerScreen ? 35 : 25,
                  height: isLargerScreen ? 35 : 25,
                ),
                title: Text(item.name, overflow: TextOverflow.ellipsis,),
              );
            },
          ),
        ));
  }

  _buildMediumLayout(int mode) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// body appbar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: height * 0.030,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: _navigateAndDisplayHistorySelection,
                    child: Image.asset('assets/images/collection.png'),
                  ),
                  InkWell(
                    onTap: () {
                      switch(mode) {
                        case 0:
                          if(imagePath.isNotEmpty) {
                            _toPreview();
                          }
                          break;
                        case 1:
                          break;
                        case 2:
                          if(imagePath.isNotEmpty) {
                            _toPreview();
                          }
                          break;
                        case 3:
                          break;
                        case 4:
                          break;
                      }
                    },
                    child: Image.asset(
                      'assets/images/preview.png',
                      color: mode == 1 ? Colors.black38
                          : mode == 2 ? Colors.black38
                          : mode == 3 ? Colors.black38
                          : Colors.black,),
                  )
                ],
              ),
            ),
          ),
          /// card body
          mode == 1
              ? Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Screenshot(
                        controller: screenController,
                        child: Container(
                          width: constraints.maxWidth / 1.3,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              /// pick file
                              Positioned(
                                bottom: 70,
                                child: GestureDetector(
                                  onTap: () => _getImage(0),
                                  child: Container(
                                    color: Colors.white,
                                    height: 350,
                                    width: width * 0.65,
                                    child: InteractiveViewer(
                                      boundaryMargin: const EdgeInsets.all(20.0),
                                      minScale: 1,
                                      maxScale: 4,
                                      child: imagePath.isEmpty
                                          ? Center(
                                          child: Text('Tap here to select image', style: TextStyle(
                                              fontFamily: 'Caps-1',
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),))
                                          : Image.file(File(imagePath)),
                                    ),
                                  ),
                                ),
                              ),
                              /// scaffold
                              IgnorePointer(
                                ignoring: true,
                                child: widget.cards.length == 1
                                    ? Image.asset(_makerStorage.cardType[1].image)
                                    : Image.asset(_makerStorage.cardType[0].image),
                              ),
                              /// name
                              Positioned(
                                  top: 30,
                                  left: 30,
                                  child: InkWell(
                                    onTap: () => editInput(wtf.name),
                                    child: Text(
                                      _makerStorage.name.toUpperCase(),
                                      style: TextStyle(
                                          color: _makerStorage
                                              .initType.type == 8
                                              ? Colors.white70
                                              : Colors.black87,
                                          fontFamily: 'Caps-1',
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              /// level
                              Positioned(
                                top: 58,
                                right: 35,
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
                              /// attribute
                              Positioned(
                                  top: 24,
                                  right: 23,
                                  child: Image.asset(
                                    _makerStorage.attribute[1].image,
                                    height: 28,
                                  )),
                              /// card name/desc
                              Positioned(
                                  bottom: 90,
                                  left: 40,
                                  child: InkWell(
                                    onTap: () => editInput(wtf.cardType),
                                    child: Text(
                                      '[ ${_makerStorage.nameType.toLowerCase()} ]',
                                      style: TextStyle(
                                          fontFamily: 'Caps-1',
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              Positioned(
                                  bottom: 70,
                                  left: 40,
                                  child: InkWell(
                                    onTap: () => editInput(wtf.desc),
                                    child: Text(
                                      _makerStorage.decs,
                                      style: TextStyle(
                                          fontFamily: 'Caps-1',
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              /// atk/def
                              Positioned(
                                bottom: 25,
                                right: 90,
                                child: InkWell(
                                  onTap: () => editInput(wtf.atk),
                                  child: Text('${_makerStorage.atk}',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'Caps-1',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 25,
                                right: 25,
                                child: InkWell(
                                  onTap: () => editInput(wtf.def),
                                  child: Text(
                                    '${_makerStorage.def}',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'Caps-1',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              /// num/year
                              Positioned(
                                bottom: 6,
                                right: 25,
                                child: InkWell(
                                  onTap: () => editInput(wtf.year),
                                  child: Text(
                                    '${_makerStorage.year}',
                                    style: TextStyle(
                                        color: _makerStorage
                                            .initType.type == 8
                                            ? Colors.white70
                                            : Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Caps-1',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 6,
                                left: 25,
                                child: InkWell(
                                  onTap: () => _randomNumber(),
                                  child: Text(
                                    '${_makerStorage.number}',
                                    style: TextStyle(
                                        color: _makerStorage
                                            .initType.type == 8
                                            ? Colors.white70
                                            : Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Caps-1',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              : mode == 2
                  ? Center(
                      child: Screenshot(
                        controller: screenController,
                        child: Container(
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
                                      color: AppColors.placeHolder.withOpacity(0.95),
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
                                      color: AppColors.placeHolder.withOpacity(0.95),
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
                                  color: AppColors.placeHolder.withOpacity(0.95),
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
                  : mode == 3
                      ? Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Screenshot(
                  controller: screenController,
                  child: Container(
                    width: constraints.maxWidth / 1.3,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        /// pick file
                        Positioned(
                          bottom: 70,
                          child: GestureDetector(
                            onTap: () => _getImage(0),
                            child: Container(
                              color: Colors.white,
                              height: 350,
                              width: width * 0.65,
                              child: InteractiveViewer(
                                boundaryMargin: const EdgeInsets.all(20.0),
                                minScale: 1,
                                maxScale: 4,
                                child: imagePath.isEmpty
                                    ? Center(
                                    child: Text('Tap here to select image', style: TextStyle(
                                        fontFamily: 'Caps-1',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),))
                                    : Image.file(File(imagePath)),
                              ),
                            ),
                          ),
                        ),
                        /// scaffold
                        IgnorePointer(
                          ignoring: true,
                          child: Image.asset(_makerStorage.initType.image),
                        ),
                        /// name
                        Positioned(
                            top: 30,
                            left: 30,
                            child: InkWell(
                              onTap: () => editInput(wtf.name),
                              child: Text(
                                _makerStorage.name.toUpperCase(),
                                style: TextStyle(
                                    color: _makerStorage
                                        .initType.type == 8
                                        ? Colors.white70
                                        : Colors.black87,
                                    fontFamily: 'Caps-1',
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        /// level
                        _makerStorage.initType.type == 8
                            ? Positioned(
                          top: 58,
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
                          top: 58,
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
                                        '[ spell card '
                                            .toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Image.asset(
                                          _makerStorage
                                              .initTrapSpellType
                                              .image,
                                          height: 20),
                                      Text(
                                        ' ]'.toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                              buildListTrapSpellType(),
                            ],
                          ),
                        )
                            : _makerStorage.initType.type == 10
                            ? Positioned(
                          top: 58,
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
                                        '[ trap card '.toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Image.asset(
                                          _makerStorage
                                              .initTrapSpellType
                                              .image,
                                          height: 20),
                                      Text(
                                        ' ]'.toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                              buildListTrapSpellType(),
                            ],
                          ),
                        )
                            : Positioned(
                          top: 58,
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
                                  height: 18,
                                  child: ListView.builder(
                                      reverse: true,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                      _makerStorage.initLv,
                                      itemBuilder: (context, i) =>
                                          Image.asset(
                                              _makerStorage
                                                  .initImgLv)),
                                ),
                              ),
                              buildListLevel(),
                            ],
                          ),
                        ),
                        /// attribute
                        _makerStorage.initType.type == 9
                            ? SizedBox()
                            : _makerStorage.initType.type == 10
                            ? SizedBox()
                            : Positioned(
                            top: 24,
                            right: 23,
                            child: Stack(
                              children: [
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        attrShow = true;
                                      });
                                    },
                                    child: Image.asset(
                                      _makerStorage.initAttr.image,
                                      height: 28,
                                    )),
                                buildListAttr(),
                              ],
                            )),
                        /// card name/desc
                        Positioned(
                            bottom: 90,
                            left: 40,
                            child: InkWell(
                              onTap: () => editInput(wtf.cardType),
                              child: Text(
                                '[ ${_makerStorage.nameType.toLowerCase()} ]',
                                style: TextStyle(
                                    fontFamily: 'Caps-1',
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Positioned(
                            bottom: 70,
                            left: 40,
                            child: InkWell(
                              onTap: () => editInput(wtf.desc),
                              child: Text(
                                _makerStorage.decs,
                                style: TextStyle(
                                    fontFamily: 'Caps-1',
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        /// atk/def
                        Positioned(
                          bottom: 25,
                          right: 90,
                          child: InkWell(
                            onTap: () => editInput(wtf.atk),
                            child: Text('${_makerStorage.atk}',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Caps-1',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 25,
                          right: 25,
                          child: InkWell(
                            onTap: () => editInput(wtf.def),
                            child: Text(
                              '${_makerStorage.def}',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Caps-1',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        /// num/year
                        Positioned(
                          bottom: 6,
                          right: 25,
                          child: InkWell(
                            onTap: () => editInput(wtf.year),
                            child: Text(
                              '${_makerStorage.year}',
                              style: TextStyle(
                                  color: _makerStorage
                                      .initType.type == 8
                                      ? Colors.white70
                                      : Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Caps-1',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 6,
                          left: 25,
                          child: InkWell(
                            onTap: () => _randomNumber(),
                            child: Text(
                              '${_makerStorage.number}',
                              style: TextStyle(
                                  color: _makerStorage
                                      .initType.type == 8
                                      ? Colors.white70
                                      : Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Caps-1',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
                      : mode == 4
                          ? Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Screenshot(
                  controller: screenController,
                  child: Container(
                    width: constraints.maxWidth / 1.3,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        /// pick file
                        Positioned(
                          bottom: 70,
                          child: GestureDetector(
                            onTap: () => _getImage(0),
                            child: Container(
                              color: Colors.white,
                              height: 350,
                              width: width * 0.65,
                              child: InteractiveViewer(
                                boundaryMargin: const EdgeInsets.all(20.0),
                                minScale: 1,
                                maxScale: 4,
                                child: imagePath.isEmpty
                                    ? Center(
                                    child: Text('Tap here to select image', style: TextStyle(
                                        fontFamily: 'Caps-1',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),))
                                    : Image.file(File(imagePath)),
                              ),
                            ),
                          ),
                        ),
                        /// scaffold
                        IgnorePointer(
                          ignoring: true,
                          child: Image.asset(_makerStorage.initType.image),
                        ),
                        /// name
                        Positioned(
                            top: 30,
                            left: 30,
                            child: InkWell(
                              onTap: () => editInput(wtf.name),
                              child: Text(
                                _makerStorage.name.toUpperCase(),
                                style: TextStyle(
                                    color: _makerStorage
                                        .initType.type == 8
                                        ? Colors.white70
                                        : Colors.black87,
                                    fontFamily: 'Caps-1',
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        /// level
                        _makerStorage.initType.type == 8
                            ? Positioned(
                          top: 58,
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
                          top: 58,
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
                                        '[ spell card '
                                            .toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Image.asset(
                                          _makerStorage
                                              .initTrapSpellType
                                              .image,
                                          height: 20),
                                      Text(
                                        ' ]'.toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                              buildListTrapSpellType(),
                            ],
                          ),
                        )
                            : _makerStorage.initType.type == 10
                            ? Positioned(
                          top: 58,
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
                                        '[ trap card '.toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Image.asset(
                                          _makerStorage
                                              .initTrapSpellType
                                              .image,
                                          height: 20),
                                      Text(
                                        ' ]'.toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                              buildListTrapSpellType(),
                            ],
                          ),
                        )
                            : Positioned(
                          top: 58,
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
                                  height: 18,
                                  child: ListView.builder(
                                      reverse: true,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                      _makerStorage.initLv,
                                      itemBuilder: (context, i) =>
                                          Image.asset(
                                              _makerStorage
                                                  .initImgLv)),
                                ),
                              ),
                              buildListLevel(),
                            ],
                          ),
                        ),
                        /// attribute
                        _makerStorage.initType.type == 9
                            ? SizedBox()
                            : _makerStorage.initType.type == 10
                            ? SizedBox()
                            : Positioned(
                            top: 24,
                            right: 23,
                            child: Stack(
                              children: [
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        attrShow = true;
                                      });
                                    },
                                    child: Image.asset(
                                      _makerStorage.initAttr.image,
                                      height: 28,
                                    )),
                                buildListAttr(),
                              ],
                            )),
                        /// card name/desc
                        Positioned(
                            bottom: 90,
                            left: 40,
                            child: InkWell(
                              onTap: () => editInput(wtf.cardType),
                              child: Text(
                                '[ ${_makerStorage.nameType.toLowerCase()} ]',
                                style: TextStyle(
                                    fontFamily: 'Caps-1',
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Positioned(
                            bottom: 70,
                            left: 40,
                            child: InkWell(
                              onTap: () => editInput(wtf.desc),
                              child: Text(
                                _makerStorage.decs,
                                style: TextStyle(
                                    fontFamily: 'Caps-1',
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        /// atk/def
                        Positioned(
                          bottom: 25,
                          right: 90,
                          child: InkWell(
                            onTap: () => editInput(wtf.atk),
                            child: Text('${_makerStorage.atk}',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Caps-1',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 25,
                          right: 25,
                          child: InkWell(
                            onTap: () => editInput(wtf.def),
                            child: Text(
                              '${_makerStorage.def}',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Caps-1',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        /// num/year
                        Positioned(
                          bottom: 6,
                          right: 25,
                          child: InkWell(
                            onTap: () => editInput(wtf.year),
                            child: Text(
                              '${_makerStorage.year}',
                              style: TextStyle(
                                  color: _makerStorage
                                      .initType.type == 8
                                      ? Colors.white70
                                      : Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Caps-1',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 6,
                          left: 25,
                          child: InkWell(
                            onTap: () => _randomNumber(),
                            child: Text(
                              '${_makerStorage.number}',
                              style: TextStyle(
                                  color: _makerStorage
                                      .initType.type == 8
                                      ? Colors.white70
                                      : Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Caps-1',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
                          : Center(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return Screenshot(
                                    controller: screenController,
                                    child: Container(
                                      width: constraints.maxWidth / 1.3,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          /// pick file
                                          Positioned(
                                            bottom: 70,
                                            child: GestureDetector(
                                              onTap: () => _getImage(0),
                                              child: Container(
                                                color: Colors.white,
                                                height: 350,
                                                width: width * 0.65,
                                                child: InteractiveViewer(
                                                  boundaryMargin: const EdgeInsets.all(20.0),
                                                  minScale: 1,
                                                  maxScale: 4,
                                                  child: imagePath.isEmpty
                                                      ? Center(
                                                      child: Text('Tap here to select image', style: TextStyle(
                                                          fontFamily: 'Caps-1',
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w400),))
                                                      : Image.file(File(imagePath)),
                                                ),
                                              ),
                                            ),
                                          ),
                                          /// scaffold
                                          IgnorePointer(
                                            ignoring: true,
                                            child: Image.asset(_makerStorage.initType.image),
                                          ),
                                          /// name
                                          Positioned(
                                              top: 30,
                                              left: 30,
                                              child: InkWell(
                                                onTap: () => editInput(wtf.name),
                                                child: Text(
                                                  _makerStorage.name.toUpperCase(),
                                                  style: TextStyle(
                                                      color: _makerStorage
                                                          .initType.type == 8
                                                          ? Colors.white70
                                                          : Colors.black87,
                                                      fontFamily: 'Caps-1',
                                                      fontSize: 19,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              )),
                                          /// level
                                          _makerStorage.initType.type == 8
                                              ? Positioned(
                                            top: 58,
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
                                            top: 58,
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
                                                          '[ spell card '
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                        Image.asset(
                                                            _makerStorage
                                                                .initTrapSpellType
                                                                .image,
                                                            height: 20),
                                                        Text(
                                                          ' ]'.toUpperCase(),
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                      ],
                                                    )),
                                                buildListTrapSpellType(),
                                              ],
                                            ),
                                          )
                                              : _makerStorage.initType.type == 10
                                              ? Positioned(
                                            top: 58,
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
                                                          '[ trap card '.toUpperCase(),
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                        Image.asset(
                                                            _makerStorage
                                                                .initTrapSpellType
                                                                .image,
                                                            height: 20),
                                                        Text(
                                                          ' ]'.toUpperCase(),
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                      ],
                                                    )),
                                                buildListTrapSpellType(),
                                              ],
                                            ),
                                          )
                                              : Positioned(
                                            top: 58,
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
                                                    height: 18,
                                                    child: ListView.builder(
                                                        reverse: true,
                                                        shrinkWrap: true,
                                                        scrollDirection: Axis.horizontal,
                                                        itemCount:
                                                        _makerStorage.initLv,
                                                        itemBuilder: (context, i) =>
                                                            Image.asset(
                                                                _makerStorage
                                                                    .initImgLv)),
                                                  ),
                                                ),
                                                buildListLevel(),
                                              ],
                                            ),
                                          ),
                                          /// attribute
                                          _makerStorage.initType.type == 9
                                              ? SizedBox()
                                              : _makerStorage.initType.type == 10
                                              ? SizedBox()
                                              : Positioned(
                                              top: 24,
                                              right: 23,
                                              child: Stack(
                                                children: [
                                                  InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          attrShow = true;
                                                        });
                                                      },
                                                      child: Image.asset(
                                                        _makerStorage.initAttr.image,
                                                        height: 28,
                                                      )),
                                                  buildListAttr(),
                                                ],
                                              )),
                                          /// card name/desc
                                          Positioned(
                                              bottom: 100,
                                              left: 40,
                                              child: InkWell(
                                                onTap: () => editInput(wtf.cardType),
                                                child: Text(
                                                  '[ ${_makerStorage.nameType.toLowerCase()} ]',
                                                  style: TextStyle(
                                                      fontFamily: 'Caps-1',
                                                      fontSize: 19,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              )),
                                          Positioned(
                                              bottom: 50,
                                              left: 40,
                                              child: Container(
                                                height: 50,
                                                width: width * 0.6,
                                                child: InkWell(
                                                  onTap: () => editInput(wtf.desc),
                                                  child: Text(
                                                    _makerStorage.decs,
                                                    style: TextStyle(
                                                        fontFamily: 'Caps-1',
                                                        fontSize: 17,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              )),
                                          /// atk/def
                                          Positioned(
                                            bottom: 25,
                                            right: 90,
                                            child: InkWell(
                                              onTap: () => editInput(wtf.atk),
                                              child: Text('${_makerStorage.atk}',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontFamily: 'Caps-1',
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 25,
                                            right: 25,
                                            child: InkWell(
                                              onTap: () => editInput(wtf.def),
                                              child: Text(
                                                '${_makerStorage.def}',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontFamily: 'Caps-1',
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          /// num/year
                                          Positioned(
                                            bottom: 6,
                                            right: 25,
                                            child: InkWell(
                                              onTap: () => editInput(wtf.year),
                                              child: Text(
                                                '${_makerStorage.year}',
                                                style: TextStyle(
                                                    color: _makerStorage
                                                        .initType.type == 8
                                                        ? Colors.white70
                                                        : Colors.black,
                                                    fontSize: 18,
                                                    fontFamily: 'Caps-1',
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 6,
                                            left: 25,
                                            child: InkWell(
                                              onTap: () => _randomNumber(),
                                              child: Text(
                                                '${_makerStorage.number}',
                                                style: TextStyle(
                                                    color: _makerStorage
                                                        .initType.type == 8
                                                        ? Colors.white70
                                                        : Colors.black,
                                                    fontSize: 18,
                                                    fontFamily: 'Caps-1',
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
          /// btn save
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              height: 50,
              width: 100,
              decoration: BoxDecoration(
                color: AppColors.dropdownButton.withOpacity(0.6),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                    color: Colors.black, style: BorderStyle.solid, width: 2.2),
              ),
              child: TextButton(
                  onPressed: () => imagePath.isNotEmpty ? _save() : {},
                  child: Text("Save",
                      style: TextStyle(fontFamily: 'Caps-1', fontSize: 24,
                          fontWeight: FontWeight.w600, color: imagePath.isNotEmpty ? Colors.black : Colors.black38)),
              ),
            ),
          ),
          /// theme select
          mode == 1 ? SizedBox()
          : mode == 2 ? SizedBox()
          : Expanded(
            child: Container(
              color: Colors.white.withOpacity(0.4),
              width: double.infinity,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _makerStorage.cardType.length,
                  itemBuilder: (context, index) {
                    final item = _makerStorage.cardType[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _makerStorage.initType = item;
                          });
                        },
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 60,
                                  color: Colors.white,
                                ),
                                Image.asset(item.image, width: 60),
                              ],
                            ),
                            Text(item.name,
                              style: TextStyle(
                                  fontFamily: 'Caps-1',
                                  fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }

  _buildSmallLayout(int mode) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// body appbar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: height * 0.030,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: _navigateAndDisplayHistorySelection,
                    child: Image.asset('assets/images/collection.png'),
                  ),
                  InkWell(
                    onTap: () {
                      switch(mode) {
                        case 0:
                          if(imagePath.isNotEmpty) {
                            _toPreview();
                          }
                          break;
                        case 1:
                          break;
                        case 2:
                          if(imagePath.isNotEmpty) {
                            _toPreview();
                          }
                          break;
                        case 3:
                          break;
                        case 4:
                          break;
                      }
                    },
                    child: Image.asset(
                      'assets/images/preview.png',
                      color: mode == 1 ? Colors.black38
                          : mode == 2 ? Colors.black38
                          : mode == 3 ? Colors.black38
                          : Colors.black,),
                  )
                ],
              ),
            ),
          ),
          /// card body
          mode == 1
              ? Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Screenshot(
                  controller: screenController,
                  child: Container(
                    width: constraints.maxWidth / 1.6,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        /// pick file
                        Positioned(
                          top: 60,
                          child: GestureDetector(
                            onTap: () => _getImage(0),
                            child: Container(
                              color: AppColors.placeHolder,
                              height: height * 0.3,
                              width: width * 0.65,
                              child: InteractiveViewer(
                                boundaryMargin: const EdgeInsets.all(20.0),
                                minScale: 1,
                                maxScale: 4,
                                child: imagePath.isEmpty
                                    ? Center(
                                    child: Text('Tap here to select image', style: TextStyle(
                                        fontFamily: 'Caps-1',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),))
                                    : Image.file(File(imagePath)),
                              ),
                            ),
                          ),
                        ),
                        /// scaffold
                        IgnorePointer(
                          ignoring: true,
                          child: widget.cards.length == 1
                              ? Image.asset(_makerStorage.cardType[1].image)
                              : Image.asset(_makerStorage.cardType[0].image),
                        ),
                        /// name
                        Positioned(
                            top: 18,
                            left: 20,
                            child: InkWell(
                              onTap: () => editInput(wtf.name),
                              child: Text(
                                _makerStorage.name.toUpperCase(),
                                style: TextStyle(
                                    color: _makerStorage
                                        .initType.type == 8
                                        ? Colors.white70
                                        : Colors.black87,
                                    fontFamily: 'Caps-1',
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        /// level
                        Positioned(
                          top: 41,
                          right: 24,
                          child: SizedBox(
                            height: 12,
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
                        /// attribute
                        Positioned(
                            top: 16,
                            right: 16,
                            child: Image.asset(
                              _makerStorage.attribute[1].image,
                              height: 21,
                            )),
                        /// card name/desc
                        Positioned(
                            bottom: 60,
                            left: 26,
                            child: InkWell(
                              onTap: () => editInput(wtf.cardType),
                              child: Text(
                                '[ ${_makerStorage.nameType.toLowerCase()} ]',
                                style: TextStyle(
                                    fontFamily: 'Caps-1',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Positioned(
                            bottom: 48,
                            left: 30,
                            child: InkWell(
                              onTap: () => editInput(wtf.desc),
                              child: Text(
                                _makerStorage.decs,
                                style: TextStyle(
                                    fontFamily: 'Caps-1',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        /// atk/def
                        Positioned(
                          bottom: 16,
                          right: 60,
                          child: InkWell(
                            onTap: () => editInput(wtf.atk),
                            child: Text('${_makerStorage.atk}',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Caps-1',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          right: 20,
                          child: InkWell(
                            onTap: () => editInput(wtf.def),
                            child: Text(
                              '${_makerStorage.def}',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Caps-1',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        /// num/year
                        Positioned(
                          bottom: 3,
                          right: 22,
                          child: InkWell(
                            onTap: () => editInput(wtf.year),
                            child: Text(
                              '${_makerStorage.year}',
                              style: TextStyle(
                                  color: _makerStorage
                                      .initType.type == 8
                                      ? Colors.white70
                                      : Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Caps-1',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 3,
                          left: 22,
                          child: InkWell(
                            onTap: () => _randomNumber(),
                            child: Text(
                              '${_makerStorage.number}',
                              style: TextStyle(
                                  color: _makerStorage
                                      .initType.type == 8
                                      ? Colors.white70
                                      : Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Caps-1',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
              : mode == 2
              ? Center(
            child: Screenshot(
              controller: screenController,
              child: Container(
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
                            color: AppColors.placeHolder.withOpacity(0.95),
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
                            color: AppColors.placeHolder.withOpacity(0.95),
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
                      height: height * 0.045,
                    ),
                    Image.asset('assets/images/fusion.png',
                        height: height * 0.15),
                    SizedBox(
                      child: Icon(Icons.arrow_downward),
                      height: height * 0.045,
                    ),
                    InkWell(
                      onTap: () => _getImage(2),
                      child: Container(
                        height: height * 0.25,
                        width: width * 0.50,
                        color: AppColors.placeHolder.withOpacity(0.95),
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
              : mode == 3
              ? Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Screenshot(
                  controller: screenController,
                  child: Container(
                    width: constraints.maxWidth / 1.6,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        /// pick file
                        Positioned(
                          top: 60,
                          child: GestureDetector(
                            onTap: () => _getImage(0),
                            child: Container(
                              color: AppColors.placeHolder,
                              height: height * 0.3,
                              width: width * 0.65,
                              child: InteractiveViewer(
                                boundaryMargin: const EdgeInsets.all(20.0),
                                minScale: 1,
                                maxScale: 4,
                                child: imagePath.isEmpty
                                    ? Center(
                                    child: Text('Tap here to select image', style: TextStyle(
                                        fontFamily: 'Caps-1',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),))
                                    : Image.file(File(imagePath)),
                              ),
                            ),
                          ),
                        ),
                        /// scaffold
                        IgnorePointer(
                          ignoring: true,
                          child: Image.asset(_makerStorage.initType.image),
                        ),
                        /// name
                        Positioned(
                            top: 18,
                            left: 20,
                            child: InkWell(
                              onTap: () => editInput(wtf.name),
                              child: Text(
                                _makerStorage.name.toUpperCase(),
                                style: TextStyle(
                                    color: _makerStorage
                                        .initType.type == 8
                                        ? Colors.white70
                                        : Colors.black87,
                                    fontFamily: 'Caps-1',
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        /// level
                        _makerStorage.initType.type == 8
                            ? Positioned(
                          top: 41,
                          left: 24,
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
                                  height: 12,
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
                          top: 40,
                          right: 24,
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
                                        '[ spell card '
                                            .toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Image.asset(
                                          _makerStorage
                                              .initTrapSpellType
                                              .image,
                                          height: 14),
                                      Text(
                                        ' ]'.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                              buildListTrapSpellType(),
                            ],
                          ),
                        )
                            : _makerStorage.initType.type == 10
                            ? Positioned(
                          top: 41,
                          right: 24,
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
                                        '[ trap card '.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Image.asset(
                                          _makerStorage
                                              .initTrapSpellType
                                              .image,
                                          height: 14),
                                      Text(
                                        ' ]'.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                              buildListTrapSpellType(),
                            ],
                          ),
                        )
                            : Positioned(
                          top: 41,
                          right: 24,
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
                                  height: 12,
                                  child: ListView.builder(
                                      reverse: true,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                      _makerStorage.initLv,
                                      itemBuilder: (context, i) =>
                                          Image.asset(
                                              _makerStorage
                                                  .initImgLv)),
                                ),
                              ),
                              buildListLevel(),
                            ],
                          ),
                        ),
                        /// attribute
                        _makerStorage.initType.type == 9
                            ? SizedBox()
                            : _makerStorage.initType.type == 10
                            ? SizedBox()
                            : Positioned(
                            top: 16,
                            right: 16,
                            child: Stack(
                              children: [
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        attrShow = true;
                                      });
                                    },
                                    child: Image.asset(
                                      _makerStorage.initAttr.image,
                                      height: 21,
                                    )),
                                buildListAttr(),
                              ],
                            )),
                        /// card name/desc
                        Positioned(
                            bottom: 60,
                            left: 26,
                            child: InkWell(
                              onTap: () => editInput(wtf.cardType),
                              child: Text(
                                '[ ${_makerStorage.nameType.toLowerCase()} ]',
                                style: TextStyle(
                                    fontFamily: 'Caps-1',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Positioned(
                            bottom: 48,
                            left: 30,
                            child: InkWell(
                              onTap: () => editInput(wtf.desc),
                              child: Text(
                                _makerStorage.decs,
                                style: TextStyle(
                                    fontFamily: 'Caps-1',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        /// atk/def
                        Positioned(
                          bottom: 16,
                          right: 60,
                          child: InkWell(
                            onTap: () => editInput(wtf.atk),
                            child: Text('${_makerStorage.atk}',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Caps-1',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          right: 20,
                          child: InkWell(
                            onTap: () => editInput(wtf.def),
                            child: Text(
                              '${_makerStorage.def}',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Caps-1',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        /// num/year
                        Positioned(
                          bottom: 3,
                          right: 22,
                          child: InkWell(
                            onTap: () => editInput(wtf.year),
                            child: Text(
                              '${_makerStorage.year}',
                              style: TextStyle(
                                  color: _makerStorage
                                      .initType.type == 8
                                      ? Colors.white70
                                      : Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Caps-1',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 3,
                          left: 22,
                          child: InkWell(
                            onTap: () => _randomNumber(),
                            child: Text(
                              '${_makerStorage.number}',
                              style: TextStyle(
                                  color: _makerStorage
                                      .initType.type == 8
                                      ? Colors.white70
                                      : Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Caps-1',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
              : mode == 4
              ? Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Screenshot(
                  controller: screenController,
                  child: Container(
                    width: constraints.maxWidth / 1.6,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        /// pick file
                        Positioned(
                          top: 60,
                          child: GestureDetector(
                            onTap: () => _getImage(0),
                            child: Container(
                              color: AppColors.placeHolder,
                              height: height * 0.3,
                              width: width * 0.65,
                              child: InteractiveViewer(
                                boundaryMargin: const EdgeInsets.all(20.0),
                                minScale: 1,
                                maxScale: 4,
                                child: imagePath.isEmpty
                                    ? Center(
                                    child: Text('Tap here to select image', style: TextStyle(
                                        fontFamily: 'Caps-1',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),))
                                    : Image.file(File(imagePath)),
                              ),
                            ),
                          ),
                        ),
                        /// scaffold
                        IgnorePointer(
                          ignoring: true,
                          child: Image.asset(_makerStorage.initType.image),
                        ),
                        /// name
                        Positioned(
                            top: 18,
                            left: 20,
                            child: InkWell(
                              onTap: () => editInput(wtf.name),
                              child: Text(
                                _makerStorage.name.toUpperCase(),
                                style: TextStyle(
                                    color: _makerStorage
                                        .initType.type == 8
                                        ? Colors.white70
                                        : Colors.black87,
                                    fontFamily: 'Caps-1',
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        /// level
                        _makerStorage.initType.type == 8
                            ? Positioned(
                          top: 41,
                          left: 24,
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
                                  height: 12,
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
                          top: 40,
                          right: 24,
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
                                        '[ spell card '
                                            .toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Image.asset(
                                          _makerStorage
                                              .initTrapSpellType
                                              .image,
                                          height: 14),
                                      Text(
                                        ' ]'.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                              buildListTrapSpellType(),
                            ],
                          ),
                        )
                            : _makerStorage.initType.type == 10
                            ? Positioned(
                          top: 41,
                          right: 24,
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
                                        '[ trap card '.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Image.asset(
                                          _makerStorage
                                              .initTrapSpellType
                                              .image,
                                          height: 14),
                                      Text(
                                        ' ]'.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                              buildListTrapSpellType(),
                            ],
                          ),
                        )
                            : Positioned(
                          top: 41,
                          right: 24,
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
                                  height: 12,
                                  child: ListView.builder(
                                      reverse: true,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                      _makerStorage.initLv,
                                      itemBuilder: (context, i) =>
                                          Image.asset(
                                              _makerStorage
                                                  .initImgLv)),
                                ),
                              ),
                              buildListLevel(),
                            ],
                          ),
                        ),
                        /// attribute
                        _makerStorage.initType.type == 9
                            ? SizedBox()
                            : _makerStorage.initType.type == 10
                            ? SizedBox()
                            : Positioned(
                            top: 16,
                            right: 16,
                            child: Stack(
                              children: [
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        attrShow = true;
                                      });
                                    },
                                    child: Image.asset(
                                      _makerStorage.initAttr.image,
                                      height: 21,
                                    )),
                                buildListAttr(),
                              ],
                            )),
                        /// card name/desc
                        Positioned(
                            bottom: 60,
                            left: 26,
                            child: InkWell(
                              onTap: () => editInput(wtf.cardType),
                              child: Text(
                                '[ ${_makerStorage.nameType.toLowerCase()} ]',
                                style: TextStyle(
                                    fontFamily: 'Caps-1',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Positioned(
                            bottom: 48,
                            left: 30,
                            child: InkWell(
                              onTap: () => editInput(wtf.desc),
                              child: Text(
                                _makerStorage.decs,
                                style: TextStyle(
                                    fontFamily: 'Caps-1',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        /// atk/def
                        Positioned(
                          bottom: 16,
                          right: 60,
                          child: InkWell(
                            onTap: () => editInput(wtf.atk),
                            child: Text('${_makerStorage.atk}',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Caps-1',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          right: 20,
                          child: InkWell(
                            onTap: () => editInput(wtf.def),
                            child: Text(
                              '${_makerStorage.def}',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Caps-1',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        /// num/year
                        Positioned(
                          bottom: 3,
                          right: 22,
                          child: InkWell(
                            onTap: () => editInput(wtf.year),
                            child: Text(
                              '${_makerStorage.year}',
                              style: TextStyle(
                                  color: _makerStorage
                                      .initType.type == 8
                                      ? Colors.white70
                                      : Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Caps-1',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 3,
                          left: 22,
                          child: InkWell(
                            onTap: () => _randomNumber(),
                            child: Text(
                              '${_makerStorage.number}',
                              style: TextStyle(
                                  color: _makerStorage
                                      .initType.type == 8
                                      ? Colors.white70
                                      : Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Caps-1',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
              : Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Screenshot(
                  controller: screenController,
                  child: Container(
                    width: constraints.maxWidth / 1.6,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        /// pick file
                        Positioned(
                          top: 60,
                          child: GestureDetector(
                            onTap: () => _getImage(0),
                            child: Container(
                              color: AppColors.placeHolder,
                              height: height * 0.3,
                              width: width * 0.65,
                              child: InteractiveViewer(
                                boundaryMargin: const EdgeInsets.all(20.0),
                                minScale: 1,
                                maxScale: 4,
                                child: imagePath.isEmpty
                                    ? Center(
                                    child: Text('Tap here to select image', style: TextStyle(
                                        fontFamily: 'Caps-1',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),))
                                    : Image.file(File(imagePath)),
                              ),
                            ),
                          ),
                        ),
                        /// scaffold
                        IgnorePointer(
                          ignoring: true,
                          child: Image.asset(_makerStorage.initType.image),
                        ),
                        /// name
                        Positioned(
                            top: 18,
                            left: 20,
                            child: InkWell(
                              onTap: () => editInput(wtf.name),
                              child: Text(
                                _makerStorage.name.toUpperCase(),
                                style: TextStyle(
                                    color: _makerStorage
                                        .initType.type == 8
                                        ? Colors.white70
                                        : Colors.black87,
                                    fontFamily: 'Caps-1',
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        /// level
                        _makerStorage.initType.type == 8
                            ? Positioned(
                          top: 41,
                          left: 24,
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
                                  height: 12,
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
                          top: 40,
                          right: 24,
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
                                        '[ spell card '
                                            .toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Image.asset(
                                          _makerStorage
                                              .initTrapSpellType
                                              .image,
                                          height: 14),
                                      Text(
                                        ' ]'.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                              buildListTrapSpellType(),
                            ],
                          ),
                        )
                            : _makerStorage.initType.type == 10
                            ? Positioned(
                          top: 41,
                          right: 24,
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
                                        '[ trap card '.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Image.asset(
                                          _makerStorage
                                              .initTrapSpellType
                                              .image,
                                          height: 14),
                                      Text(
                                        ' ]'.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                              buildListTrapSpellType(),
                            ],
                          ),
                        )
                            : Positioned(
                          top: 41,
                          right: 24,
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
                                  height: 12,
                                  child: ListView.builder(
                                      reverse: true,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                      _makerStorage.initLv,
                                      itemBuilder: (context, i) =>
                                          Image.asset(
                                              _makerStorage
                                                  .initImgLv)),
                                ),
                              ),
                              buildListLevel(),
                            ],
                          ),
                        ),
                        /// attribute
                        _makerStorage.initType.type == 9
                            ? SizedBox()
                            : _makerStorage.initType.type == 10
                            ? SizedBox()
                            : Positioned(
                            top: 16,
                            right: 16,
                            child: Stack(
                              children: [
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        attrShow = true;
                                      });
                                    },
                                    child: Image.asset(
                                      _makerStorage.initAttr.image,
                                      height: 21,
                                    )),
                                buildListAttr(),
                              ],
                            )),
                        /// card name/desc
                        Positioned(
                            bottom: 60,
                            left: 26,
                            child: InkWell(
                              onTap: () => editInput(wtf.cardType),
                              child: Text(
                                '[ ${_makerStorage.nameType.toLowerCase()} ]',
                                style: TextStyle(
                                    fontFamily: 'Caps-1',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Positioned(
                            bottom: 48,
                            left: 30,
                            child: InkWell(
                              onTap: () => editInput(wtf.desc),
                              child: Text(
                                _makerStorage.decs,
                                style: TextStyle(
                                    fontFamily: 'Caps-1',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        /// atk/def
                        Positioned(
                          bottom: 16,
                          right: 60,
                          child: InkWell(
                            onTap: () => editInput(wtf.atk),
                            child: Text('${_makerStorage.atk}',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Caps-1',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          right: 20,
                          child: InkWell(
                            onTap: () => editInput(wtf.def),
                            child: Text(
                              '${_makerStorage.def}',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Caps-1',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        /// num/year
                        Positioned(
                          bottom: 3,
                          right: 22,
                          child: InkWell(
                            onTap: () => editInput(wtf.year),
                            child: Text(
                              '${_makerStorage.year}',
                              style: TextStyle(
                                  color: _makerStorage
                                      .initType.type == 8
                                      ? Colors.white70
                                      : Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Caps-1',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 3,
                          left: 22,
                          child: InkWell(
                            onTap: () => _randomNumber(),
                            child: Text(
                              '${_makerStorage.number}',
                              style: TextStyle(
                                  color: _makerStorage
                                      .initType.type == 8
                                      ? Colors.white70
                                      : Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Caps-1',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          /// btn save
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              height: 30,
              width: 60,
              decoration: BoxDecoration(
                color: AppColors.dropdownButton.withOpacity(0.6),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                    color: Colors.black, style: BorderStyle.solid, width: 2.2),
              ),
              child: TextButton(
                onPressed: () => imagePath.isNotEmpty ? _save() : {},
                child: Text("Save",
                    style: TextStyle(fontFamily: 'Caps-1', fontSize: 24/2,
                        fontWeight: FontWeight.w600, color: imagePath.isNotEmpty ? Colors.black : Colors.black38)),
              ),
            ),
          ),
          /// theme select
          mode == 1 ? SizedBox()
              : mode == 2 ? SizedBox()
              : Expanded(
                child: Container(
            color: Colors.white.withOpacity(0.4),
            width: double.infinity,
            child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _makerStorage.cardType.length,
                  itemBuilder: (context, index) {
                    final item = _makerStorage.cardType[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _makerStorage.initType = item;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 30,
                                  height: 50,
                                  color: Colors.white,
                                ),
                                Image.asset(item.image, width: 35),
                              ],
                            ),
                            Text(item.name,
                              style: TextStyle(
                                  fontFamily: 'Caps-1',
                                  fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
          ),
              )
        ],
      ),
    );
  }
}

