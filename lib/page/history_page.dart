part of 'page.dart';

class HistoryPage extends StatefulWidget {
  final HistoryStorage storage;

  const HistoryPage({Key? key, required this.storage}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _makerStorage = MakerStorage();

  var _items = <History>[];
  var _selectedItem = <History>[];
  late double height, width;
  bool _isLargerScreen = false;
  bool _isMultiSelect = false;
  bool _isSelected = false;

  @override
  void initState() {
    _getList();
    super.initState();
  }

  void _getList() {
    widget.storage.getListHistory().then((value) {
      setState(() {
        _items = value.map((e) => History.fromJson(e)).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final listTheme = _makerStorage.cardType;
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
              appBar: AppBar(
                centerTitle: true,
                title: !_isMultiSelect
                    ? Text('collection'.toUpperCase(), style: TextStyle(fontFamily: 'Caps-1', fontSize: 30, color: Colors.black87),)
                    : Text('${_selectedItem.length} selected'.toUpperCase(), style: TextStyle(fontFamily: 'Caps-1', fontSize: 26, color: Colors.black87),),
                backgroundColor: Colors.white.withOpacity(0.3),
                elevation: 0.5,
                leading: TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Image.asset('assets/images/btn_back.png', width: 30,),
                    label: Text('')),
                actions: [
                  _isMultiSelect ?
                  TextButton.icon(
                      onPressed: () {
                        setState(() {
                          for(var item in _selectedItem) {
                            _items.removeWhere((element) => element == item);
                          }
                          widget.storage.updateHistory(_items.map((e) => e.toJson()).toList());
                          _selectedItem.clear();
                          _isMultiSelect = false;
                        });
                      },
                      icon: Icon(Icons.delete, size: 30, color: Colors.black,),
                      label: Text('')) : SizedBox()
                ],
              ),
              backgroundColor: Colors.transparent,
              body: OrientationBuilder(
                builder: (ctx, orientation) {
                  if (width > 400) {
                    _isLargerScreen = true;
                  } else {
                    _isLargerScreen = false;
                  }
                  return _isLargerScreen ? _buildMediumScreen(listTheme) : _buildSmallScreen(listTheme);
                },
              )
          ),
        ),
    );
  }

  _buildMediumScreen(List<CardType> listTheme) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(14),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: listTheme.length,
            itemBuilder: (ctx, index) {
              final theme = listTheme[index];
              /// grouped theme list item
              var grList = <History>[];
              for(var item in _items) {
                if(item.type == theme.type) {
                  grList.add(item);
                }
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${theme.name} (${grList.length})', style: TextStyle(fontFamily: 'Caps-1', fontSize: 38),),
                  grList.isNotEmpty
                      ? Container(
                    height: height * 0.160,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: grList.length,
                        itemBuilder: (ctx, i) {
                          final card = grList[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: InkWell(
                              onTap: () {
                                if(_isMultiSelect == true) {
                                  setState(() {
                                    _isSelected = !_isSelected;
                                    if(_isSelected == true) {
                                      _selectedItem.add(card);
                                    } else {
                                      _selectedItem.removeWhere((element) => element == card);
                                    }
                                  });
                                } else {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Overwrite current card!"),
                                      content:
                                      Text("Your current card will be replacement by this card!"),
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
                                            Navigator.pop(context);
                                            Navigator.pop(context, History(
                                                cardType: card.cardType,
                                                type: card.type,
                                                attr: card.attr,
                                                level: card.level,
                                                name: card.name,
                                                image: card.image != null ? '${card.image}' : null,
                                                trapSpellType: card.trapSpellType,
                                                nameType: card.nameType,
                                                desc: card.desc,
                                                serialNumber: card.serialNumber,
                                                year: card.year,
                                                atk: card.atk,
                                                def: card.def));
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                }
                              },
                              onLongPress: () {
                                setState(() {
                                  _isMultiSelect = !_isMultiSelect;
                                  if(_isMultiSelect == true) {
                                    _selectedItem.add(card);
                                  } else {
                                    _selectedItem.clear();
                                  }
                                });
                              },
                              child: Container(
                                height: double.infinity,
                                width: width * 0.22,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 4,
                                        color: _selectedItem.contains(card)
                                            ? Colors.yellow
                                            : Colors.transparent)),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    /// pick file
                                    Positioned(
                                      top: 10,
                                      child: Container(
                                        color: Colors.white,
                                        height: height * 0.1,
                                        width: width * 0.3,
                                        child: InteractiveViewer(
                                          panEnabled: false,
                                          child: card.image != null ? Image.file(File(card.image!)) : SizedBox(),
                                        ),
                                      ),
                                    ),
                                    /// scaffold
                                    Image.asset(card.cardType),
                                    /// name
                                    Positioned(
                                        top: 11,
                                        left: 10,
                                        child: Text(
                                          card.name.toUpperCase(),
                                          style: TextStyle(
                                              color: card.type == 8
                                                  ? Colors.white70
                                                  : Colors.black87,
                                              fontFamily: 'Caps-1',
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    /// level
                                    card.type == 8
                                        ? Positioned(
                                      top: 21,
                                      left: 8,
                                      child: SizedBox(
                                        height: 5,
                                        child: ListView.builder(
                                            reverse: true,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: card.level,
                                            itemBuilder: (context, i) => Image.asset('assets/images/rank.png')),
                                      ),
                                    )
                                        : card.type == 9
                                        ? Positioned(
                                      top: 21,
                                      right: 8,
                                      child: Row(
                                        children: [
                                          Text(
                                            '[spell card '.toUpperCase(),
                                            style: TextStyle(
                                                fontFamily: 'Caps-1',
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Image.asset(card.trapSpellType!, height: 5),
                                          Text(
                                            ']'.toUpperCase(),
                                            style: TextStyle(
                                                fontFamily: 'Caps-1',
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    )
                                        : card.type == 10
                                        ? Positioned(
                                      top: 21,
                                      right: 8,
                                      child: Row(
                                        children: [
                                          Text(
                                            '[trap card '.toUpperCase(),
                                            style: TextStyle(
                                                fontFamily: 'Caps-1',
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Image.asset(card.trapSpellType!, height: 5),
                                          Text(
                                            ']'.toUpperCase(),
                                            style: TextStyle(
                                                fontFamily: 'Caps-1',
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    )
                                        : Positioned(
                                      top: 21,
                                      right: 8,
                                      child: SizedBox(
                                        height: 5,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            reverse: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: card.level,
                                            itemBuilder: (context, i) => Image.asset('assets/images/level.png')),
                                      ),
                                    ),
                                    /// attribute
                                    card.type == 9
                                        ? SizedBox()
                                        : card.type == 10
                                        ? SizedBox()
                                        : Positioned(
                                        top: 11,
                                        right: 8,
                                        child: Image.asset(card.attr, height: 9)
                                    ),
                                    /// card name/desc
                                    Positioned(
                                        bottom: 28,
                                        left: 10,
                                        child: Text(
                                          '[ ${card.nameType.toLowerCase()} ]',
                                          style: TextStyle(
                                              fontFamily: 'Caps-1',
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        )
                                    ),
                                    Positioned(
                                        bottom: 20,
                                        left: 10,
                                        child: Container(
                                          width: 50,
                                          child: Text(
                                            card.desc,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: 'Caps-1',
                                                fontSize: 8,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                      : SizedBox()
                ],
              );
            }),
      ),
    );
  }

  _buildSmallScreen(List<CardType> listTheme) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(14),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: listTheme.length,
            itemBuilder: (ctx, index) {
              final theme = listTheme[index];
              /// grouped theme list item
              var grList = <History>[];
              for(var item in _items) {
                if(item.type == theme.type) {
                  grList.add(item);
                }
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${theme.name} (${grList.length})', style: TextStyle(fontFamily: 'Caps-1', fontSize: 38),),
                  grList.isNotEmpty
                      ? Container(
                    height: height * 0.160,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: grList.length,
                        itemBuilder: (ctx, i) {
                          final card = grList[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: InkWell(
                              onTap: () {
                                if(_isMultiSelect == true) {
                                  setState(() {
                                    _isSelected = !_isSelected;
                                    if(_isSelected == true) {
                                      _selectedItem.add(card);
                                    } else {
                                      _selectedItem.removeWhere((element) => element == card);
                                    }
                                  });
                                } else {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Overwrite current card!"),
                                      content:
                                      Text("Your current card will be replacement by this card!"),
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
                                            Navigator.pop(context);
                                            Navigator.pop(context, History(
                                                cardType: card.cardType,
                                                type: card.type,
                                                attr: card.attr,
                                                level: card.level,
                                                name: card.name,
                                                image: card.image != null ? '${card.image}' : null,
                                                trapSpellType: card.trapSpellType,
                                                nameType: card.nameType,
                                                desc: card.desc,
                                                serialNumber: card.serialNumber,
                                                year: card.year,
                                                atk: card.atk,
                                                def: card.def));
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                }
                              },
                              onLongPress: () {
                                setState(() {
                                  _isMultiSelect = !_isMultiSelect;
                                  if(_isMultiSelect == true) {
                                    _selectedItem.add(card);
                                  } else {
                                    _selectedItem.clear();
                                  }
                                });
                              },
                              child: Container(
                                height: double.infinity,
                                width: width * 0.22,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 4,
                                        color: _selectedItem.contains(card)
                                            ? Colors.yellow
                                            : Colors.transparent)),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    /// pick file
                                    Positioned(
                                      top: 10,
                                      child: Container(
                                        color: Colors.white,
                                        height: height * 0.1,
                                        width: 50,
                                        child: InteractiveViewer(
                                          panEnabled: false,
                                          child: card.image != null ? Image.file(File(card.image!)) : SizedBox(),
                                        ),
                                      ),
                                    ),
                                    /// scaffold
                                    Image.asset(card.cardType),
                                    /// name
                                    Positioned(
                                        top: 4,
                                        left: 10,
                                        child: Text(
                                          card.name.toUpperCase(),
                                          style: TextStyle(
                                              color: card.type == 8
                                                  ? Colors.white70
                                                  : Colors.black87,
                                              fontFamily: 'Caps-1',
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    /// level
                                    card.type == 8
                                        ? Positioned(
                                      top: 11,
                                      left: 11,
                                      child: SizedBox(
                                        height: 3,
                                        child: ListView.builder(
                                            reverse: true,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: card.level,
                                            itemBuilder: (context, i) => Image.asset('assets/images/rank.png')),
                                      ),
                                    )
                                        : card.type == 9
                                        ? Positioned(
                                      top: 11,
                                      right: 11,
                                      child: Row(
                                        children: [
                                          Text(
                                            '[spell card '.toUpperCase(),
                                            style: TextStyle(
                                                fontFamily: 'Caps-1',
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Image.asset(card.trapSpellType!, height: 3),
                                          Text(
                                            ']'.toUpperCase(),
                                            style: TextStyle(
                                                fontFamily: 'Caps-1',
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    )
                                        : card.type == 10
                                        ? Positioned(
                                      top: 11,
                                      right: 11,
                                      child: Row(
                                        children: [
                                          Text(
                                            '[trap card '.toUpperCase(),
                                            style: TextStyle(
                                                fontFamily: 'Caps-1',
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Image.asset(card.trapSpellType!, height: 3),
                                          Text(
                                            ']'.toUpperCase(),
                                            style: TextStyle(
                                                fontFamily: 'Caps-1',
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    )
                                        : Positioned(
                                      top: 11,
                                      right: 11,
                                      child: SizedBox(
                                        height: 3,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            reverse: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: card.level,
                                            itemBuilder: (context, i) => Image.asset('assets/images/level.png')),
                                      ),
                                    ),
                                    /// attribute
                                    card.type == 9
                                        ? SizedBox()
                                        : card.type == 10
                                        ? SizedBox()
                                        : Positioned(
                                        top: 4,
                                        right: 10,
                                        child: Image.asset(card.attr, height: 7)
                                    ),
                                    /// card name/desc
                                    Positioned(
                                        bottom: 15,
                                        left: 11,
                                        child: Text(
                                          '[ ${card.nameType.toLowerCase()} ]',
                                          style: TextStyle(
                                              fontFamily: 'Caps-1',
                                              fontSize: 5,
                                              fontWeight: FontWeight.bold),
                                        )
                                    ),
                                    Positioned(
                                        bottom: 12,
                                        left: 13,
                                        child: Container(
                                          width: 50,
                                          child: Text(
                                            card.desc,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: 'Caps-1',
                                                fontSize: 4,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                      : SizedBox()
                ],
              );
            }),
      ),
    );
  }
}
