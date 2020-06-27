import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class MyImagePicker extends StatefulWidget {
  final Function imagePickerCallback;
  final int maxPickedImages;
  MyImagePicker(this.imagePickerCallback, {this.maxPickedImages = 5});

  @override
  _MyImagePickerState createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {
  List<Asset> _images = List<Asset>();
  bool _hasError = false;
  String _error;

  Future<List<Map<String, dynamic>>> _createByteAndTypeDataFromAssets(
      List<Asset> assets) async {
    List<Map<String, dynamic>> byteDataImageList = [];
    var bytes;
    var name;
    var map;
    for (int x = 0; x < assets.length; x++) {
      bytes = await assets[x].getByteData();
      name = assets[x].name;
      map = {'bytes': bytes, 'name': name};
      byteDataImageList.add(map);
    }
    return byteDataImageList;
  }

  void loadAssets(BuildContext ctx) async {
    setState(() {
      _images = List<Asset>();
    });
    List<Asset> resultList;
    String error;
    try {
      resultList = await MultiImagePicker.pickImages(
          maxImages: widget.maxPickedImages,
          enableCamera: true,
          materialOptions: MaterialOptions(
              actionBarTitle: 'Kies of maak foto\'s',
              actionBarColor: '#053505',
              actionBarTitleColor: '#e9a401',
              selectionLimitReachedText:
                  'Je mag maximaal ${widget.maxPickedImages} foto\'s kiezen.'),
          cupertinoOptions: CupertinoOptions(backgroundColor: '#053505'));
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    var imagesByteDataList = await _createByteAndTypeDataFromAssets(resultList);
    widget.imagePickerCallback(imagesByteDataList);
    setState(() {
      _images = resultList;
      if (error == null) {
        _error = 'Geen fout ontdekt.';
      } else {
        _hasError = true;
        _error = error;
      }
    });
  }

  Widget buildGridView() {
    if (_images != null) {
      return Row(
          children: _images
              .map(
                (e) => Container(
                  child: AssetThumb(
                    asset: e,
                    width: 40,
                    height: 40,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                ),
              )
              .toList());
//      return GridView.count(
//        shrinkWrap: true,
//        crossAxisCount: 3,
//        mainAxisSpacing: 3,
//        crossAxisSpacing: 3,
//        children: List.generate(_images.length, (index) {
//          Asset asset = _images[index];
//          return AssetThumb(asset: asset, width: 40, height: 40);
//        }),
//      );
    } else {
      return Container(color: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (_hasError)
          Center(
            child: Text('Fout: $_error'),
          ),
        RaisedButton(
          onPressed:
              widget.maxPickedImages == 0 ? null : () => loadAssets(context),
          child: Text('Kies maximaal ${widget.maxPickedImages} foto(\'s)'),
        ),
        if (_images.length > 0)
          Flexible(
            fit: FlexFit.loose,
            child: buildGridView(),
          )
      ],
    );
  }
}
