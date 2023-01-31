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
      title: 'Spacetime',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

// class HomeState extends State<Home> {
//   bool _areButtonsVisible = false;

//   void _toggleButtonsVisibility() {
//     setState(() {
//       _areButtonsVisible = !_areButtonsVisible;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const SizedBox(height: 250),
//             const TimeDisplay(),
//             const SizedBox(height: 250),
//             // NavigatorCircleButton(),
//             Stack(
//               children: <Widget>[
//                 NavigatorCircleButton(
//                   onPressed: _toggleButtonsVisibility,
//                 ),
//                 if (_areButtonsVisible) ...[
//                   // Add the four buttons that appear when the main button is pressed here
//                   TaskButtons(onPressed: _toggleButtonsVisibility)
//                 ],
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class HomeState extends State<Home> {
  bool _areButtonsVisible = false;

  void _toggleButtonsVisibility() {
    setState(() {
      _areButtonsVisible = !_areButtonsVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Flex(
          // mainAxisAlignment: MainAxisAlignment.center,
          direction: Axis.vertical,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  SizedBox(height: 250),
                  TimeDisplay(),
                  SizedBox(height: 250),
                ],
              ),
            ),
              Stack(
                // overflow: Overflow.visible,
                children: <Widget>[
                  NavigatorCircleButton(
                    onPressed: _toggleButtonsVisibility,
                  ),
                  if (_areButtonsVisible) ...[
                    Stack(
                      children: <Widget>[
                        Positioned(
                          top: -100,
                          left: -100,
                          child: TaskButtons(onPressed: _toggleButtonsVisibility),
                        ),
                        Positioned(
                          top: -100,
                          right: -100,
                          child: TaskButtons(onPressed: _toggleButtonsVisibility),
                        ),
                        Positioned(
                          bottom: -100,
                          left: -100,
                          child: TaskButtons(onPressed: _toggleButtonsVisibility),
                        ),
                        Positioned(
                          bottom: -100,
                          right: -100,
                          child: TaskButtons(onPressed: _toggleButtonsVisibility),
                        ),
                      ],
                    )
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// class HomeState extends State<Home> {
//   bool _areButtonsVisible = false;

//   void _toggleButtonsVisibility() {
//     setState(() {
//       _areButtonsVisible = !_areButtonsVisible;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: Flex(
//           direction: Axis.vertical,
//           children: <Widget>[
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: const <Widget>[
//                   SizedBox(height: 250),
//                   TimeDisplay(),
//                   SizedBox(height: 250),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Stack(
//                 children: <Widget>[
//                   NavigatorCircleButton(
//                     onPressed: _toggleButtonsVisibility,
//                   ),
//                   if (_areButtonsVisible) ...[
//                     TaskButtons(onPressed: _toggleButtonsVisibility)
//                   ],
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




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
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "${snapshot.data?.hour.toString().padLeft(2, '0')}:${snapshot.data?.minute.toString().padLeft(2, '0')}:${snapshot.data?.second.toString().padLeft(2, '0')}:${snapshot.data?.millisecond.toString().padLeft(3, '0')}",
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}




class NavigatorCircleButton extends StatefulWidget {
  const NavigatorCircleButton({super.key, required void Function() onPressed});

  @override
  // ignore: library_private_types_in_public_api
  _NavigatorCircleButtonState createState() => _NavigatorCircleButtonState();
}

class _NavigatorCircleButtonState extends State<NavigatorCircleButton> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        LimitedBox(
          maxWidth: 56,
          maxHeight: 56,
          child: AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
            bottom: _isExpanded ? 60 : 0,
            right: _isExpanded ? 60 : 0,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.circle,
                color: Colors.black,
                size: 50
              ),
            ),
          ),
        ),
        // LimitedBox(
        //   maxWidth: 56,
        //   maxHeight: 56,
        //   child: AnimatedPositioned(
        //     duration: const Duration(milliseconds: 200),
        //     curve: Curves.easeIn,
        //     bottom: _isExpanded ? 0 : 60,
        //     right: _isExpanded ? 0 : 60,
        //     child: FloatingActionButton(
        //       onPressed: () {},
        //       backgroundColor: Colors.transparent,
        //       child: Container(),
        //     ),
        //   ),
        // ),
        // LimitedBox(
        //   maxWidth: 56,
        //   maxHeight: 56,
        //   child: AnimatedPositioned(
        //     duration: const Duration(milliseconds: 200),
        //     curve: Curves.easeIn,
        //     bottom: _isExpanded ? 0 : 60,
        //     right: _isExpanded ? 0 : 60,
        //     child: FloatingActionButton(
        //       onPressed: () {},
        //       backgroundColor: Colors.transparent,
        //       child: Container(),
        //     ),
        //   ),
        // ),
        // LimitedBox(
        //   maxWidth: 56,
        //   maxHeight: 56,
        //   child: AnimatedPositioned(
        //     duration: const Duration(milliseconds: 200),
        //     curve: Curves.easeIn,
        //     bottom: _isExpanded ? 0 : 60,
        //     right: _isExpanded ? 0 : 60,
        //     child: FloatingActionButton(
        //       onPressed: () {},
        //       backgroundColor: Colors.transparent,
        //       child: Container(),
        //     ),
        //   ),
        // ),
        // LimitedBox(
        //   maxWidth: 56,
        //   maxHeight: 56,
        //   child: AnimatedPositioned(
        //     duration: const Duration(milliseconds: 200),
        //     curve: Curves.easeIn,
        //     bottom: _isExpanded ? 0 : 60,
        //     right: _isExpanded ? 0 : 60,
        //     child: FloatingActionButton(
        //       onPressed: () {},
        //       backgroundColor: Colors.transparent,
        //       child: Container(),
        //     ),
        //   ),
        // ),
      ]
    );
  }
}

class TaskButtons extends StatefulWidget {
  const TaskButtons({super.key, required void Function() onPressed});

  @override
  // ignore: library_private_types_in_public_api
  _TaskButtonsState createState() => _TaskButtonsState();
}

class _TaskButtonsState extends State<TaskButtons> {
  final bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        LimitedBox(
          maxWidth: 56,
          maxHeight: 56,
          child: AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
            bottom: _isExpanded ? 0 : 60,
            right: _isExpanded ? 0 : 60,
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.transparent,
              child: Container(),
            ),
          ),
        ),
        LimitedBox(
          maxWidth: 56,
          maxHeight: 56,
          child: AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
            bottom: _isExpanded ? 0 : 60,
            right: _isExpanded ? 0 : 60,
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.transparent,
              child: Container(),
            ),
          ),
        ),
        LimitedBox(
          maxWidth: 56,
          maxHeight: 56,
          child: AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
            bottom: _isExpanded ? 0 : 60,
            right: _isExpanded ? 0 : 60,
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.transparent,
              child: Container(),
            ),
          ),
        ),
        LimitedBox(
          maxWidth: 56,
          maxHeight: 56,
          child: AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
            bottom: _isExpanded ? 0 : 60,
            right: _isExpanded ? 0 : 60,
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.transparent,
              child: Container(),
            ),
          ),
        ),
      ]
    );
  }
}
