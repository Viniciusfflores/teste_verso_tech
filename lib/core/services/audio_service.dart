import 'dart:developer';
import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _sfxPlayer = AudioPlayer();

  AudioService(){
    _sfxPlayer.setAudioSource(
        AudioSource.asset('assets/audio/button7.wav'),
        preload: false
    ).catchError((_) {});
  }

  Future<void> playSfx({String path = '', double volume = 1.0, bool loop = false}) async {
    try {
      if (_sfxPlayer.playing) {
        await _sfxPlayer.stop();
      }

      await _sfxPlayer.setAudioSource(
        AudioSource.asset(path),
      );
      await _sfxPlayer.setLoopMode(loop ? LoopMode.all : LoopMode.off);
      await _sfxPlayer.setVolume(volume);
      await _sfxPlayer.play();
    } catch (e) {
      log('Erro ao tocar som: $e', name: 'AudioService');
    }
  }
  void dispose() {
    _sfxPlayer.dispose();
  }
}