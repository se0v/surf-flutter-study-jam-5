import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class MemeGeneratorScreen extends StatefulWidget {
  const MemeGeneratorScreen({Key? key}) : super(key: key);

  @override
  State<MemeGeneratorScreen> createState() => _MemeGeneratorScreenState();
}

class _MemeGeneratorScreenState extends State<MemeGeneratorScreen> {
  late TextEditingController linkController;
  late TextEditingController textController;
  var textMeme = 'Здесь мог бы быть ваш мем';
  var linkMeme =
      'https://i.cbc.ca/1.6713656.1679693029!/fileImage/httpImage/image.jpg_gen/derivatives/16x9_780/this-is-fine.jpg';
  bool isImageFromGallery = false;
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    linkController = TextEditingController();
    textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      border: Border.all(
        color: Colors.white,
        width: 2,
      ),
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 82, 129, 168),
      body: Stack(
        children: [
          Center(
            child: ColoredBox(
              color: Colors.black,
              child: DecoratedBox(
                decoration: decoration,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 30,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: DecoratedBox(
                          decoration: decoration,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: isImageFromGallery
                                ? Image.memory(
                                    imageBytes!,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    linkController.text.isNotEmpty
                                        ? linkController.text
                                        : linkMeme,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      Text(
                        textMeme,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Impact',
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(
                bottom: 80,
                child: ElevatedButton(
                  onPressed: () {
                    _showDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    backgroundColor: const Color.fromARGB(255, 54, 216, 244),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.image, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Загрузить изображение'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(
                bottom: 140,
                child: ElevatedButton(
                  onPressed: () {
                    _changeText();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    backgroundColor: const Color.fromARGB(255, 54, 216, 244),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.text_fields, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Сменить текст'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(
                bottom: 20,
                child: ElevatedButton(
                  onPressed: () {
                    _shareImage();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    backgroundColor: const Color.fromARGB(255, 54, 216, 244),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.share, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Поделиться'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _shareImage() async {
    if (isImageFromGallery) {
      // If the image is from the gallery, create a temporary file and share it
      final directory = await getTemporaryDirectory();
      final path = "${directory.path}/shared_image.png";
      await File(path).writeAsBytes(imageBytes!);

      // ignore: deprecated_member_use
      Share.shareFiles([path], text: textMeme);
    } else {
      // If the image is from a URL, share the URL
      Share.share(linkMeme, subject: textMeme);
    }
  }

  void _changeText() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Введите текст'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'Введите текст здесь',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                textMeme = textController.text;
              });
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Введите ссылку на изображение'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: linkController,
                decoration: const InputDecoration(
                  hintText: 'Введите ссылку здесь',
                ),
              ),
              const SizedBox(height: 15),
              const Text('Или воспользуйтесь галереей:'),
              ElevatedButton.icon(
                onPressed: () {
                  _chooseImage();
                },
                icon: const Icon(Icons.image),
                label: const Text('Выбрать'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              String newLink = linkController.text;
              if (Uri.parse(newLink).isAbsolute) {
                setState(() {
                  linkMeme = newLink;
                  isImageFromGallery = false;
                });
              } else {
                _showErrorDialog('Невалидная ссылка');
              }
            },
            child: const Text('Отобразить по ссылке'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _chooseImage() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      Uint8List bytes = await pickedFile.readAsBytes();
      setState(() {
        isImageFromGallery = true;
        imageBytes = bytes;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ошибка'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
