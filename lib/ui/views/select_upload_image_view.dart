import 'dart:io';
import 'dart:typed_data';

import 'package:client_app/models/cdn_image.dart';
import 'package:client_app/ui/views/custom_loading_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:blurhash_dart/blurhash_dart.dart';

import '../../constants/colors.dart';
import '../../main.dart';

class SelectUploadImagesView extends StatefulWidget {
  final int maxImages;
  final Function(SelectImagesViewController controller)? onControllerReady;
  final Function(List<File?> images)? onImagesSelected;
  final String uploadFolder;

  const SelectUploadImagesView(
      {Key? key,
      this.maxImages = 1,
      this.onControllerReady,
      required this.uploadFolder,
      this.onImagesSelected})
      : super(key: key);

  @override
  State<SelectUploadImagesView> createState() => _SelectUploadImagesViewState();
}

class _SelectUploadImagesViewState extends State<SelectUploadImagesView> {
  List<File?> images = [];
  List<String?> blurHashes = [];

  @override
  void initState() {
    for (var i = 0; i < widget.maxImages; i++) {
      images.add(null);
      blurHashes.add(null);
    }

    if (widget.onControllerReady != null) {
      widget.onControllerReady!(SelectImagesViewController._(
          images: images,
          blurHashes: blurHashes,
          uploadFolder: widget.uploadFolder));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.maxImages == 1) {
      return Column(
        children: [
          if (images.isNotEmpty && images[0] != null)
            Container(
              height: 200,
              child: _PreviewImage(blurHash: blurHashes[0]!, image: images[0]!),
            ),
          ElevatedButton(
            onPressed: () => selectImage(0),
            child: const Text("Select Image"),
          ),
        ],
      );
    }

    throw UnimplementedError();
  }

  Future<void> selectImage(int index) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        maxHeight: 1080,
        maxWidth: 1080,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Image Cropper',
            toolbarColor: primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Image Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );

      if (croppedFile != null) {
        // attach compressed to end of file name
        final targetPath = croppedFile.path.replaceAll(
          '.jpg',
          '_compressed.jpg',
        );
        try {
          CustomLoadingDialog.show(navigatorKey.currentContext!,
              message: "Processing Image");

          images[index] = await FlutterImageCompress.compressAndGetFile(
            croppedFile.path,
            targetPath,
            quality: 88,
          );

          await generateBlurhash(index);

          CustomLoadingDialog.hide(navigatorKey.currentContext!);

          if (widget.onImagesSelected != null) {
            widget.onImagesSelected!(images);
          }
        } catch (ex) {
          CustomLoadingDialog.hide(navigatorKey.currentContext!);
          print(ex);
          rethrow;
        }

        setState(() {});
      }
    }
  }

  Future<void> generateBlurhash(int index) async {
    final data = await images[index]!.readAsBytes();
    final image = img.decodeImage(data.toList());
    final blurHash = BlurHash.encode(image!, numCompX: 4, numCompY: 3);

    blurHashes[index] = blurHash.hash;
    return;
  }
}

class SelectImagesViewController {
  List<File?> images;
  List<String?> blurHashes = [];
  String uploadFolder;

  SelectImagesViewController._(
      {required this.images,
      required this.blurHashes,
      required this.uploadFolder});

  Future<List<CdnImage>> uploadImages() async {
    final FirebaseStorage storage = FirebaseStorage.instance;

    final List<CdnImage> cndImages = [];

    for (var i = 0; i < images.length; i++) {
      final image = images[i];
      final blurhash = blurHashes[i];

      if (image != null && blurhash != null) {
        final ref = storage.ref("$uploadFolder/${DateTime.now()}.jpg");
        final uploadTask = ref.putFile(image);

        await uploadTask.whenComplete(() async {
          final url = await ref.getDownloadURL();
          final CdnImage cdnImage = CdnImage(url: url, blurhash: blurhash);

          cndImages.add(cdnImage);
        });
      }
    }

    return cndImages;
  }

  Future<bool> isImageSelected() {
    return Future.value(images.isNotEmpty && images[0] != null);
  }
}

class _PreviewImage extends StatefulWidget {
  final String blurHash;
  final File image;
  _PreviewImage({Key? key, required this.blurHash, required this.image})
      : super(key: key);

  @override
  State<_PreviewImage> createState() => __PreviewImageState();
}

class __PreviewImageState extends State<_PreviewImage> {
  bool onTapped = false;
  late Uint8List blurhashBytes;

  @override
  void initState() {
    final BlurHash blurHash = BlurHash.decode(widget.blurHash);
    final img.Image _image = blurHash.toImage(35, 20);
    blurhashBytes = Uint8List.fromList(img.encodeJpg(_image));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (x) => setState(() {
        onTapped = true;
      }),
      onTapUp: (x) => setState(() {
        onTapped = false;
      }),
      child: RepaintBoundary(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child: onTapped
              ? AspectRatio(
                  aspectRatio: 1,
                  child: Image.memory(
                    blurhashBytes,
                    fit: BoxFit.cover,
                  ),
                )
              : AspectRatio(
                  aspectRatio: 1,
                  child: Image.file(
                    widget.image,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ),
    );
  }
}
