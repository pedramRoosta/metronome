import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Metronome',
      home: MetronomePage(),
    );
  }
}

class MetronomePage extends StatefulWidget {
  const MetronomePage({super.key});

  @override
  State<MetronomePage> createState() => _MetronomePageState();
}

class _MetronomePageState extends State<MetronomePage> {
  final AudioPlayer _playerDown = AudioPlayer();
  final AudioPlayer _playerUp = AudioPlayer();
  final textCtrl = TextEditingController();
  double minBpm = 60;
  double maxBpm = 240;
  int _bpm = 120;
  int index = 1;
  bool _playing = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _playerDown.setAsset('assets/audio/up.mp3');
    _playerUp.setAsset('assets/audio/down.mp3');
  }

  @override
  void dispose() {
    _playerDown.dispose();
    _playerUp.dispose();
    super.dispose();
  }

  void _startStop() async {
    if (_playing) {
      setState(() {
        _timer?.cancel();
        _playing = false;
        index = 1;
      });
    } else {
      _playing = true;
      changeBpm();
    }
  }

  void changeBpm() {
    _timer?.cancel();
    final interval = ((60 / _bpm) * 1000).floor().toInt();
    index = 1;
    _timer = Timer.periodic(Duration(milliseconds: interval), (_) async {
      if (index < 4) {
        await _playerDown.seek(Duration.zero);
        await _playerDown.play();
        index++;
      } else {
        await _playerUp.seek(Duration.zero);
        await _playerUp.play();
        index = 1;
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColorDark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metronome'),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'BPM: $_bpm',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            Slider(
              value: _bpm.toDouble(),
              min: minBpm,
              max: maxBpm,
              divisions: 60,
              onChanged: (double value) {
                setState(() {
                  _bpm = value.toInt();
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: const Text('Snap every'),
                ),
                SizedBox(
                  width: 60,
                  height: 50,
                  child: TextField(
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), counterText: ''),
                    controller: textCtrl,
                    maxLength: 3,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          final snapValue = int.parse(textCtrl.text);
                          final finalBpm = _bpm + snapValue;
                          if (finalBpm <= maxBpm) {
                            setState(() {
                              _bpm = finalBpm;
                            });
                            changeBpm();
                          }
                        },
                        child: Icon(
                          Icons.arrow_upward,
                          size: 50,
                          color: color,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          final snapValue = int.parse(textCtrl.text);
                          final finalBpm = _bpm - snapValue;
                          if (finalBpm >= minBpm) {
                            setState(() {
                              _bpm = finalBpm;
                            });
                            changeBpm();
                          }
                        },
                        child: Icon(
                          Icons.arrow_downward,
                          color: color,
                          size: 50,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 50,
              height: 70,
              child: ElevatedButton(
                onPressed: _startStop,
                child: Text(
                  _playing ? 'Stop' : 'Start',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
