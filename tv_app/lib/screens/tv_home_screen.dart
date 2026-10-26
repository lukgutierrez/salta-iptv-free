import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/channel.dart';
import '../services/channel_service.dart';
import '../widgets/video_player_view.dart';

class TvHomeScreen extends StatefulWidget {
  const TvHomeScreen({super.key});

  @override
  State<TvHomeScreen> createState() => _TvHomeScreenState();
}

class _TvHomeScreenState extends State<TvHomeScreen> {
  final ChannelService _channelService = ChannelService();
  List<Channel> _channels = [];
  int _currentIndex = 0;
  bool _isLoading = true;
  bool _showOverlay = true;
  bool _showChannelList = false;
  Timer? _overlayTimer;
  final FocusNode _mainFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadChannels();
  }

  Future<void> _loadChannels() async {
    final list = await _channelService.fetchChannels();
    if (mounted) {
      setState(() {
        _channels = list;
        _isLoading = false;
      });
      _startOverlayTimer();
    }
  }

  void _startOverlayTimer() {
    _overlayTimer?.cancel();
    _overlayTimer = Timer(const Duration(seconds: 4), () {
      if (mounted && !_showChannelList) {
        setState(() {
          _showOverlay = false;
        });
      }
    });
  }

  void _toggleOverlay() {
    setState(() {
      _showOverlay = !_showOverlay;
    });
    if (_showOverlay) {
      _startOverlayTimer();
    }
  }

  void _selectChannel(int index) {
    if (index >= 0 && index < _channels.length) {
      setState(() {
        _currentIndex = index;
        _showOverlay = true;
        _showChannelList = false;
      });
      _startOverlayTimer();
    }
  }

  void _nextChannel() {
    if (_channels.isEmpty) return;
    int next = (_currentIndex + 1) % _channels.length;
    _selectChannel(next);
  }

  void _previousChannel() {
    if (_channels.isEmpty) return;
    int prev = (_currentIndex - 1 + _channels.length) % _channels.length;
    _selectChannel(prev);
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        if (_showChannelList) {
          return KeyEventResult.ignored; // Permite navegar la lista
        }
        _nextChannel();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        if (_showChannelList) {
          return KeyEventResult.ignored;
        }
        _previousChannel();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.select ||
          event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        setState(() {
          _showChannelList = !_showChannelList;
          _showOverlay = true;
        });
        if (!_showChannelList) _startOverlayTimer();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.escape ||
          event.logicalKey == LogicalKeyboardKey.goBack) {
        if (_showChannelList) {
          setState(() {
            _showChannelList = false;
          });
          _startOverlayTimer();
          return KeyEventResult.handled;
        }
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  void dispose() {
    _overlayTimer?.cancel();
    _mainFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.redAccent),
              SizedBox(height: 16),
              Text(
                'Cargando grilla de canales...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    if (_channels.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'No se encontraron canales disponibles.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final currentChannel = _channels[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Focus(
        focusNode: _mainFocusNode,
        autofocus: true,
        onKeyEvent: _handleKeyEvent,
        child: GestureDetector(
          onTap: _toggleOverlay,
          child: Stack(
            children: [
              // Reproductor de Video en Pantalla Completa
              Positioned.fill(
                child: VideoPlayerView(
                  key: ValueKey(currentChannel.id),
                  channel: currentChannel,
                ),
              ),

              // Barra de Información del Canal (Overlay estilo Cable TV)
              if (_showOverlay)
                Positioned(
                  top: 24,
                  left: 24,
                  right: 24,
                  child: AnimatedOpacity(
                    opacity: _showOverlay ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'CH ${currentChannel.number}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  currentChannel.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  '${currentChannel.category} • ${currentChannel.type.name.toUpperCase()}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.menu,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _showChannelList = !_showChannelList;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Grilla Lateral de Canales (Zapping rápido)
              if (_showChannelList)
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  width: 320,
                  child: Container(
                    color: Colors.black.withOpacity(0.92),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 40, 16, 12),
                          child: const Row(
                            children: [
                              Icon(Icons.tv, color: Colors.redAccent),
                              SizedBox(width: 10),
                              Text(
                                'Guía de Canales',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(color: Colors.white24, height: 1),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _channels.length,
                            itemBuilder: (context, index) {
                              final ch = _channels[index];
                              final isSelected = index == _currentIndex;
                              return ListTile(
                                autofocus: isSelected,
                                selected: isSelected,
                                selectedTileColor:
                                    Colors.redAccent.withOpacity(0.3),
                                leading: Container(
                                  width: 36,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${ch.number}',
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.redAccent
                                          : Colors.white60,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  ch.name,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white70,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                                subtitle: Text(
                                  ch.category,
                                  style: const TextStyle(
                                    color: Colors.white38,
                                    fontSize: 12,
                                  ),
                                ),
                                onTap: () => _selectChannel(index),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
