part of 'page.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final cards = <CardAlign>[
    CardAlign(
        image: 'assets/images/card_type/1.gif',
        factor: 0.2,
        width: 150,
        degree: -4.0),
    CardAlign(
        image: 'assets/images/card_type/2.gif',
        factor: 0.5,
        width: 150,
        degree: 0),
    CardAlign(
        image: 'assets/images/card_type/3.gif',
        factor: 0.5,
        width: 150,
        degree: 8),
  ];

  dynamic focus;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: cards.length,
              itemBuilder: (ctx, i) {
                final item = cards[i];
                return Align(
                  widthFactor: 0.5,
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        focus = i;
                      });
                      Future<void> onBottomSheetClose =
                          showModalBottomSheet<void>(
                              barrierColor: Colors.transparent,
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                    builder: (BuildContext context, StateSetter fuckingState) =>
                                        Container(
                                          height: 150,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                CupertinoSlider(
                                                    value: item.degree,
                                                    min: -360,
                                                    max: 360,
                                                    onChanged: (double value) {
                                                      setState(() {
                                                        item.degree = value;
                                                        if (value == 0) print('value is 0 now');
                                                      });
                                                      fuckingState(() => item.degree = value);
                                                    }),
                                                CupertinoSlider(
                                                    value: item.width,
                                                    min: 80,
                                                    max: 180,
                                                    onChanged: (double value) {
                                                      setState(() {
                                                        item.width = value;
                                                      });
                                                      fuckingState(() => item.width = value);
                                                    })
                                              ],
                                            ),
                                          ),
                                        ));
                              });
                      onBottomSheetClose.then((value) {
                        setState(() {
                          focus = null;
                        });
                      });
                    },
                    child: RotationTransition(
                      turns: AlwaysStoppedAnimation(item.degree / 360),
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 4,
                                  color: focus == i
                                      ? Colors.yellow
                                      : Colors.transparent)),
                          child: Image.asset(item.image, width: item.width)),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
