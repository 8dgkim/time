import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
 
  static final List<Widget> _widgetOptions = <Widget>[  
    Container(
      color: Colors.black87,
      alignment: Alignment.center,
      child: const Text('Priority', style: defaultStyle),
    ),
    Container (
      color: Colors.black,
      alignment: Alignment.center,
      child: const TimeDisplay(),
    ),
    Container(
      color: Colors.black87,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text('T-Time Counter', style: defaultStyle),
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
                style: defaultStyle.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 15),
              Text(
                "${snapshot.data?.hour.toString().padLeft(2, '0')}:${snapshot.data?.minute.toString().padLeft(2, '0')}:${snapshot.data?.second.toString().padLeft(2, '0')}:${snapshot.data?.millisecond.toString().padLeft(3, '0')}",
                style: defaultStyle.copyWith(fontSize: 40),
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

class _TTimeState extends State<TTime> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  final _targetController = TextEditingController();
  late DateTime targetDate = DateTime.now();
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _updateTargetDate() {
    setState(() {
      targetDate = DateTime.parse(_targetController.text);
      // storage.write(key: "targetDate", value: targetDate.toString());
    });
  }

  @override
    Widget build(BuildContext context) {
      super.build(context);

      late var difference = targetDate.difference(DateTime.now());
      final days = difference.inDays;
      final hours = difference.inHours - (difference.inDays * 24);
      final minutes = difference.inMinutes - (difference.inHours * 60);
      final seconds = difference.inSeconds - (difference.inMinutes * 60);
      /// ignore: todo
      /// Make more display styles: days, weeks, months, years, % of lifetime, etc.

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _targetController,
            onSubmitted: (_) => _updateTargetDate(),
            // keyboardType: TextInputType.datetime,
            decoration: InputDecoration(
              hintText: 'Enter target coordinate...',
              hintStyle: defaultStyle.copyWith(fontSize: 14),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white
                ),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white
                ),
              ),
            ),
            style: defaultStyle.copyWith(fontSize: 28),
            textAlign: TextAlign.center,
            cursorColor: Colors.white,
          ),

          const SizedBox(height: 30),
          
          Column(
            children: [
              if (difference.isNegative) ... [
                Text("", style: defaultStyle.copyWith(fontSize: 28),
                )
              ] else ... [
                Text(
                  // "${years.toString().padLeft(4, '0')}:${months.toString().padLeft(2, '0')}:${days.toString().padLeft(2, '0')}::${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
                  "${days.toString().padLeft(2, '0')} :: ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
                  style: defaultStyle.copyWith(fontSize: 28),
                ),
              ]
            ],
          )
        ],
      );
    }
}

/// Default textstyle setting
/// Use copyWith() method to make specific changes
/// Remove const to use copyWith()
const TextStyle defaultStyle =
  TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    fontFamily: 'Times New Roman',
    color: Colors.white,
  );


// const storage = FlutterSecureStorage();


