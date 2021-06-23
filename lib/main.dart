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
      home: ModePage(),
    );
  }
}

class ModePage extends StatelessWidget {
  const ModePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MakerPage(storage: HistoryStorage(),)
                  ));
                },
                child: Text('Normal')),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MemePage()
                      ));
                },
                child: Text('Meme Fusion')),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ExodiaPage()
                      ));
                },
                child: Text('The Forbidden One')),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ThreeCardPage(storage: HistoryStorage(),)
                      ));
                },
                child: Text('Three Card')),
          ],
        ),
      ),
    );
  }
}


