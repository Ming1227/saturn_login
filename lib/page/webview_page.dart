import 'package:flutter/material.dart';

class SCWebViewPage extends StatelessWidget {
  const SCWebViewPage({
    Key? key,
    this.title,
    this.content,
  }) : super(key: key);

  final String? title;
  final String? content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(title ?? ''),
      ),
      body: Center(
        child: Text(content ?? '这里是内容'),
      ),
    );
  }
}
