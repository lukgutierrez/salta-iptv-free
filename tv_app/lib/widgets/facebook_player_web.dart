import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

Widget buildFacebookPlayer(String videoUrl) {
  final viewType = 'facebook-player-${videoUrl.hashCode}';
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

  ui_web.platformViewRegistry.registerViewFactory(
    viewType,
    (int viewId) {
      final iframe = web.document.createElement('iframe') as web.HTMLIFrameElement;
      iframe.src = embedUrl;
      iframe.style.border = 'none';
      iframe.style.width = '100%';
      iframe.style.height = '100%';
      iframe.allow =
          'autoplay; clipboard-write; encrypted-media; picture-in-picture; web-share';
      iframe.setAttribute('allowFullScreen', 'true');
      return iframe;
    },
  );

  return HtmlElementView(viewType: viewType);
}
