part of 'page.dart';

class HistoryPage extends StatefulWidget {

  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Box<History> dataBox;
  final _makerStorage = MakerStorage();

  var _selectedItem = <History>[];
  late double height, width;
  bool _isMultiSelect = false;
  bool _isSelected = false;
  var listSelect = <bool>[];

  @override
  void initState() {
    dataBox = Hive.box<History>(dataBoxName);
    super.initState();
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
          child: ValueListenableBuilder(
            valueListenable: dataBox.listenable(),
            builder: (ctx, Box<History> items, _) {
              final _items = items.values.toList();
              return Scaffold(
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
                          final Map<dynamic, History> historyMap = dataBox.toMap();
                          historyMap.forEach((key, value) {
                            for(var item in _selectedItem) {
                              if(item == value)
                                dataBox.delete(key);
                            }
                          });
                          setState(() {
                            _selectedItem.clear();
                            _isMultiSelect = false;
                          });
                        },
                        icon: Icon(Icons.delete, size: 30, color: Colors.black,),
                        label: Text('')) : SizedBox()
                  ],
                ),
                backgroundColor: Colors.transparent,
                body: SafeArea(
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
                                      Uint8List bytes = base64Decode(card.base64Image);
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: InkWell(
                                          onTap: () {
                                            if(_isMultiSelect == true) {
                                              setState(() {
                                                _isSelected = !_isSelected;
                                                print(_isSelected);
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
                                                            image: card.image,
                                                            base64Image: '',
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
                                                    width: 3,
                                                    color: _selectedItem.contains(card)
                                                        ? Colors.yellow
                                                        : Colors.transparent)),
                                            child: Image.memory(bytes, gaplessPlayback: true,),
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
                ),
              );
            },
          ),
        ),
    );
  }

  _test(History card, Uint8List bytes) {
    return InkWell(
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
                        image: card.image,
                        base64Image: '',
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
        child: Image.memory(bytes, gaplessPlayback: true,),
      ),
    );
  }
}
