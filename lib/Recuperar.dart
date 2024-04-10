import 'package:flutter/material.dart';
import 'package:bookwaremovil/Confirmar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';


class Recuperar extends StatefulWidget {
 @override
 _RecuperarState createState() => _RecuperarState();
}
class _RecuperarState extends State<Recuperar> {


 final _formKey = GlobalKey<FormState>();
 int codigo = 0; 
 int documento = 0; 
 
Future<bool> recuperarContra(int documento) async {
  final url = 'http://bookwaresena-001-site1.htempurl.com/Movil/RecuperarContraseña/$documento';
  try{
    print("EL DOCUMENTO ");
    print(documento);
  final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Basic MTExNzAzMjQ6NjAtZGF5ZnJlZXRyaWFs',
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept-Language': 'es-ES,es;q=0.9',
      },
      body: jsonEncode(<String,dynamic>{
        'numero_documento': documento,
      }),
  );
  print("Respuesta del sistema");
  print(response.statusCode);
  if (response.statusCode == 200) {
    print("YA QUEDÓ MELITO");
    Map<String, dynamic> responseBody = jsonDecode(response.body);
      // Acceder a los datos de UserEncontrado
       codigo = responseBody['codigo']?? 0;
        print("El código que llegó fue $codigo");
      return true;
  } else if(response.statusCode==404){
      print("Error del servidor");
      return false;
  }
  return false;
  }catch(e){
    print('Error obteniendo : $e');
      if (e.toString().contains('SocketException')) {
        throw Exception('Error de conexión: $e');
      } else {
        throw Exception('Error desconocido: $e');
      }
  }
  }
  Future<void> codigoRecuperar(int codigo,int documentoEn) async {
    print("El código guardado será este $codigo");
    print("El documento que se guardará será $documentoEn");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('codigo',codigo);
    await prefs.setInt('documento',documentoEn);
  }
 @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                 labelText: 'Ingrese número de documento',
                 prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                 if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese su número de documento';
                 } else if (value.length < 7 || value.length > 10) {
                    return 'El documento debe tener entre 7 y 10 caracteres';
                 }
                 return null;
                },
                onChanged: (value) {
                 setState(() {
                    documento = int.tryParse(value) ?? 0;
                 });
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: ()async {
                 if (_formKey.currentState!.validate()) {
                  print("El numero de documento que llega es $documento");
                   bool  esValido =  await recuperarContra(documento);
                    if(esValido){
                      await codigoRecuperar(codigo,documento);
                        ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Acabamos de enviar un código a tu correo, revisa :) ',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ConfirmarState()),
                      );
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Documento no encontrado',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: const Text('Recuperar', style: TextStyle(color: Colors.black),),
              ),
            ],
          ),
        ),
      ),
    );
 }
 
}
