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
    return const MaterialApp(
      title: 'Date and Time',
      home: TimeDisplay(),
    );
  }
}

class TimeDisplay extends StatefulWidget {
  const TimeDisplay({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TimeDisplayState createState() => _TimeDisplayState();
}

class _TimeDisplayState extends State<TimeDisplay> {
  late Timer _timer;
  final StreamController<DateTime> _timeController = StreamController<DateTime>();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      _timeController.add(DateTime.now().toLocal());
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
      initialData: DateTime.now().toLocal(),
      builder: (context, snapshot) {
        return Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                DateFormat("yyyy:MM:dd").format(snapshot.data!),
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "${snapshot.data?.hour.toString().padLeft(2, '0')}:${snapshot.data?.minute.toString().padLeft(2, '0')}:${snapshot.data?.second.toString().padLeft(2, '0')}:${snapshot.data?.millisecond.toString().padLeft(3, '0')}",
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
