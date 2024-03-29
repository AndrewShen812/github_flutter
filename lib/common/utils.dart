import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

Widget gmAvatar(String url, {
  double width = 30,
  double height,
  BoxFit fit,
  BorderRadius borderRadius,
}) {
  var placeholder = Image.asset(
      "images/avatar_def.png", //头像占位图，加载过程中显示
      width: width,
      height: height
  );
  return ClipRRect(
    borderRadius: borderRadius ?? BorderRadius.circular(2),
    child: CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) =>placeholder,
      errorWidget: (context, url, error) =>placeholder,
    ),
  );
}

void showLoading(BuildContext context, {
  String text = "正在加载，请稍候..."
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(text),
            )
          ],
        ),
      );
    }
  );
}

void showToast(BuildContext context, String text) {
  Toast.show(text, context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
}