part of 'page.dart';

class ExodiaPage extends StatefulWidget {
  const ExodiaPage({Key? key}) : super(key: key);

  @override
  _ExodiaPageState createState() => _ExodiaPageState();
}

class _ExodiaPageState extends State<ExodiaPage> {
  late double height, width;
  int fileName = DateTime.now().microsecondsSinceEpoch;

  var isDone = false;
  var isUploadDone = false;
  var isVisible = false;

  var imgLink = '';
  var image1Path = File('').path;
  var image2Path = File('').path;
  var image3Path = File('').path;
  var image4Path = File('').path;
  var image5Path = File('').path;

  var listImagePath = <File>[];

  final picker = ImagePicker();
  final scController = ScreenshotController();

  Future _getImage(int i) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        if(i == 1) {
          image1Path = File(pickedFile.path).path;
          listImagePath.add(File(pickedFile.path));
        }
        if(i == 2) {
          image2Path = File(pickedFile.path).path;
          listImagePath.add(File(pickedFile.path));
        }
        if(i == 3) {
          image3Path = File(pickedFile.path).path;
          listImagePath.add(File(pickedFile.path));
        }
        if(i == 4) {
          image4Path = File(pickedFile.path).path;
          listImagePath.add(File(pickedFile.path));
        }
        if(i == 5) {
          image5Path = File(pickedFile.path).path;
          listImagePath.add(File(pickedFile.path));
        }
      } else {
        print('No image selected.');
      }
      if(listImagePath.length >= 5 ) isDone = true;
    });
  }

  void _upload() {
    scController.capture().then((image) async {
      var file = FormData.fromMap(
          {
            'image': MultipartFile.fromBytes(image!, filename: '$fileName', contentType: MediaType('image','png'))
          }
      );
      try {
        setState(() {
          isVisible = true;
        });
        final response = await Dio().postUri(Uri.parse('https://api.imgur.com/3/upload'),
            options: Options(
                headers: {
                  'Authorization' : 'Bearer 72222ea47697f34123a1eea53cc5c1a82c2bfd1d',
                  'Content-Type': 'multipart/form-data'
                }
            ),
            data: file
        );
        if(response.statusCode == 200){
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
    });
  }

  _onShare(BuildContext context) async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    if (imgLink.isNotEmpty) {
      await Share.share(imgLink,
          subject: 'The Forbidden One',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }

  void _save() {
    try {
      scController.capture().then((image) async {
        await ImageGallerySaver.saveImage(image!,
            quality: 100, name: '$fileName');
      });
    } catch (e) {
      print(e);
    } finally {
      final snackBar = SnackBar(
        content: Text('Yay! Successfully!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Tap to choose your own image'),
              Screenshot(
                controller: scController,
                child: SizedBox(
                  width: width * 0.95,
                  child: Stack(
                    children: [
                      Image.asset('assets/images/exodia.png'),
                      Positioned(
                        top: 32,
                        left: 14,
                        child: InkWell(
                          onTap: () => _getImage(1),
                          child: Container(
                            height: height * 0.114,
                            width: width * 0.248,
                            color: Colors.blueGrey,
                            child: image1Path.isEmpty
                                ? Center(child: Text('?'))
                                : Image.file(
                              File(image1Path),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 34,
                        left: 144,
                        child: InkWell(
                          onTap: () => _getImage(2),
                          child: Container(
                            height: height * 0.114,
                            width: width * 0.248,
                            color: Colors.blueGrey,
                            child: image2Path.isEmpty
                                ? Center(child: Text('?'))
                                : Image.file(
                              File(image2Path),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 34,
                        right: 14,
                        child: InkWell(
                          onTap: () => _getImage(3),
                          child: Container(
                            height: height * 0.114,
                            width: width * 0.248,
                            color: Colors.blueGrey,
                            child: image3Path.isEmpty
                                ? Center(child: Text('?'))
                                : Image.file(
                              File(image3Path),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 56,
                        left: 76,
                        child: InkWell(
                          onTap: () => _getImage(4),
                          child: Container(
                            height: height * 0.114,
                            width: width * 0.248,
                            color: Colors.blueGrey,
                            child: image4Path.isEmpty
                                ? Center(child: Text('?'))
                                : Image.file(
                              File(image4Path),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 56,
                        right: 82,
                        child: InkWell(
                          onTap: () => _getImage(5),
                          child: Container(
                            height: height * 0.114,
                            width: width * 0.248,
                            color: Colors.blueGrey,
                            child: image5Path.isEmpty
                                ? Center(child: Text('?'))
                                : Image.file(
                              File(image5Path),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              isDone == false
                  ? SizedBox()
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isUploadDone == false
                      ? TextButton.icon(
                      onPressed: () => _upload(),
                      icon: Icon(Icons.upload_rounded),
                      label: Text('Upload'))
                      : TextButton.icon(
                      onPressed: () => _onShare(context),
                      icon: Icon(Icons.upload_rounded),
                      label: Text('Share')),
                  TextButton.icon(
                      onPressed: () => _save(),
                      icon: Icon(Icons.save_alt),
                      label: Text('Save')),
                ],
              ),
              Visibility(
                visible: isVisible,
                child: CircularProgressIndicator(),
              ),
              Visibility(
                visible: isUploadDone,
                child: TextButton(
                  onPressed: () => _launchUrl(imgLink),
                  child: Text('Watch it!'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
