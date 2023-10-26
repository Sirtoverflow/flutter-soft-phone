import 'package:flutter/material.dart';
import 'package:sip_call_crossplatform/page/historycall.dart';
import 'package:sip_call_crossplatform/page/sip/main.dart';

class MainPage extends StatefulWidget {
  final VoidCallback logout;
  // ignore: non_constant_identifier_names
  const MainPage({Key? key, required this.logout}) : super(key: key);


  @override
  State<MainPage> createState() => _MainPageState();
  
}

class _MainPageState extends State<MainPage> {
  int index = 2;
  String phoneNumberAfterCall = '';

  @override
  void initState() {
    super.initState();

    // ignore: unused_local_variable
    const historycall = HistoryCallWidget();
    final screens = [
      Scaffold(
        appBar: AppBar(
          title: const Text('User Page'),
          actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: widget.logout,
          ),
        ],
        ),
        body: const Center(
          child: Text('QR CODE'),
        ),
      ),
      // dialPad,,
      const Center(child: Text('Message'),),
      MyApp(),
      historycall,
    ];

    setState(() {
      this.screens = screens;
    });
  }

  List<Widget> screens = []; 

  @override

  
  Widget build(BuildContext context) {


    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.blue[100],
        ),
        child: NavigationBar(
            height: 60,
            backgroundColor: const Color(0xFFf1f5fb),
            animationDuration: const Duration(seconds: 1),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            selectedIndex: index,
            onDestinationSelected: (index) => setState(() {
                  this.index = index;
                }),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.account_circle_outlined),
                selectedIcon: Icon(Icons.account_circle_rounded),
                label: 'User',
              ),
              NavigationDestination(
                icon: Icon(Icons.message_outlined),
                selectedIcon: Icon(Icons.message_rounded),
                label: 'Chat',
              ),
              NavigationDestination(
                icon: Icon(Icons.dialpad_outlined),
                selectedIcon: Icon(Icons.dialpad_sharp),
                label: 'Dialpad',
              ),
              NavigationDestination(
                icon: Icon(Icons.history_toggle_off_outlined),
                selectedIcon: Icon(Icons.history_rounded),
                label: 'Call Log',
              ),
            ]),
      ),
    );
    
  }
  
}
