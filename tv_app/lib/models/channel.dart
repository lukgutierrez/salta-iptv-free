enum ChannelType { hls, youtube, facebook, unknown }

class Channel {
  final String id;
  final int number;
  final String name;
  final String category;
  final ChannelType type;
  final String url;
  final String logo;
  final String? videoId;
  final String? youtubeChannelId;
  final bool isLive;

  const Channel({
    required this.id,
    required this.number,
    required this.name,
    required this.category,
    required this.type,
    required this.url,
    required this.logo,
    this.videoId,
    this.youtubeChannelId,
    this.isLive = true,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    ChannelType parseType(String? t) {
      switch (t?.toLowerCase()) {
        case 'hls':
          return ChannelType.hls;
        case 'youtube':
          return ChannelType.youtube;
        case 'facebook':
          return ChannelType.facebook;
        default:
          return ChannelType.unknown;
      }
    }

    String? extractVideoId(String? vid, String? url) {
      if (vid != null && vid.length == 11) return vid;
      if (url == null) return null;
      final uri = Uri.tryParse(url);
      if (uri == null) return null;
      if (uri.queryParameters.containsKey('v')) {
        return uri.queryParameters['v'];
      }
      final segments = uri.pathSegments;
      if (segments.contains('live') && segments.length > segments.indexOf('live') + 1) {
        final id = segments[segments.indexOf('live') + 1];
        if (id.length == 11) return id;
      }
      if (segments.isNotEmpty && segments.last.length == 11) {
        return segments.last;
      }
      return null;
    }

    return Channel(
      id: json['id'] ?? '',
      number: json['number'] ?? 0,
      name: json['name'] ?? 'Canal',
      category: json['category'] ?? 'General',
      type: parseType(json['type']),
      url: json['url'] ?? '',
      logo: json['logo'] ?? '',
      videoId: extractVideoId(json['video_id'], json['url']),
      youtubeChannelId: json['youtube_channel_id'],
      isLive: json['is_live'] ?? true,
    );
  }
}
