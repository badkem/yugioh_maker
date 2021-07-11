part of 'page.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late Box<History> dataBox;

  @override
  void initState() {
    dataBox = Hive.box<History>(dataBoxName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ValueListenableBuilder(
          valueListenable: dataBox.listenable(),
          builder: (ctx, Box<History> items, _) {
            List<int> keys = items.keys.cast<int>().toList();
            final test = items.values.toList();
            print(test.length);
            return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: keys.length,
                itemBuilder: (ctx, i) {
                  final key = keys[i];
                  final item = items.getAt(key);
                  Uint8List bytes = base64Decode(item!.base64Image);
                  return Image.memory(bytes, width: 150, height: 200,);
                });
          },
        ),
      )
    );
  }
}
