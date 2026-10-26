enum ChannelType { hls, youtube, facebook, unknown }

class Channel {
  final String id;
  final int number;
  final String name;
  final String category;
  final ChannelType type;
  final String url;
  final String logo;
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

    return Channel(
      id: json['id'] ?? '',
      number: json['number'] ?? 0,
      name: json['name'] ?? 'Canal',
      category: json['category'] ?? 'General',
      type: parseType(json['type']),
      url: json['url'] ?? '',
      logo: json['logo'] ?? '',
      youtubeChannelId: json['youtube_channel_id'],
      isLive: json['is_live'] ?? true,
    );
  }
}
