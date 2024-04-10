
import 'package:bookwaremovil/formulario.dart';

import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Second Route"),
        
      ),
      body: Column(
        children: [
          
            Registrar(),
          
          ElevatedButton(onPressed: () {
          Navigator.pop(context);
        },child: const Text("hablalo desde el catalogo"))
        ],    
      )
    );
    
  }
}