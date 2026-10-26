import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../models/channel.dart';
import 'facebook_player_view.dart';

class VideoPlayerView extends StatefulWidget {
  final Channel channel;

  const VideoPlayerView({super.key, required this.channel});

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  VideoPlayerController? _videoController;
  YoutubePlayerController? _ytController;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeChannel();
  }

  @override
  void didUpdateWidget(covariant VideoPlayerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.channel.id != widget.channel.id) {
      _initializeChannel();
    }
  }

  void _disposeControllers() {
    _videoController?.pause();
    _videoController?.dispose();
    _videoController = null;

    _ytController?.close();
    _ytController = null;
  }

  Future<void> _initializeChannel() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    _disposeControllers();

    if (widget.channel.type == ChannelType.hls) {
      try {
        final controller = VideoPlayerController.networkUrl(
          Uri.parse(widget.channel.url),
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        );
        _videoController = controller;
        await controller.initialize();
        await controller.play();
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Error al cargar la señal de video.';
          });
        }
      }
    } else if (widget.channel.type == ChannelType.youtube) {
      final videoId = widget.channel.videoId;
      if (videoId != null && videoId.isNotEmpty) {
        try {
          final yt = YoutubePlayerController.fromVideoId(
            videoId: videoId,
            autoPlay: true,
            params: const YoutubePlayerParams(
              showControls: true,
              mute: false,
              showFullscreenButton: true,
              loop: true,
              enableCaption: false,
            ),
          );

          _ytController = yt;
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        } catch (e) {
          if (mounted) {
            setState(() {
              _isLoading = false;
              _errorMessage = 'Error al inicializar YouTube.';
            });
          }
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'No se encontró ID de transmisión activa.';
        });
      }
    } else if (widget.channel.type == ChannelType.facebook) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Tipo de transmisión no soportado.';
      });
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.amber, size: 54),
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              widget.channel.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      );
    }

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.redAccent,
        ),
      );
    }

    if (widget.channel.type == ChannelType.hls &&
        _videoController != null &&
        _videoController!.value.isInitialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: _videoController!.value.aspectRatio > 0
              ? _videoController!.value.aspectRatio
              : 16 / 9,
          child: VideoPlayer(_videoController!),
        ),
      );
    }

    if (widget.channel.type == ChannelType.youtube && _ytController != null) {
      return Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: YoutubePlayer(
            controller: _ytController!,
            aspectRatio: 16 / 9,
          ),
        ),
      );
    }

    if (widget.channel.type == ChannelType.facebook) {
      return Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: FacebookPlayerView(videoUrl: widget.channel.url),
        ),
      );
    }

    return const SizedBox();
  }
}
