import 'dart:ffi';

import 'package:bookwaremovil/Publicaciones.dart';
import 'package:flutter/material.dart';
import 'package:bookwaremovil/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistroUsuario extends StatefulWidget {
 @override
 _RegistroUsuarioState createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
 final _formKey = GlobalKey<FormState>();
 int _numeroDocumento = 0;
 String _nombre = '';
 String _apellido = '';
 String _correo = '';
 String _contrasena = '';
 bool mostrar = true; 

Future<int> registrarUsuario(int documento,String nombre,String apellido,String correo,String contrasena) async {
  final url = 'http://bookwaresena-001-site1.htempurl.com/Movil/RegistrarUsuario';
    try{
          print("EL DOCUMENTO ");
          print(documento);
          print("NOMBRE: ");
          print(nombre);
          print ("EL APELLIDO QUE LLEGA ES $apellido"); 
          print("El correo que llega es $correo");
          print("la contraseña que llega es $contrasena");
        final response = await http.post(
            Uri.parse(url),
            headers: <String, String>{
              'Authorization': 'Basic MTExNzAzMjQ6NjAtZGF5ZnJlZXRyaWFs',
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept-Language': 'es-ES,es;q=0.9',
            },
            body: jsonEncode(<String,dynamic>{
  
                "Id_rol": 2,
                "Numero_documento": documento,
                "Name": nombre,
                "Apellido": apellido,
                "Correo": correo,
                "Contraseña": contrasena,
                "Estado": "ACTIVO",
            }),
        );
        print("LA RESPUESTA DEL SISTEMA ES: ");
          print(response.statusCode);
          if(response.statusCode==200){
            return 200;
          }else if(response.statusCode==500){
            print("Usuario no matriculado");
            return 500;
          }else if(response.statusCode==501){
            print("Nombre incorrecto");
            return 501;
          }else if(response.statusCode==502){
            print("Apellido incorrecto");
            return 502;
          }else if(response.statusCode==503){
            print("Documento ya registrado");
            return 503;
          }else if(response.statusCode==504){
            print("Correo ya registrado");
            return 504;
          }else if(response.statusCode==505){
            print("dominio de correo inválido");
            return 505;
          }
          return 404;
      }catch(e){
        print('Error obteniendo : $e');
          if (e.toString().contains('SocketException')) {
            throw Exception('Error de conexión: $e');
          } else {
            throw Exception('Error desconocido: $e');
          }
 }
}
 @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
            child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Número de Documento'),
                validator: (value) {
                 if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio.';
                 }
                 else if (value.length < 7 || value.length > 10) {
                    return 'El documento debe tener entre 7 y 10 caracteres';
                 }
                 return null;
                },
               onChanged: (value) {
                 setState(() {
                    _numeroDocumento = int.tryParse(value) ?? 0;
                 });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                 if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio.';
                 }
                 if (value.contains(RegExp(r'\d'))) {
                    return 'No se permiten números en este campo.';
                 }
                 return null;
                },
                onSaved: (value) => _nombre = value!,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Apellido'),
                validator: (value) {
                 if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio.';
                 }
                 if (value.contains(RegExp(r'\d'))) {
                    return 'No se permiten números en este campo.';
                 }
                 return null;
                },
                onSaved: (value) => _apellido = value!,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Correo Electrónico'),
                validator: (value) {
                 if (value == null || value.isEmpty) {
                    return 'El correo electrónico es obligatorio.';
                 }
                 if (!value.contains(RegExp(r'^[^@]+@[^@]+\.[^@]+$'))) {
                    return 'Ingrese un correo electrónico válido.';
                 }
                 return null;
                },
                onSaved: (value) => _correo = value!,
              ),
              const SizedBox(height: 20),
              TextFormField(
                obscureText: mostrar,
                decoration: InputDecoration(labelText: 'Contraseña',
                prefixIcon: Icon(Icons.lock),
                 suffixIcon: IconButton(
          icon: Icon(mostrar ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              mostrar = !mostrar;
            });
            },
                 ),
                ),
                validator: (value) {
                 if (value == null || value.isEmpty) {
                    return 'La contraseña es obligatoria.';
                 }
                 if (value.length < 8) {
                    return 'Debe contener al menos 8 caracteres.';
                 }
                 if (!value.contains(RegExp(r'(?=.*[a-z])(?=.*[A-Z])(?=.*\d)'))) {
                    return 'Debe contener al menos una mayúscula, \n una minúscula y un número.';
                 }
                 return null;
                },
                onSaved: (value) => _contrasena = value!,
              ),
              
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                 if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    int registrar = await registrarUsuario(_numeroDocumento,_nombre,_apellido,_correo,_contrasena);
                    if(registrar==200){
                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Te has registrado con éxtio',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                          
                                        );
                                         Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MyApp()),
                            );
                    }else if(registrar==500){
                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                          'El documento ingresado no se encuentra matriculado revisa bien tu documento',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                    }else if(registrar==501){
                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Nombre incorrecto, recuerda poner tu nombre completo',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                    }else if(registrar==502){
                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Apellido incorrecto, recuerda que debe ser tu apellido completo',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                    }else if(registrar==503){
                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'El documento ingresado ya se encuentra registrado',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                    }else if(registrar==504){
                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'El correo ingresado ya se encuentra registrado',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                    }else if(registrar==505){
                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                            'El correo ingresado tiene un dominio inválido (@)',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                    }
                 }
                },
                child: Text('Registrarme', style: TextStyle(color: Colors.black),),
              ),
            ],
          ),
            ),
        ),
      ),
    );
 }
}
