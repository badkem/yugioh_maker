part of 'page.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
  final List<int> degrees = [-4, 0, 8];
  // final cards = <YugiohCard>[
  //   YugiohCard(image: 'assets/images/card_type/1.gif', degree: -4, height: 200, width: 100),
  //   YugiohCard(image: 'assets/images/card_type/2.gif', degree: 0, height: 200, width: 100),
  //   YugiohCard(image: 'assets/images/card_type/3.gif', degree: 8, height: 200, width: 100),
  // ];

  double angle = 0.0;
  double width = 150;
  double height = 200;
  double dg = 0.0;


  void _onScaleUpdateHandler(ScaleUpdateDetails details) {
    setState(() {
      angle = details.rotation;
      height = 200 * details.scale.clamp(0.7, 1.3);
      width = 150 * details.scale.clamp(0.7, 1.3);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Align(
            //   widthFactor: 0.5,
            //   child: RotationTransition(
            //     turns: AlwaysStoppedAnimation(
            //         widget.degrees[0] / 360),
            //     child: Image.memory(
            //       widget.images[0],
            //       width: width * 0.3,
            //     ),
            //   ),
            // ),
            Container(
                width: 200,
                height: 200,
                child: Stack(
                  children: [
                    Image.asset('assets/images/card_type/1.gif'),
                    Image.asset('assets/images/card_type/1.gif',
                      color: Colors.red.withOpacity(0.4),)
                  ],
                )),
            Align(
              widthFactor: 0.5,
              child: InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(20.0),
                minScale: 0.1,
                maxScale: 4,
                child: Container(
                  height: 150,
                  width: 100,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[Colors.orange, Colors.red],
                      stops: <double>[0.0, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              widthFactor: 0.5,
              child: InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(20.0),
                minScale: 0.1,
                maxScale: 4,
                child: Container(
                  height: 150,
                  width: 100,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[Colors.blue, Colors.blueGrey],
                      stops: <double>[0.0, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              widthFactor: 0.5,
              child: InteractiveViewer(
                scaleEnabled: true,
                boundaryMargin: const EdgeInsets.all(20.0),
                minScale: 0.1,
                maxScale: 4,
                child: Container(
                  height: 150,
                  width: 100,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[Colors.amber, Colors.cyan],
                      stops: <double>[0.0, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: DragTarget(
        onWillAccept: (data) {
          // setState(() {
          //   cards.removeWhere((element) => element == data);
          // });
          return true;
        },
        builder: (BuildContext context, List<YugiohCard?> candidateData, List<dynamic> rejectedData) {
          return Icon(Icons.delete);
        },
      ),
    );
  }
}
