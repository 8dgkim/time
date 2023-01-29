import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time',
      home: TimeDisplay(),
      // home: Clock(),
    );
  }
}


class TimeDisplay extends StatefulWidget {
  @override
  _TimeDisplayState createState() => _TimeDisplayState();
}

class _TimeDisplayState extends State<TimeDisplay> {
  late Timer _timer;
  StreamController<DateTime> _timeController = StreamController<DateTime>();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      _timeController.add(DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _timeController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: _timeController.stream,
      initialData: DateTime.now(),
      builder: (context, snapshot) {
        return Container(
          alignment: Alignment.center,
          child: Text(
            "${snapshot.data?.hour.toString().padLeft(2, '0')}:${snapshot.data?.minute.toString().padLeft(2, '0')}:${snapshot.data?.second.toString().padLeft(2, '0')}:${snapshot.data?.millisecond.toString().padLeft(3, '0')}",
            style: const TextStyle(
              fontSize: 40,
              color: Colors.white,
              decoration: TextDecoration.none,
            ),
          ),
        );
      },
    );
  }
}


