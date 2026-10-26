import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

Widget buildFacebookPlayer(String videoUrl) {
  final encodedUrl = Uri.encodeComponent(videoUrl);
  final embedUrl =
      'https://www.facebook.com/plugins/video.php?href=$encodedUrl&show_text=false&autoplay=true';
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse(embedUrl));
  return WebViewWidget(controller: controller);
}
