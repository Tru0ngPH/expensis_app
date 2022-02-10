import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveFlatButton extends StatelessWidget {
  const AdaptiveFlatButton({
    Key? key,
    required this.text,
    required this.handle,
  }) : super(key: key);

  final String text;
  final Function handle;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            color: Colors.lightGreen,
            onPressed: () => handle(),
            child: Text(text),
          )
        : TextButton(
            onPressed: () => handle(),
            child: Text(text),
          );
  }
}
