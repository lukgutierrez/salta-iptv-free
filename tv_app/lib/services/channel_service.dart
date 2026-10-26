import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/channel.dart';

class ChannelService {
  static const String remoteConfigUrl =
      'https://raw.githubusercontent.com/lukgutierrez/salta-iptv-free/main/channels.json';

  static final List<Channel> defaultChannels = [
    const Channel(
      id: 'canal10_salta',
      number: 1,
      name: 'Canal 10 Salta',
      category: 'Salta',
      type: ChannelType.hls,
      url: 'https://el10tvstream.digitalnoa.com.ar/memfs/accd8bcb-61b0-416b-bf02-0245cb8267f6.m3u8',
      logo: 'https://i.imgur.com/don0WSG.png',
    ),
    const Channel(
      id: 'multivision_salta',
      number: 2,
      name: 'Multivisión Federal',
      category: 'Salta',
      type: ChannelType.hls,
      url: 'https://videostream.shockmedia.com.ar:19360/multivisionfederal/multivisionfederal.m3u8',
      logo: 'https://i.imgur.com/jX0lqy3.png',
    ),
    const Channel(
      id: 'canal7_salta',
      number: 3,
      name: 'Canal 7 Salta (Tito Cruz)',
      category: 'Salta',
      type: ChannelType.hls,
      url: 'https://vivo.solumedia.com:19360/cooperativa/cooperativa.m3u8',
      logo: 'https://i.imgur.com/CudG6sl.png',
    ),
    const Channel(
      id: 'quepasasalta_live',
      number: 5,
      name: 'Qué Pasa Salta Live',
      category: 'Salta Digital',
      type: ChannelType.youtube,
      videoId: 'm97u-m5zTBM',
      url: 'https://www.youtube.com/watch?v=m97u-m5zTBM',
      youtubeChannelId: 'UCCK36hidVt22mcdXIO8u3_g',
      logo: 'https://i1.quepasasalta.com.ar/files/image/228/228448/671a8d57769f6.png',
    ),
    const Channel(
      id: 'somostv_rosariodelerma',
      number: 6,
      name: 'Somos TV Rosario de Lerma',
      category: 'Salta Digital',
      type: ChannelType.youtube,
      videoId: 'xR3VUvGyXk0',
      url: 'https://www.youtube.com/watch?v=xR3VUvGyXk0',
      youtubeChannelId: 'SomosTvDigital',
      logo: 'https://i.imgur.com/CudG6sl.png',
    ),
    const Channel(
      id: 'elonce_salta',
      number: 7,
      name: 'El Once TV (Telefe Salta)',
      category: 'Salta Digital',
      type: ChannelType.youtube,
      videoId: '6v6iCX_2WDA',
      url: 'https://www.youtube.com/watch?v=6v6iCX_2WDA',
      youtubeChannelId: 'ElOnceTvSalta',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/13/Telefe_Salta_%282018%29.png/960px-Telefe_Salta_%282018%29.png',
    ),
    const Channel(
      id: 'tyc_sports',
      number: 8,
      name: 'TyC Sports HD',
      category: 'Deportes',
      type: ChannelType.hls,
      url: 'https://amg26268-amg26268c14-freelivesports-emea-10267.playouts.now.amagi.tv/ts-us-e2-n2/playlist/amg26268-sportsstudio-tycsports-freelivesportsemea/playlist.m3u8',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/54/TyC_Sports_logo.svg/960px-TyC_Sports_logo.svg.png',
    ),
    const Channel(
      id: 'canal26',
      number: 9,
      name: 'Canal 26 HD',
      category: 'Noticias',
      type: ChannelType.hls,
      url: 'https://stream-gtlc.telecentro.net.ar/hls/canal26hls/main.m3u8',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Canal_26_logo_%282023%29.png/800px-Canal_26_logo_%282023%29.png',
    ),
  ];

  Future<List<Channel>> fetchChannels() async {
    try {
      final response = await http
          .get(Uri.parse(remoteConfigUrl))
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> channelsJson = data['channels'] ?? [];
        return channelsJson.map((item) => Channel.fromJson(item)).toList();
      }
    } catch (e) {
      // Fallback
    }
    return defaultChannels;
  }
}
