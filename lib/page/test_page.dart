part of 'page.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final picker = ImagePicker();
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

  var imagePath = File('').path;

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        imagePath = File(pickedFile.path).path;
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: constraints.maxWidth / 1.3,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  /// pick file
                  Positioned(
                    top: 50,
                    child: GestureDetector(
                      onTap: () => _getImage(),
                      child: Container(
                        color: Colors.grey,
                        height: constraints.maxHeight / 3,
                        width: constraints.maxWidth / 1.7,
                        child: InteractiveViewer(
                          boundaryMargin: const EdgeInsets.all(20.0),
                          minScale: 1,
                          maxScale: 4,
                          child: imagePath.isEmpty
                              ? Center(child: Text('Tap here to select image'))
                              : Image.file(File(imagePath)),
                        ),
                      ),
                    ),
                  ),
                  /// scaffold
                  IgnorePointer(
                    ignoring: true,
                   child: Image.asset('assets/images/theme/1.png'),
                  ),
                  /// num/year
                  Positioned(
                    top: 30,
                    left: 30,
                    child: GestureDetector(
                      onTap: () {},
                      child: Text('NAME'),
                    ),
                  ),
                  /// num/year
                  Positioned(
                    bottom: 90,
                    left: 30,
                    child: GestureDetector(
                      onTap: () {},
                      child: Text('[your name]'),
                    ),
                  ),
                  Positioned(
                    bottom: 75,
                    left: 30,
                    child: GestureDetector(
                      onTap: () {},
                      child: Text('description'),
                    ),
                  ),
                  /// atk/def
                  Positioned(
                    bottom: 25,
                    right: 20,
                    child: GestureDetector(
                      onTap: () {},
                      child: Text('2021'),
                    ),
                  ),
                  Positioned(
                    bottom: 25,
                    right: 85,
                    child: GestureDetector(
                      onTap: () {},
                      child: Text('2021'),
                    ),
                  ),
                  /// num/year
                  Positioned(
                    bottom: 6,
                    right: 20,
                    child: GestureDetector(
                      onTap: () {},
                      child: Text('@2021'),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    left: 20,
                    child: GestureDetector(
                      onTap: () {},
                      child: Text('93819203'),
                    ),
                  ),
                ],
              ),
            );
          },

        ),
      ),
      // body: Center(
      //   child: Container(
      //     alignment: Alignment.center,
      //     width: double.infinity,
      //     child: ListView.builder(
      //         shrinkWrap: true,
      //         scrollDirection: Axis.horizontal,
      //         itemCount: cards.length,
      //         itemBuilder: (ctx, i) {
      //           final item = cards[i];
      //           return Align(
      //             widthFactor: 0.5,
      //             child: GestureDetector(
      //               onTap: () async {
      //                 setState(() {
      //                   focus = i;
      //                 });
      //                 Future<void> onBottomSheetClose =
      //                     showModalBottomSheet<void>(
      //                         barrierColor: Colors.transparent,
      //                         context: context,
      //                         builder: (BuildContext context) {
      //                           return StatefulBuilder(
      //                               builder: (BuildContext context, StateSetter fuckingState) =>
      //                                   Container(
      //                                     height: 150,
      //                                     child: Center(
      //                                       child: Column(
      //                                         mainAxisAlignment: MainAxisAlignment.center,
      //                                         mainAxisSize: MainAxisSize.min,
      //                                         children: <Widget>[
      //                                           CupertinoSlider(
      //                                               value: item.degree,
      //                                               min: -360,
      //                                               max: 360,
      //                                               onChanged: (double value) {
      //                                                 setState(() {
      //                                                   item.degree = value;
      //                                                   if (value == 0) print('value is 0 now');
      //                                                 });
      //                                                 fuckingState(() => item.degree = value);
      //                                               }),
      //                                           CupertinoSlider(
      //                                               value: item.width,
      //                                               min: 80,
      //                                               max: 180,
      //                                               onChanged: (double value) {
      //                                                 setState(() {
      //                                                   item.width = value;
      //                                                 });
      //                                                 fuckingState(() => item.width = value);
      //                                               })
      //                                         ],
      //                                       ),
      //                                     ),
      //                                   ));
      //                         });
      //                 onBottomSheetClose.then((value) {
      //                   setState(() {
      //                     focus = null;
      //                   });
      //                 });
      //               },
      //               child: RotationTransition(
      //                 turns: AlwaysStoppedAnimation(item.degree / 360),
      //                 child: Container(
      //                     decoration: BoxDecoration(
      //                         border: Border.all(
      //                             width: 4,
      //                             color: focus == i
      //                                 ? Colors.yellow
      //                                 : Colors.transparent)),
      //                     child: Image.asset(item.image, width: item.width)),
      //               ),
      //             ),
      //           );
      //         }),
      //   ),
      // ),
    );
  }
}
