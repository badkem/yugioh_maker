part of 'page.dart';

class MemePage extends StatefulWidget {
  const MemePage({Key? key}) : super(key: key);

  @override
  _MemePageState createState() => _MemePageState();
}

class _MemePageState extends State<MemePage> {
  late double height, width;
  int fileName = DateTime.now().microsecondsSinceEpoch;

  var isDone = false;
  var isUploadDone = false;
  var isVisible = false;
  var imgLink = '';
  var image1Path = File('').path;
  var image2Path = File('').path;
  var image3Path = File('').path;

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
      } else {
        print('No image selected.');
      }
      if(listImagePath.length >= 3 ) isDone = true;
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
          subject: 'Meme',
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
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () => _getImage(1),
                            child: Container(
                              height: height * 0.18,
                              width: width * 0.35,
                              color: Colors.blueGrey,
                              child: image1Path.isEmpty
                                  ? Center(child: Text('?'))
                                  : Image.file(
                                File(image1Path),
                                width: width * 0.25,
                                height: height * 0.25,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => _getImage(2),
                            child: Container(
                              height: height * 0.18,
                              width: width * 0.35,
                              color: Colors.blueGrey,
                              child: image2Path.isEmpty
                                  ? Center(child: Text('?'))
                                  : Image.file(
                                File(image2Path),
                                width: width * 0.25,
                                height: height * 0.25,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        child: Icon(Icons.arrow_downward),
                        height: height * 0.025,),
                      Image.asset('assets/images/fusion.png', height: height * 0.15),
                      SizedBox(
                        child: Icon(Icons.arrow_downward),
                        height: height * 0.025,),
                      InkWell(
                        onTap: () => _getImage(3),
                        child: Container(
                          height: height * 0.25,
                          width: width * 0.50,
                          color: Colors.blueGrey,
                          child: image3Path.isEmpty
                              ? Center(child: Text('?'))
                              : Image.file(
                            File(image3Path),
                            width: width * 0.25,
                            height: height * 0.25,
                            fit: BoxFit.fill,
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
            ],
          ),
        ),
      ),
    );
  }
}
