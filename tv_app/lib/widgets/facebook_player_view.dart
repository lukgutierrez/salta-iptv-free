import 'package:flutter/material.dart';
import 'facebook_player_stub.dart'
    if (dart.library.js_interop) 'facebook_player_web.dart'
    if (dart.library.io) 'facebook_player_mobile.dart';

class FacebookPlayerView extends StatelessWidget {
  final String videoUrl;

  const FacebookPlayerView({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return buildFacebookPlayer(videoUrl);
  }
}
