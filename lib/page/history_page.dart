
part of 'page.dart';

class HistoryPage extends StatefulWidget {
  final HistoryStorage storage;
  const HistoryPage({Key? key, required this.storage}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  var items = <History>[];
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: items.isNotEmpty
          ? SafeArea(
            child: Container(
              child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 8),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 3 / 5.4,
                  crossAxisCount: 2,
                  crossAxisSpacing: 10
              ),
              itemCount: items.length,
              itemBuilder: (context, i){
                final item = items[i];
                return _buildBody(item);
              }),
            ),
          )
          : Center(
          child: Text('No history found!')),
    );
  }

  Widget _buildBody(History item) {
    return Column(
      children: [
        SizedBox(
          child: Stack(
            children: [
              //Scaffold
              Image.asset(item.cardType),
              //Image
              Positioned(
                left: 25,
                bottom: 82,
                child: SizedBox(
                  height: 144,
                  width: 144,
                  child: item.image == null
                      ? SizedBox()
                      : Image.file(
                    File(item.image!),
                    width: 144,
                    height: 144,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              //name
              Positioned(
                  top: 20,
                  left: 25,
                  child: Text(
                    item.name.toUpperCase(),
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  )),
              //Level
              item.type == 8
              ? Positioned(
                top: 40,
                left: 20,
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
                top: 40,
                right: 20,
                child: Row(
                  children: [
                    Text(
                      '[spell card '.toUpperCase(),
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ),
                    Image.asset(item.trapSpellType!, height: 12, width: 12,),
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
                top: 40,
                right: 20,
                child: Row(
                  children: [
                    Text(
                      '[trap card '.toUpperCase(),
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ),
                    Image.asset(item.trapSpellType!, height: 12, width: 12,),
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
                top: 40,
                right: 20,
                child: SizedBox(
                  height: 12,
                  child: ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: item.level,
                      itemBuilder: (context, i) =>
                          Image.asset('assets/images/level.png')),
                ),
              ),
              //Attribute
              Positioned(
                top: 15,
                right: 20,
                child: Image.asset(
                  item.attr,
                  width: 20,
                  height: 20,
                ),),
              //Name type
              Positioned(
                bottom: 50,
                left: 20,
                child: Text(
                  '[${item.nameType.toLowerCase()}]',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                ),),
              //Card desc
              Positioned(
                bottom: 40,
                left: 25,
                child: Text(
                  item.desc,
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400),
                ),),
              //Divider
              Positioned(
                  bottom: 20,
                  left: 18,
                  child: Container(
                    width: 160,
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
                bottom: 4,
                right: 16,
                child: Text(
                  '@${item.year}',
                  style: TextStyle(
                      fontSize: 8,
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              //Serial number
              Positioned(
                bottom: 4,
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
        TextButton.icon(
            onPressed: (){
              setState(() {
                items.remove(item);
              });
            widget.storage.updateHistory(items.map((e) => e.toJson()).toList());
            },
            icon: Icon(Icons.delete),
            label: Text(''))
      ],
    );
}
}
