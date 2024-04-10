import 'package:bookwaremovil/catalogo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Solicitar extends StatefulWidget {
 @override
 _SolicitarState createState() => _SolicitarState();
}
Future<bool> validarInicioSesion(int documento, String contrasena) async {
 final url = 'http://bookwaresena-001-site1.htempurl.com/Movil/Login/';
 try{
  print("EL DOCUMENTO ");
  print(documento);
  print("Llegó la contraseña"+contrasena);
 final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Authorization': 'Basic MTExNzAzMjQ6NjAtZGF5ZnJlZXRyaWFs',
      'Content-Type': 'application/json; charset=UTF-8',
       'Accept-Language': 'es-ES,es;q=0.9',
    },
    body: jsonEncode(<String,dynamic>{
      'Numero_Documento': documento,
      'Contraseña': contrasena,
    }),
 );

 if (response.statusCode == 200) {
   print("YA QUEDÓ MELITO");
    return true;
 } else {
    print("LLEGÓ PERO MAL");
    return false;
 }
 }catch(e){
  print('Error obteniendo : $e');
    if (e.toString().contains('SocketException')) {
      throw Exception('Error de conexión: $e');
    } else {
      throw Exception('Error desconocido: $e');
    }
 }
}
class _SolicitarState extends State<Solicitar> {
 final _formKey = GlobalKey<FormState>();
 int _documento = 0;
 String _contrasena = '';

 @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario para solicitar el libro'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                 labelText: 'Ingrese número de documento',
                 prefixIcon: Icon(Icons.person),
                ),
                keyboardType: TextInputType.number,
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
                    _documento = int.tryParse(value) ?? 0;
                 });
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                 labelText: 'Contraseña',
                 prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                 if (value == null || value.isEmpty) {
                    return 'Ingrese su contraseña';
                 } else if (value.length < 7) {
                    return 'La contraseña debe tener al menos 7 caracteres';
                 } else if (value.length > 20) {
                    return 'La contraseña no puede tener más de 20 caracteres';
                 }
                 return null;
                },
                onChanged: (value) {
                 setState(() {
                    _contrasena = value;
                 });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                 if (_formKey.currentState!.validate()) {
                    bool esValido = await validarInicioSesion(_documento, _contrasena);
      if (esValido) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Libro solicitado con éxito',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Catalogo()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Correo o contraseña incorrectos',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      }
                },
                child: const Text('Solicitar'),
              ),
            ],
          ),
        ),
      ),
    );
 }
}
