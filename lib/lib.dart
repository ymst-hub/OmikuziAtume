import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'GraphScreen.dart';
import 'ListScreen.dart';

class lib {
  //BottomNavigationBarの遷移先
  static final List<Widget Function()> screens = [
        () => GraphScreen(),
        () => ListScreen(),
  ];

//Listと、Graphの色
  static final List<Color> omikuziColor = [
    Colors.black,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.pink,
    Colors.red,
  ];

  static final List<String> resultList = [
    '大凶',
    '凶',
    '末吉',
    '吉',
    '小吉',
    '中吉',
    '大吉'
  ]; //画面表示にも利用
  static final List<String> selfResultList = [
    '当たっていない',
    '当たっていない部分もある',
    '当たっているかもしれない',
    '当たる部分もある',
    '当たっている'
  ];
}