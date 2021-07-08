part of 'page.dart';

class HistoryPage extends StatefulWidget {
  final HistoryStorage storage;

  const HistoryPage({Key? key, required this.storage}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _makerStorage = MakerStorage();

  var items = <History>[];
  late double height, width;
  bool isLargerScreen = false;
  dynamic focus;

  @override
  void initState() {
    getList();
    super.initState();
  }

  void getList() {
    widget.storage.getListHistory().then((value) {
      setState(() {
        items = value.map((e) => History.fromJson(e)).toList();
      });
      print(items.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final listTheme = _makerStorage.cardType;
    return Stack(
      children: [
        Image.asset('assets/images/background.png', fit: BoxFit.cover,),
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('collection'.toUpperCase(), style: TextStyle(fontFamily: 'Caps-1', fontSize: 30, color: Colors.black87),),
            backgroundColor: Colors.white.withOpacity(0.3),
            elevation: 0.5,
            leading: TextButton.icon(
                onPressed: () {},
                icon: Image.asset('assets/images/btn_back.png', width: 30,),
                label: Text('')),
          ),
          backgroundColor: Colors.transparent,
          body: OrientationBuilder(
            builder: (ctx, orientation) {
              if (width > 400) {
                isLargerScreen = true;
              } else {
                isLargerScreen = false;
              }
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
                        for(var item in items) {
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
                                        },
                                        onLongPress: () {
                                          setState(() {
                                            focus = card;
                                          });
                                        },
                                        child: Container(
                                          height: double.infinity,
                                          width: width * 0.22,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 4,
                                                  color: focus == card
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
                                                left: 10,
                                                child: SizedBox(
                                                  height: 6,
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
                                                right: 10,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '[spell card '.toUpperCase(),
                                                      style: TextStyle(
                                                          fontFamily: 'Caps-1',
                                                          color: Colors.black54,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                    Image.asset(card.trapSpellType!, height: 6),
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
                                                right: 10,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '[trap card '.toUpperCase(),
                                                      style: TextStyle(
                                                          fontFamily: 'Caps-1',
                                                          color: Colors.black54,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                    Image.asset(card.trapSpellType!, height: 6),
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
                                                right: 10,
                                                child: SizedBox(
                                                  height: 6,
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
            },
          )
        )
      ],
    );
  }

  Widget _buildBody(History item) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
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
                      Navigator.pop(
                          context,
                          History(
                              cardType: item.cardType,
                              type: item.type,
                              attr: item.attr,
                              level: item.level,
                              name: item.name,
                              image:
                                  item.image != null ? '${item.image}' : null,
                              trapSpellType: item.trapSpellType,
                              nameType: item.nameType,
                              desc: item.desc,
                              serialNumber: item.serialNumber,
                              year: item.year,
                              atk: item.atk,
                              def: item.def));
                    },
                  )
                ],
              ),
            );
          },
          child: SizedBox(
            child: Stack(
              children: [
                //Scaffold
                Image.asset(item.cardType),
                //Image
                Positioned(
                  left: isLargerScreen ? 25 : 20,
                  bottom: isLargerScreen ? 82 : 70,
                  child: SizedBox(
                    height: isLargerScreen ? 145 : 126,
                    width: isLargerScreen ? 145 : 126,
                    child: item.image == null
                        ? SizedBox()
                        : Image.file(File(item.image!), fit: BoxFit.fill),
                  ),
                ),
                //name
                Positioned(
                    top: isLargerScreen ? 20 : 18,
                    left: isLargerScreen ? 25 : 20,
                    child: Text(
                      item.name.toUpperCase(),
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: isLargerScreen ? 12 : 8),
                    )),
                //Level
                item.type == 8
                    ? Positioned(
                        top: isLargerScreen ? 40 : 35,
                        left: isLargerScreen ? 20 : 16,
                        child: SizedBox(
                          height: 12,
                          child: ListView.builder(
                              reverse: true,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: item.level,
                              itemBuilder: (context, i) =>
                                  Image.asset('assets/images/rank.png')),
                        ),
                      )
                    : item.type == 9
                        ? Positioned(
                            top: isLargerScreen ? 40 : 35,
                            right: isLargerScreen ? 20 : 16,
                            child: Row(
                              children: [
                                Text(
                                  '[spell card '.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                                ),
                                Image.asset(
                                  item.trapSpellType!,
                                  height: 12,
                                  width: 12,
                                ),
                                Text(
                                  ']'.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        : item.type == 10
                            ? Positioned(
                                top: isLargerScreen ? 40 : 35,
                                right: isLargerScreen ? 20 : 16,
                                child: Row(
                                  children: [
                                    Text(
                                      '[trap card '.toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Image.asset(
                                      item.trapSpellType!,
                                      height: 12,
                                      width: 12,
                                    ),
                                    Text(
                                      ']'.toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )
                            : Positioned(
                                top: isLargerScreen ? 40 : 35,
                                right: isLargerScreen ? 20 : 16,
                                child: SizedBox(
                                  height: 12,
                                  child: ListView.builder(
                                      reverse: true,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: item.level,
                                      itemBuilder: (context, i) => Image.asset(
                                          'assets/images/level.png')),
                                ),
                              ),
                //Attribute
                Positioned(
                  top: 15,
                  right: 20,
                  child: Image.asset(item.attr, height: isLargerScreen ? 20 : 16),
                ),
                //Name type
                Positioned(
                  bottom: isLargerScreen ? 50 : 45,
                  left: 20,
                  child: Text(
                    '[${item.nameType.toLowerCase()}]',
                    style: TextStyle(
                        fontSize: isLargerScreen ? 12 : 10,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                //Card desc
                Positioned(
                  bottom: isLargerScreen ? 40 : 35,
                  left: isLargerScreen ? 25 : 20,
                  child: Text(
                    item.desc,
                    style: TextStyle(
                        fontSize: isLargerScreen ? 10 : 8,
                        color: Colors.black54,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                //Divider
                Positioned(
                    bottom: 20,
                    left: isLargerScreen ? 18 : 14,
                    child: Container(
                      width: isLargerScreen ? 160 : 140,
                      child: Divider(
                        color: Colors.black,
                      ),
                    )),
                //ATK/DEF
                Positioned(
                  bottom: 16,
                  right: 30,
                  child: Row(
                    children: [
                      Text(
                        'ATK/${item.atk}'.toUpperCase(),
                        style: TextStyle(
                            fontSize: 8,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'DEF/${item.def}'.toUpperCase(),
                        style: TextStyle(
                            fontSize: 8,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                //Year
                Positioned(
                  bottom: isLargerScreen ? 4 : 2,
                  right: 16,
                  child: Text(
                    '@${item.year}',
                    style: TextStyle(
                        fontSize: 8,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                //Serial number
                Positioned(
                  bottom: isLargerScreen ? 4 : 2,
                  left: 16,
                  child: Text(
                    '${item.serialNumber}',
                    style: TextStyle(
                        fontSize: 8,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        TextButton.icon(
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Delete selected card!"),
                  content: Text("Your selected card will be delete!"),
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
                        setState(() {
                          items.remove(item);
                        });
                        widget.storage.updateHistory(
                            items.map((e) => e.toJson()).toList());
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              );
            },
            icon: Icon(Icons.delete),
            label: Text(''))
      ],
    );
  }
}
