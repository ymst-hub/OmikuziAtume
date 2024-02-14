import 'package:flutter/material.dart';
import 'package:hakke_omikuzi_toukei/DbHelper.dart';
import 'package:intl/intl.dart';

import 'AddUpdateScreen.dart';
import 'lib.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({
    super.key,
  });

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  var allData = <Map<String, dynamic>>[];
  @override
  void initState() {
    super.initState();
    //全件を取得
    _createList();
  }

  @override
  void didUpdateWidget(covariant ListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _createList();
  }

  void _createList() async {
    var buf = await DbHelper().getHakkeMain();
    setState(() {
      allData = buf;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: allData.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: Icon(
                Icons.view_kanban,
                size: 40,
                color: lib.omikuziColor[allData[index]['result']],
              ),
              title: Text(
                  '${allData[index]['location']} ${lib.resultList[allData[index]['result']]}',
              ),
              subtitle: Text(
                DateFormat('yyyy/MM/dd').format(
                  DateTime.fromMillisecondsSinceEpoch(allData[index]['date'])),
              ),
              onTap: () async {
                //タップしたら詳細画面に遷移
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        AddUpdateScreen(id: allData[index]['id']),
                  ),
                );
                setState(() {
                  _createList();
                });
              },
            );
          }),
    );
  }
}
