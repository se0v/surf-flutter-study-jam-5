import 'package:flutter/material.dart';

class MemeGeneratorScreen extends StatefulWidget {
  const MemeGeneratorScreen({Key? key}) : super(key: key);

  @override
  State<MemeGeneratorScreen> createState() => _MemeGeneratorScreenState();
}

class _MemeGeneratorScreenState extends State<MemeGeneratorScreen> {
  late TextEditingController linkController;
  late TextEditingController textController;
  var linkMeme =
      'https://i.ytimg.com/vi/7tMXW-EnzMk/maxresdefault.jpg?sqp=-oaymwEmCIAKENAF8quKqQMa8AEB-AGkBYAC4AOKAgwIABABGGUgUSg9MA8=&rs=AOn4CLAjBQBSh9TY6qd2ZmeM2BPwJzAgbw';
  var textMeme = 'Здесь мог бы быть ваш мем';
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
            alignment: Alignment.bottomCenter,
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
                bottom: 40,
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
          )
        ],
      ),
    );
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
              const SizedBox(height: 45),
              const Text('Или воспользуйтесь галереей:'),
              ElevatedButton.icon(
                onPressed: () {},
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
                });
              } else {
                _showErrorDialog('Невалидная ссылка');
              }
            },
            child: const Text('Сохранить'),
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
