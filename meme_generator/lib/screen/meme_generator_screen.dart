import 'package:flutter/material.dart';

class MemeGeneratorScreen extends StatefulWidget {
  const MemeGeneratorScreen({Key? key}) : super(key: key);

  @override
  State<MemeGeneratorScreen> createState() => _MemeGeneratorScreenState();
}

class _MemeGeneratorScreenState extends State<MemeGeneratorScreen> {
  late TextEditingController linkController;
  var linkMeme =
      'https://i.ytimg.com/vi/7tMXW-EnzMk/maxresdefault.jpg?sqp=-oaymwEmCIAKENAF8quKqQMa8AEB-AGkBYAC4AOKAgwIABABGGUgUSg9MA8=&rs=AOn4CLAjBQBSh9TY6qd2ZmeM2BPwJzAgbw';
  var textMeme = 'Здесь мог бы быть ваш мем';
  @override
  void initState() {
    super.initState();
    linkController = TextEditingController();
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
                    horizontal: 50,
                    vertical: 20,
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
                            child: Image.network(
                              linkMeme,
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
            alignment: Alignment.bottomCenter, // Выравнивание внизу по центру
            children: [
              Positioned(
                bottom: 100,
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
                      Icon(Icons.image,
                          color: Colors.white), // Иконка внутри кнопки
                      SizedBox(width: 8),
                      Text('Загрузить мем'),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Введите ссылку на изображение'),
        content: TextField(
          controller: linkController,
          decoration: InputDecoration(
            hintText: 'Введите ссылку здесь',
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
                });
              } else {
                // Обработка невалидной ссылки
                _showErrorDialog('Невалидная ссылка');
              }
            },
            child: const Text('Обновить'),
          ),
        ],
      ),
    );
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
