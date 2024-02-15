import 'package:flutter/material.dart';

import 'AddUpdateScreen.dart';
import 'lib.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'おみくじ統計',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'おみくじ統計'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _navigationNumber = 0;

  void _navigationTapped(int val) {
    setState(() {
      _navigationNumber = val;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('おみくじ統計'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(
                  Icons.playlist_add,
              ),
              onPressed: () async {
                //新規画面に遷移する
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddUpdateScreen(id: 0)),
                );
                //画面遷移後に再描画
                setState(() {});
              },
            ),
          ],
        ),
        body: lib.screens[_navigationNumber](),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _navigationNumber,
          onTap: _navigationTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'グラフ'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: '一覧'),
          ],
          type: BottomNavigationBarType.fixed,
        ));
  }
}

class appBarSetting extends StatelessWidget {
  const appBarSetting({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () {},
    );
  }
}
