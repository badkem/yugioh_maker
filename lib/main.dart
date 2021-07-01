import 'package:flutter/material.dart';
import 'package:yugioh_maker/model/model.dart';
import 'package:yugioh_maker/page/page.dart';

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
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Select mode what you want!', style: TextStyle(fontSize: 16),),
            SizedBox(height: 20,),
            DropdownButton<Mode>(
              value: _selectedItem,
              onChanged: (value) {
                setState(() {
                  _selectedItem = value;
                });
              },
              items: _dropdownMenuItems,
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => MakerPage(
                          mode: _selectedItem!.mode, cards: [],)));
                },
                child: Text('Go')),
            // TextButton(
            //     onPressed: () {
            //       Navigator.push(context,
            //           MaterialPageRoute(builder: (ctx) => TestPage()));
            //     },
            //     child: Text('Test page'))
          ],
        ),
      ),
    );
  }
}
