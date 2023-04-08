// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Metronome',
//       home: MetronomePage(),
//     );
//   }
// }

// class MetronomePage extends StatefulWidget {
//   @override
//   _MetronomePageState createState() => _MetronomePageState();
// }

// class _MetronomePageState extends State<MetronomePage> {
//   final AudioPlayer _player = AudioPlayer();
//   int _bpm = 120;
//   bool _playing = false;
//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();
//     _player.setAsset('assets/click.mp3');
//   }

//   @override
//   void dispose() {
//     _player.dispose();
//     super.dispose();
//   }

//   void _startStop() {
//     if (_playing) {
//       _timer?.cancel();
//       _playing = false;
//       setState(() {});
//     } else {
//       _playing = true;
//       final double interval = 60 / _bpm;
//       _timer = Timer.periodic(Duration(seconds: interval.toInt()), (_) {
//         _player.seek(Duration.zero);
//         _player.play();
//       });
//       setState(() {});
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Metronome'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'BPM: $_bpm',
//               style: TextStyle(fontSize: 24),
//             ),
//             SizedBox(height: 20),
//             TextButton(
//               onPressed: _startStop,
//               child: Text(
//                 _playing ? 'Stop' : 'Start',
//                 style: TextStyle(fontSize: 24),
//               ),
//             ),
//             SizedBox(height: 20),
//             Slider(
//               value: _bpm.toDouble(),
//               min: 60,
//               max: 240,
//               divisions: 60,
//               onChanged: (double value) {
//                 setState(() {
//                   _bpm = value.toInt();
//                 });
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
