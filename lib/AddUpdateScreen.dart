import 'package:flutter/material.dart';
import 'package:hakke_omikuzi_toukei/DbHelper.dart';
import 'package:intl/intl.dart';
import 'lib.dart';

class AddUpdateScreen extends StatefulWidget {
  final int id;
  const AddUpdateScreen({super.key, required this.id});
  @override
  State<AddUpdateScreen> createState() => _AddUpdateScreenState();
}

class _AddUpdateScreenState extends State<AddUpdateScreen> {
  int id = 0; //初期化
  bool isUpdate = false; //初期化
  //DBのデータ取得用
  int result = 4;
  int selfResult = 2;
  int dateSinceEpoch = DateTime.now().millisecondsSinceEpoch;
  String location = "";
  String memo = "";
  //日付の表示用
  String date = DateFormat('yyyy/MM/dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    id = widget.id;
    if (id != 0) {
      //更新の場合
      isUpdate = true;
      DbHelper().getHakkeMainById(id).then((value) {
        setState(() {
          result = value['result'];
          selfResult = value['selfResult'];
          dateSinceEpoch = value['date'];
          memo = value['memo'];
          location = value['location'];
          date = DateFormat('yyyy/MM/dd')
              .format(DateTime.fromMillisecondsSinceEpoch(dateSinceEpoch));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;
    double screenWidth = MediaQuery.of(context).size.width;
    double marginPercent(percentage) {
      return screenWidth * percentage / 100;
    }

    return GestureDetector(
      onTap: () {
        // 画面の任意の位置をタップしたときにキーボードを閉じる
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: (isUpdate) ? const Text('おみくじ統計 更新') : const Text('おみくじ統計 新規'),
        ),
        body: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomSpace),
            child: Column(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 40,
                      ),
                      child: Row(
                        children: [
                          const Text('結果', style: TextStyle(fontSize: 20)),
                          SizedBox(width: marginPercent(20)),
                          DropdownButton(
                            items: lib.resultList
                                .map<DropdownMenuItem<int>>((String value) {
                              return DropdownMenuItem<int>(
                                value: lib.resultList.indexOf(value),
                                child: Text(value),
                              );
                            }).toList(),
                            value: result,
                            onChanged: (int? value) {
                              setState(() {
                                result = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 40,
                      ),
                      child: Row(
                        children: [
                          const Text('内容', style: TextStyle(fontSize: 20)),
                          SizedBox(width: marginPercent(10)),
                          DropdownButton(
                            items: lib.selfResultList
                                .map<DropdownMenuItem<int>>((String value) {
                              return DropdownMenuItem<int>(
                                value: lib.selfResultList.indexOf(value),
                                child: Text(value),
                              );
                            }).toList(),
                            value: selfResult,
                            onChanged: (int? value) {
                              setState(() {
                                selfResult = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 40,
                      ),
                      child: Row(
                        children: [
                          const Text('日時', style: TextStyle(fontSize: 20)),
                          SizedBox(width: marginPercent(15)),
                          OutlinedButton(
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate:
                                    DateTime.fromMillisecondsSinceEpoch(
                                        dateSinceEpoch),
                                firstDate: DateTime(1990),
                                lastDate: DateTime(2080),
                              ).then((value) {
                                if (value != null) {
                                  setState(() {
                                    dateSinceEpoch =
                                        value.millisecondsSinceEpoch;
                                    date =
                                        DateFormat('yyyy/MM/dd').format(value);
                                  });
                                }
                              });
                            },
                            child: Text(date),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 40,
                      ),
                      child: Column(children: [
                        TextField(
                          decoration: const InputDecoration(
                            labelText: '場所',
                          ),
                          controller: TextEditingController(text: location),
                          onChanged: (value) {
                            location = value;
                          },
                        )
                      ]),
                    ),
                    Container(
                      margin: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: '印象に残った一文など',
                        ),
                        controller: TextEditingController(text: memo),
                        onChanged: (value) {
                          memo = value;
                        },
                      ),
                    ),
                  ],
                ),
                OutlinedButton(
                  onPressed: () {
                    if (!checkLocationColumn(location)) {
                      columnErrorDialog(context, '場所');
                      return;
                    }

                    //更新処理
                    if (isUpdate) {
                      DbHelper().updateHakkeMainById(id, result, selfResult,
                          dateSinceEpoch, location, memo);
                    } else {
                      DbHelper().insertHakkeMain(
                          result, selfResult, dateSinceEpoch, location, memo);
                    }
                    Navigator.pop(context);
                  },
                  child: (isUpdate) ? const Text('更新') : const Text('追加'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> columnErrorDialog(BuildContext context, String column) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('エラー'),
          content: Text('$columnが未入力です。'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

//追加画面の入力チェック
bool checkLocationColumn(String location) {
  if (location.length > 100 ||
      location.isEmpty) {
    return false;
  }
  return true;
}
