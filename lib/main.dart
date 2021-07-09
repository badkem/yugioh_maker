import 'package:flutter/material.dart';
import 'package:yugioh_maker/model/model.dart';
import 'package:yugioh_maker/page/page.dart';
import 'package:yugioh_maker/page/theme/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SelectMode(),
    );
  }
}

class SelectMode extends StatefulWidget {
  const SelectMode({Key? key}) : super(key: key);

  @override
  _SelectModeState createState() => _SelectModeState();
}

class _SelectModeState extends State<SelectMode> {
  late double height, width;
  bool isLargerScreen = false;

  List<Mode> _dropdownItems = [
    Mode(0, 'Normal'),
    Mode(1, 'Exodia'),
    Mode(2, 'Meme fusion'),
    Mode(3, '3 cards'),
    Mode(4, '3 cards stack'),
  ];
  List<DropdownMenuItem<Mode>>? _dropdownMenuItems;
  Mode? _selectedItem;

  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _selectedItem = _dropdownMenuItems![0].value;
  }

  List<DropdownMenuItem<Mode>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<Mode>> items = [];
    for (Mode listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name,
              style: TextStyle(fontFamily: 'Caps-1', fontSize: 25, fontWeight: FontWeight.w600)),
          value: listItem,
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return OrientationBuilder(builder: (ctx, orientation) {
      if (width > 400) {
        isLargerScreen = true;
      } else {
        isLargerScreen = false;
      }
      return isLargerScreen ? _buildMediumLayout() : _buildSmallLayout();
    });
  }

  _buildMediumLayout() {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/background.png')
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('assets/images/yuji.png', fit: BoxFit.contain,),
                Text('Card Maker', style: TextStyle(fontFamily: 'Caps-1', fontSize: 55),),
                Text('Select mode', style: TextStyle(fontFamily: 'Caps-1', fontSize: 30),),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: AppColors.dropdownButton.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.black, style: BorderStyle.solid, width: 2.2),
                  ),
                  child: DropdownButton<Mode>(
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 30,),
                    dropdownColor: Colors.white,
                    value: _selectedItem,
                    onChanged: (value) {
                      setState(() {
                        _selectedItem = value;
                      });
                    },
                    items: _dropdownMenuItems,
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: AppColors.dropdownButton.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.black, style: BorderStyle.solid, width: 2.2),
                  ),
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) => MakerPage(
                              mode: _selectedItem!.mode, cards: [],)));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Let's Go",
                              style: TextStyle(fontFamily: 'Caps-1', fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black)),
                          SizedBox(width: 30,),
                          Icon(Icons.arrow_forward, color: Colors.black, size: 25,),
                        ],
                      )
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => TestPage()));
                    },
                    child: Text('Test page'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildSmallLayout() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/background.png')
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('assets/images/yuji.png', fit: BoxFit.contain, width: width * 0.8,),
                Text('Card Maker', style: TextStyle(fontFamily: 'Caps-1', fontSize: 55),),
                Text('Select mode', style: TextStyle(fontFamily: 'Caps-1', fontSize: 30),),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: AppColors.dropdownButton.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.black, style: BorderStyle.solid, width: 2.2),
                  ),
                  child: DropdownButton<Mode>(
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 30,),
                    dropdownColor: Colors.white,
                    value: _selectedItem,
                    onChanged: (value) {
                      setState(() {
                        _selectedItem = value;
                      });
                    },
                    items: _dropdownMenuItems,
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: AppColors.dropdownButton.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.black, style: BorderStyle.solid, width: 2.2),
                  ),
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) => MakerPage(
                              mode: _selectedItem!.mode, cards: [],)));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Let's Go",
                              style: TextStyle(fontFamily: 'Caps-1', fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black)),
                          SizedBox(width: 30,),
                          Icon(Icons.arrow_forward, color: Colors.black, size: 25,),
                        ],
                      )
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => TestPage()));
                    },
                    child: Text('Test page'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
