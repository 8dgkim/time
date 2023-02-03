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

// Home class that collects all the other subclasses
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  int _selectedIndex = 1;

  static const TextStyle optionStyle =
    TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.bold,
      fontFamily: 'Times New Roman',
      color: Colors.white,
    );
   
  static final List<Widget> _widgetOptions = <Widget>[  
    Container(
      color: Colors.black87,
      alignment: Alignment.center,
      child: const Text('Priority', style: optionStyle),
    ),
    Container (
      color: Colors.black,
      alignment: Alignment.center,
      child: const TimeDisplay(),
    ),
    Container(
      color: Colors.black87,
      alignment: Alignment.center,
      // child: const Text('Future', style: optionStyle),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text('T-Time Counter', style: optionStyle,),
          SizedBox(height: 100),
          TTime(),
        ],
      )
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Everything is possible', style: optionStyle, textAlign: TextAlign.center),
      //   backgroundColor: Colors.black,
      // ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list, color: Colors.white),
            label: 'Priority',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.circle_outlined, color: Colors.white),
            label: 'SpaceTime',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_mark_sharp, color: Colors.white),
            label: 'Future',
          ),
        ],
        backgroundColor: Colors.black,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.transparent,
        selectedLabelStyle: const TextStyle(color: Colors.white),
        unselectedLabelStyle: const TextStyle(color: Colors.white),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
      ),
    );
  }
}





/// SpaceTime (Center BarItem index = 1)
/// 
/// Displays date and time using the user's location.
/// 
class TimeDisplay extends StatefulWidget {
  const TimeDisplay({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TimeDisplayState createState() => _TimeDisplayState();
}

class _TimeDisplayState extends State<TimeDisplay> {
  late Timer _timer;
  final StreamController<DateTime> _timeController = StreamController<DateTime>();

  static const TextStyle optionStyle28 =
    TextStyle(
      fontSize: 28,
      color: Colors.white,
      decoration: TextDecoration.none,
      fontFamily: 'Times New Roman',
      fontWeight: FontWeight.bold,
    );
  static const TextStyle optionStyle40 =
    TextStyle(
      fontSize: 40,
      color: Colors.white,
      decoration: TextDecoration.none,
      fontFamily: 'Times New Roman',
      fontWeight: FontWeight.bold,
    );

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
                style: optionStyle28,
              ),
              const SizedBox(height: 15),
              Text(
                "${snapshot.data?.hour.toString().padLeft(2, '0')}:${snapshot.data?.minute.toString().padLeft(2, '0')}:${snapshot.data?.second.toString().padLeft(2, '0')}:${snapshot.data?.millisecond.toString().padLeft(3, '0')}",
                style: optionStyle40
              ),
            ],
          ),
        );
      },
    );
  }
}


/// Future (Right BarItem; index = 2)
/// 
/// Displays date and time using the user.
/// 
class TTime extends StatefulWidget {
  const TTime({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TTimeState createState() => _TTimeState();
}

class _TTimeState extends State<TTime> {
  final _targetController = TextEditingController();
  late DateTime _targetDate = DateTime.now();
  late Timer _timer;

  static const TextStyle optionStyle =
    TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      fontFamily: 'Times New Roman',
      color: Colors.white,
    );    
  static const TextStyle optionStyleTextField =
    TextStyle(
      fontSize: 14,
      color: Colors.white,
      decoration: TextDecoration.none,
      fontFamily: 'Times New Roman',
      fontWeight: FontWeight.bold,
    );

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTargetDate() {
    setState(() {
      _targetDate = DateTime.parse(_targetController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    var difference = _targetDate.difference(DateTime.now());
    /// ignore: todo
    /// Make more display styles: days, weeks, months, years, % of lifetime, etc.
    // final years = difference.inDays ~/ 365;
    // final months = difference.inDays ~/ 30;
    // final days = difference.inDays - (months * 30);
    final days = difference.inDays;
    final hours = difference.inHours - (difference.inDays * 24);
    final minutes = difference.inMinutes - (difference.inHours * 60);
    final seconds = difference.inSeconds - (difference.inMinutes * 60);

    if (difference.isNegative) {
      const Text("None", style: optionStyle);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _targetController,
          onSubmitted: (_) => _updateTargetDate(),
          decoration: const InputDecoration(
            hintText: 'Enter target coordinate...',
            hintStyle: optionStyleTextField,
          ),
          style: optionStyle,
          textAlign: TextAlign.center,
          cursorColor: Colors.white,
          // focusNode: AlwaysDisabledFocusNode(), // disable focus
        ),

        const SizedBox(height: 30),
        
        Column(
          children: [
            if (difference.isNegative) ... [
              const Text("", style: optionStyle)
            ] else ... [
              Text(
                // "${years.toString().padLeft(4, '0')}:${months.toString().padLeft(2, '0')}:${days.toString().padLeft(2, '0')}::${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
                "${days.toString().padLeft(2, '0')} :: ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
                style: optionStyle,
              ),
            ]
          ],
        )
      ],
    );
  }
}

/// ignore: todo
/// Figure out how to change the highlight color from current(blue) to new(white).
// class AlwaysDisabledFocusNode extends FocusNode {
//   @override
//   bool get hasFocus => ;
// }




/// ignore: todo
/// Organize all the TextStyle & optionStyle that specifies
/// color theme, font family, font size, font weight.
/// Most of them share the same settings.
/// 
const TextStyle optionStyle30 =
  TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    fontFamily: 'Times New Roman',
    color: Colors.white,
  );