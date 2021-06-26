import 'package:flutter/material.dart';
import 'package:yugioh_maker/provider/provider.dart';
import 'page/page.dart';

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

class SelectMode extends StatelessWidget {
  const SelectMode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MakerPage(
                                mode: 0,
                                images: [],
                              )));
                },
                child: Text('Normal')),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MakerPage(
                                mode: 1,
                                images: [],
                              )));
                },
                child: Text('The forbidden one')),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MakerPage(
                                mode: 2,
                                images: [],
                              )));
                },
                child: Text('Meme fusion')),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MakerPage(
                                mode: 3,
                                images: [],
                              )));
                },
                child: Text('3 card')),
          ],
        ),
      ),
    );
  }
}
