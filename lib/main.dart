import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      title: 'Spacetime',
      home: Home(),
      // home: Column(
      //     children: const <Widget>[
      //       Home(),
      //       Notify(),
      //     ],
      //   ),
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
  int _selectedIndex = 2;
 
  static final List<Widget> _widgetOptions = <Widget>[  
    Container(
      color: Colors.black,
      alignment: Alignment.center,
      // child: const Text('Priority', style: defaultStyle),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Priorities', style: defaultStyle),
          const SizedBox(height: 100),
          Text('1. Business Analysis', style: defaultStyle.copyWith(fontSize: 24),),
          Text('2. Business Development', style: defaultStyle.copyWith(fontSize: 24),),
          Text('3. Reading', style: defaultStyle.copyWith(fontSize: 24),),
        ],
      )
    ),
    Container (
      color: Colors.black87,
      alignment: Alignment.center,
      child: const Text("Timer", style: defaultStyle,),
    ),
    Container (
      color: Colors.black,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          TimeDisplay(),
          Notify()
        ],
      ),
    ),
    Container(
      color: Colors.black,
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
    Container (
      color: Colors.black87,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text("Settings", style: defaultStyle,),
        ],
      ),

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
            icon: Icon(Icons.timelapse_sharp, color: Colors.white),
            label: 'Timer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.circle_outlined, color: Colors.white),
            label: 'SpaceTime',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_mark_sharp, color: Colors.white),
            label: 'Future',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.white),
            label: 'Settings',
          ),
        ],
        backgroundColor: Colors.black,
        // fixedColor: Colors.white,
        type: BottomNavigationBarType.fixed,
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

  final targetController = TextEditingController();
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
      targetDate = DateTime.parse(targetController.text);
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
            controller: targetController,
            onSubmitted: (_) => _updateTargetDate(),
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

          const SizedBox(height: 20),
          
          Column(
            children: [
              if (difference.isNegative) ... [
                Text("", style: defaultStyle.copyWith(fontSize: 28),
                )
              ] else ... [
                Text(
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




/// todo: Send push notification after using the app for 15 minutes
/// 
/// Send push notification of current time when screen time exceeds 15 minutes.
/// This code sets up a notification plugin and initializes it with `androidInitializationSettings` and `iosInitializationSettings`. 
/// It also includes a method to show the notification with the current date and time using the `flutterLocalNotificationsPlugin.show` method.
/// The `onDidReceiveLocalNotification` method is called when the app is in the foreground and the notification is received, 
/// and the `onSelectNotification` method is called when the user taps on the notification and the app is brought to the foreground. 
/// In the example code, these methods display an alert dialog and navigate to a new screen, respectively.
/// 
/// 
/// 
class Notify extends StatefulWidget {
  const Notify({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotifyState createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late AndroidInitializationSettings androidInitializationSettings;
  // IOSInitializationSettings iosInitializationSettings;
  late InitializationSettings initializationSettings;
  late Timer timer;
  


  @override
  void initState() {
    super.initState();
    initializing();
    startTimer();
  }

  void initializing() async {
    androidInitializationSettings = const AndroidInitializationSettings('app_icon');
    // iosInitializationSettings = IOSInitializationSettings(
        // onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        android: androidInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,);
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(minutes: 15), (timer) {
      // _showNotification();
      buildNotification();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              // ignore: avoid_print
              print("Hi");
            },
            child: const Text("Okay")),
      ],
    );
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    }
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Payload"),
        content: Text("Payload : $payload"),
      ),
    );
    // await Navigator.of(context).push(
    //   MaterialPageRoute(builder: (context) => SecondScreen(payload)),
    // );
  }

  Future<void> buildNotification() async {    
    try {
      var now = DateTime.now();
      var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 
        'your channel name',
        importance: Importance.max, 
        priority: Priority.high, 
        visibility: NotificationVisibility.public,
      );
      // var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0,
        '${now.year.toString().padLeft(4, '0')}:${now.month.toString().padLeft(2, '0')}:${now.day.toString().padLeft(2, '0')}',
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}',
        platformChannelSpecifics,
        payload: ''
      );
    } catch (e) {
      // ignore: avoid_print
      print("Failed to show notification: $e");
    }
  }

}






/// todo: calculate other app usage time
/// This is tricky...
/// One way to implement this feature would be to use the WidgetsBindingObserver class in Flutter, 
/// which can be used to monitor the lifecycle of an app. 
/// By using the WidgetsBindingObserver, you can determine when an app goes into the background 
/// and when it comes back to the foreground, and use this information to calculate the usage time of the app.
/// This implementation uses a Map to store the usage time for each app, 
/// with the key being the name of the app and the value being the usage time in seconds. 
/// The didChangeAppLifecycleState method is called when the lifecycle of the app changes, 
/// allowing us to start and stop a timer that tracks the usage time.

// import 'package:flutter/widgets.dart';

// class AppUsageTracker with WidgetsBindingObserver {
//   AppUsageTracker() {
//     WidgetsBinding.instance.addObserver(this);
//   }

//   Map<String, int> appUsage = {};
//   Timer _timer;

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     switch (state) {
//       case AppLifecycleState.paused:
//         _timer?.cancel();
//         break;
//       case AppLifecycleState.resumed:
//         _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//           // Add 1 second to the app's usage time
//           appUsage[currentAppName] = appUsage[currentAppName] + 1;
//         });
//         break;
//       default:
//         break;
//     }
//   }

//   // Example of how to get the current app name
//   String get currentAppName => 'example_app_name';
// }





