part of 'page.dart';

class PreviewPage extends StatefulWidget {
  final Uint8List image;
  const PreviewPage({Key? key, required this.image}) : super(key: key);

  @override
  _PreviewPageState createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  late double height, width;
  String imgLink = '';

  bool isUploadDone = false;
  bool isVisible = false;

  void _upload() async {
    var file = FormData.fromMap(
        {
          'image': MultipartFile.fromBytes(widget.image, filename: 'image', contentType: MediaType('image','png'))
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
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('Share with', style: TextStyle(color: Colors.black54),),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Done'),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.memory(widget.image, width: width * 0.8,),
            SizedBox(height: height * 0.04,),
            isUploadDone == false
                ? TextButton.icon(
                onPressed: () => _upload(),
                icon: Icon(Icons.upload_rounded),
                label: Text('Upload to Imgur'))
                : TextButton.icon(
                onPressed: () => _onShare(context),
                icon: Icon(Icons.upload_rounded),
                label: Text('Share')),
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
    );
  }
}
