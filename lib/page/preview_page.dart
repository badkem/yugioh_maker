part of 'page.dart';

class PreviewPage extends StatefulWidget {
  final List<YugiohCard> cards;
  final int mode;

  const PreviewPage(
      {Key? key,
      required this.mode,
      required this.cards})
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
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Preview',
          style: TextStyle(color: Colors.black54),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          TextButton(
            onPressed: () {
              switch (widget.mode) {
                case 0:
                  Navigator.pop(context);
                  break;
                case 1:
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  break;
                case 2:
                  Navigator.pop(context);
                  break;
                case 3:
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  break;
                case 4:
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  break;
              }
            },
            child: Text('Done'),
          )
        ],
      ),
      body: items.isNotEmpty
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.mode == 0
              ? Image.memory(
            widget.cards[0].image,
            width: width * 0.8,
          )
              : widget.mode == 1
              ? Screenshot(
            controller: screenController,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.memory(
                      widget.cards[0].image,
                      width: width * 0.3,
                    ),
                    Image.memory(
                      widget.cards[1].image,
                      width: width * 0.3,
                    ),
                    Image.memory(
                      widget.cards[2].image,
                      width: width * 0.3,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.memory(
                      widget.cards[3].image,
                      width: width * 0.3,
                    ),
                    Image.memory(
                      widget.cards[4].image,
                      width: width * 0.3,
                    ),
                  ],
                )
              ],
            ),
          )
              : widget.mode == 2
              ? Image.memory(
            widget.cards[0].image,
            width: width * 0.8,
          )
              : widget.mode == 3
              ? Screenshot(
            controller: screenController,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: items.map((e) => Draggable(
                data: e,
                childWhenDragging: SizedBox(width: width * 0.3,),
                feedback: Stack(
                  children: [
                    Image.memory(e.image, width: width * 0.25,),
                    Image.memory(e.image,
                        width: width * 0.25,
                        color: Colors.red.withOpacity(0.5)),
                  ],
                ),
                child: Image.memory(e.image, width: width * 0.3),
              )).toList(),
            ),
          )
              : Screenshot(
            controller: screenController,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: items.map((e) => Draggable(
                data: e,
                childWhenDragging: SizedBox(width: width * 0.4,),
                feedback: Stack(
                  children: [
                    Image.memory(e.image, width: width * 0.35,),
                    Image.memory(e.image,
                        width: width * 0.35,
                        color: Colors.red.withOpacity(0.5)),
                  ],
                ),
                child: Align(
                  widthFactor: 0.5,
                  child: RotationTransition(
                    turns: AlwaysStoppedAnimation(e.degree / 360),
                    child: Image.memory(e.image, width: width * 0.4,
                    ),
                  ),
                ),
              )).toList(),
            ),
          ),
          SizedBox(
            height: height * 0.010,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isUploadDone == false
                  ? TextButton.icon(
                  onPressed: () => _upload(),
                  icon: Icon(Icons.upload_rounded),
                  label: Text('Upload to Imgur'))
                  : TextButton.icon(
                  onPressed: () => _onShare(context),
                  icon: Icon(Icons.share),
                  label: Text('Share')),
              Visibility(
                visible: isUploadDone,
                child: TextButton(
                  onPressed: () => _launchUrl(imgLink),
                  child: Text('Watch it!'),
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
          : Center(child: Text('Empty!'),),
      bottomSheet: widget.mode == 3
            ? Container(
        alignment: Alignment.center,
        height: height * 0.2,
        child: DragTarget(
          onWillAccept: (YugiohCard? data) {
            return true;
          },
          onAccept: (YugiohCard data) {
            setState(() {
              items.removeWhere((item) => item == data);
            });
          },
          builder: (BuildContext context, List<YugiohCard?> candidateData, List<dynamic> rejectedData) {
            return Icon(Icons.delete, size: 35);
          },
        ),
      )
            : widget.mode == 4
            ? Container(
        alignment: Alignment.center,
        height: height * 0.2,
        child: DragTarget(
          onWillAccept: (YugiohCard? data) {
            return true;
          },
          onAccept: (YugiohCard data) {
            setState(() {
              items.removeWhere((item) => item == data);
            });
          },
          builder: (BuildContext context, List<YugiohCard?> candidateData, List<dynamic> rejectedData) {
            return Icon(Icons.delete, size: 35);
          },
        ),
      )
            : SizedBox(),
    );
  }
}
