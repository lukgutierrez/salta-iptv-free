import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

Widget buildFacebookPlayer(String videoUrl) {
  final encodedUrl = Uri.encodeComponent(videoUrl);

  String embedUrl;
  if (videoUrl.contains('/videos/') ||
      videoUrl.contains('/watch') ||
      videoUrl.contains('/live')) {
    embedUrl =
        'https://www.facebook.com/plugins/video.php?href=$encodedUrl&show_text=false&autoplay=true';
  } else {
    embedUrl =
        'https://www.facebook.com/plugins/page.php?href=$encodedUrl&tabs=timeline&width=800&height=600&small_header=true&adapt_container_width=true&hide_cover=false';
  }

  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse(embedUrl));
  return WebViewWidget(controller: controller);
}
