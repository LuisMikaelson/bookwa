// import 'package:bookwaremovil/main.dart';
// import 'package:flutter/material.dart';
// import 'package:bookwaremovil/Catalogo.dart';
// import 'package:bookwaremovil/Prestamos.dart';
// import 'package:bookwaremovil/publicaciones.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MainScreen(),
//     );
//  }
// }

// class MainScreen extends StatefulWidget {
//  @override
//  _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//  int _currentIndex = 0;

//  final List<Widget> _children = [
//    Publicaciones(),
//    Catalogo(),
//    Prestamos(),
//  ];

//  void onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//  }

//  @override
//  Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 24, 135, 84),
//         title: const Text("Bookware"),
//         centerTitle: true,
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.login_rounded),
//             tooltip: "login",
//             onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Login(title: "login",))),
//           ),
//         ],
//       ),
//       body: _children[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed, // Ensure the type is set to fixed
//         onTap: onTabTapped,
//         currentIndex: _currentIndex,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Publicaciones',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.book),
//             label: 'Catálogo',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.book_online_outlined),
//             label: 'Préstamos',
//           ),
//         ],
//       ),
//     );
//  }
// }
