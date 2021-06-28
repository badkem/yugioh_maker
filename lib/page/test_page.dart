part of 'page.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 200,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                widthFactor: 0.5,
                child: RotationTransition(
                  turns: AlwaysStoppedAnimation(-4 / 360),
                  child: Image.asset('assets/images/card_type/1.gif'),
                ),
              ),
              Align(
                widthFactor: 0.5,
                child: RotationTransition(
                  turns: AlwaysStoppedAnimation(0 / 360),
                  child: Image.asset('assets/images/card_type/2.gif'),
                ),
              ),
              Align(
                widthFactor: 0.5,
                child: RotationTransition(
                  alignment: Alignment(-1, 0),
                  turns: AlwaysStoppedAnimation(4 / 360),
                  child: Image.asset('assets/images/card_type/3.gif'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
