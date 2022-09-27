import 'package:flutter/material.dart';
import 'package:saturn/saturn.dart';
import 'package:saturn_login/utils/area_code_constant.dart';
import 'package:saturn_routers/sc_routers.dart';

// ignore: must_be_immutable
class SCAreaCodePage extends StatelessWidget {
  SCAreaCodePage({
    Key? key,
    this.onChanged,
  }) : super(key: key);

  final void Function(Map<String, String>)? onChanged;

  Map<String, dynamic> _map = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text('国家或地区选择'),
        leading: STButton.icon(
          backgroundColor: Colors.transparent,
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
          onTap: () {
            SCRouters.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
        future: _getAreaCodes(context),
        builder: (context, snap) {
          List<String> titles = [];
          for (var item in _map.keys) {
            titles.add(item);
          }
          List<String> values = [];
          for (var item in _map.values) {
            values.add(item.toString());
          }
          return MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeBottom: true,
            child: ListView.builder(
                itemCount: titles.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      title: Text(
                        titles[index],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Text(
                        '+${values[index]}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF555555),
                        ),
                      ),
                      onTap: () {
                        final selectArea = {titles[index]: values[index]};
                        if (onChanged != null) onChanged!(selectArea);
                        SCRouters.pop(context);
                      });
                }),
          );
        },
      ),
    );
  }

  Future _getAreaCodes(BuildContext context) async {
    _map = SCAreaCodeConstant.worldCodes;
    // 请求接口
  }
}
