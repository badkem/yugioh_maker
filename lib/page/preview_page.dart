part of 'page.dart';

class PreviewPage extends StatefulWidget {
  final List<YugiohCard> cards;
  final int mode;

  const PreviewPage({Key? key, required this.mode, required this.cards})
      : super(key: key);

  @override
  _PreviewPageState createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  final screenController = ScreenshotController();

  late double height, width;
  Uint8List? image;
  String imgLink = '';

  bool isUploadDone = false;
  bool isVisible = false;
  bool isDone = true;
  dynamic focus;

  void _upload() async {
    if (widget.mode == 1) {
      image = await _getScreenshot();
    }
    if (widget.mode == 3) {
      image = await _getScreenshot();
    }
    if (widget.mode == 4) {
      image = await _getScreenshot();
    }
    var file = FormData.fromMap({
      'image': MultipartFile.fromBytes(
          widget.mode == 1
              ? image!
              : widget.mode == 2
                  ? widget.cards[0].image
                  : widget.mode == 3
                      ? image!
                      : widget.mode == 4
                          ? image!
                          : widget.cards[0].image,
          filename: 'image',
          contentType: MediaType('image', 'png'))
    });
    try {
      setState(() {
        isVisible = true;
      });
      final response =
          await Dio().postUri(Uri.parse('https://api.imgur.com/3/upload'),
              options: Options(headers: {
                'Authorization':
                    'Bearer 72222ea47697f34123a1eea53cc5c1a82c2bfd1d',
                'Content-Type': 'multipart/form-data'
              }),
              data: file);
      if (response.statusCode == 200) {
        setState(() {
          imgLink = response.data['data']['link'];
          isVisible = false;
          isUploadDone = true;
        });
        print(response.statusMessage);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Uint8List?> _getScreenshot() async {
    var img = await screenController.capture();
    return img;
  }

  _onShare(BuildContext context) async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    if (imgLink.isNotEmpty) {
      await Share.share(imgLink,
          subject: 'Meme',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      final bool nativeAppLaunchSucceeded = await launch(
        url,
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      if (!nativeAppLaunchSucceeded) {
        await launch(
          url,
          forceSafariVC: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.cards;
    final mode = widget.mode;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/background.png')
            )
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            title: Text('preview'.toUpperCase(), style: TextStyle(fontFamily: 'Caps-1', fontSize: 30, color: Colors.black87),),
            backgroundColor: Colors.white.withOpacity(0.3),
            elevation: 0.5,
            leading: TextButton.icon(
                onPressed: () {
                  switch (widget.mode) {
                    case 0:
                      Navigator.pop(context);
                      break;
                    case 1:
                      Navigator.pop(context, isDone);
                      Navigator.pop(context, isDone);
                      Navigator.pop(context, isDone);
                      Navigator.pop(context, isDone);
                      Navigator.pop(context, isDone);
                      break;
                    case 2:
                      Navigator.pop(context);
                      break;
                    case 3:
                      Navigator.pop(context, isDone);
                      Navigator.pop(context, isDone);
                      Navigator.pop(context, isDone);
                      break;
                    case 4:
                      Navigator.pop(context, isDone);
                      Navigator.pop(context, isDone);
                      Navigator.pop(context, isDone);
                      break;
                  }
                },
                icon: Image.asset('assets/images/btn_back.png', width: 30,),
                label: Text('')),
          ),
          body: items.isNotEmpty
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// item preview
              mode == 0
                  ? Image.memory(
                items[0].image,
                width: width * 0.8,
              )
                  : mode == 1
                  ? Screenshot(
                controller: screenController,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.memory(
                          items[0].image,
                          width: width * 0.3,
                        ),
                        Image.memory(
                          items[1].image,
                          width: width * 0.3,
                        ),
                        Image.memory(
                          items[2].image,
                          width: width * 0.3,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.memory(
                          items[3].image,
                          width: width * 0.3,
                        ),
                        Image.memory(
                          items[4].image,
                          width: width * 0.3,
                        ),
                      ],
                    )
                  ],
                ),
              )
                  : mode == 2
                  ? Image.memory(
                items[0].image,
                width: width * 0.8,
              )
                  : mode == 3
                  ? Screenshot(
                controller: screenController,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: items
                      .map((e) => Draggable(
                    data: e,
                    childWhenDragging: SizedBox(
                      width: width * 0.3,
                    ),
                    feedback: Stack(
                      children: [
                        Image.memory(e.image, width: e.width - 50),
                        Image.memory(e.image, width: e.width - 50, color: Colors.red.withOpacity(0.5)),
                      ],
                    ),
                    child: Image.memory(e.image, width: width * 0.3),
                  )).toList(),
                ),
              )
                  : Screenshot(
                controller: screenController,
                child: Container(
                  alignment: Alignment.center,
                  height: 400,
                  width: double.infinity,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: items.length,
                      itemBuilder: (ctx, i) {
                        final item = items[i];
                        return Draggable(
                          data: item,
                          childWhenDragging: Align(
                              widthFactor: 0.5,
                              child: SizedBox(width: item.width)),
                          feedback: Stack(
                            children: [
                              Image.memory(item.image, width: item.width - 50),
                              Image.memory(item.image, width: item.width - 50, color: Colors.red.withOpacity(0.5)),
                            ],
                          ),
                          child: Align(
                            widthFactor: 0.5,
                            child: GestureDetector(
                              onTap: () {
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
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          CupertinoSlider(
                                                              value: item.degree,
                                                              min: -360,
                                                              max: 360,
                                                              onChanged: (double value) {
                                                                setState(() {
                                                                  item.degree = value;
                                                                });
                                                                fuckingState(() => item.degree = value);
                                                                if (value == 0) HapticFeedback.lightImpact();
                                                              }),
                                                          Text('${item.degree.round()}°', style: TextStyle(fontFamily: 'Caps-1', fontSize: 25),)
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          CupertinoSlider(
                                                              value: item.width,
                                                              min: 80,
                                                              max: 180,
                                                              onChanged: (double value) {
                                                                setState(() {
                                                                  item.width = value;
                                                                });
                                                                fuckingState(() => item.width = value);
                                                              }),
                                                          Text('${item.width.round()} px', style: TextStyle(fontFamily: 'Caps-1', fontSize: 25),)
                                                        ],
                                                      )
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
                                  child: Image.memory(item.image, width: item.width),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              /// upload icon
              SizedBox(
                height: height * 0.010,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isUploadDone == false
                      ? TextButton.icon(
                      onPressed: () => _upload(),
                      icon: Icon(Icons.upload_rounded, color: Colors.black87),
                      label: Text('Upload to Imgur', style: TextStyle(fontFamily: 'Caps-1', fontSize: 25, color: Colors.black87, fontWeight: FontWeight.bold),))
                      : TextButton.icon(
                      onPressed: () => _onShare(context),
                      icon: Icon(Icons.share, color: Colors.black87,),
                      label: Text('Share', style: TextStyle(fontFamily: 'Caps-1', fontSize: 25, color: Colors.black87, fontWeight: FontWeight.bold))),
                  Visibility(
                    visible: isUploadDone,
                    child: TextButton(
                      onPressed: () => _launchUrl(imgLink),
                      child: Text('Watch it!', style: TextStyle(fontFamily: 'Caps-1', fontSize: 25, color: Colors.black87, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
              Visibility(
                visible: isVisible,
                child: CircularProgressIndicator(),
              ),
            ],
          )
              : Center(
            child: Text('Empty!', style: TextStyle(fontFamily: 'Caps-1', fontSize: 35),),
          ),
          floatingActionButton: mode == 3
              ? Container(
            height: 80,
            width: 80,
            child: DragTarget(
              onWillAccept: (YugiohCard? data) {
                HapticFeedback.lightImpact();
                return true;
              },
              onAccept: (YugiohCard data) {
                setState(() {
                  items.removeWhere((item) => item == data);
                });
              },
              builder: (BuildContext context, List<YugiohCard?> candidateData,
                  List<dynamic> rejectedData) {
                return Icon(Icons.delete, size: 40);
              },
            ),
          ) : mode == 4
              ? Container(
            height: 80,
            width: 80,
            child: DragTarget(
              onWillAccept: (YugiohCard? data) {
                HapticFeedback.lightImpact();
                return true;
              },
              onAccept: (YugiohCard data) {
                setState(() {
                  items.removeWhere((item) => item == data);
                });
              },
              builder: (BuildContext context, List<YugiohCard?> candidateData,
                  List<dynamic> rejectedData) {
                return Icon(Icons.delete, size: 40);
              },
            ),
          ) : SizedBox(),
        ),
      ),
    );
  }
}
