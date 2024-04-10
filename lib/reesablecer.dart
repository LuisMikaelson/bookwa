import 'package:bookwaremovil/catalogo.dart';
import 'package:bookwaremovil/main.dart';
import 'package:flutter/material.dart';
import 'package:bookwaremovil/Confirmar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Reestablecer extends StatefulWidget {
 @override
 _ReestablecerState createState() => _ReestablecerState();
}

class _ReestablecerState extends State<Reestablecer> {
 final _formKey = GlobalKey<FormState>();
 String nuevaContra = '';
 String confirmar = '';
 int documento = 0;
  bool _isObscure = true;
  bool _isObscure2 = true;

Future<bool> actualizarContra(int documento, String contrasena) async {
 // Asegúrate de incluir los parámetros en la URL
 final url = 'http://bookwaresena-001-site1.htempurl.com/Movil/ReestablecerContraseña/$documento/$contrasena';
 try {
    print("EL DOCUMENTO: $documento");
    print("Llegó la contraseña: $contrasena");
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Basic MTExNzAzMjQ6NjAtZGF5ZnJlZXRyaWFs',
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept-Language': 'es-ES,es;q=0.9',
      },
      
    );

    if (response.statusCode == 200) {
      print("YA QUEDÓ MELITO");
      return true;
    } else if (response.statusCode == 404) {
      print("HUBO UN ERROR");
      return false;
    }
    return false;
 } catch (e) {
    print('Error obteniendo: $e');
    if (e.toString().contains('SocketException')) {
      throw Exception('Error de conexión: $e');
    } else {
      throw Exception('Error desconocido: $e');
    }
 }
}

   @override
 void initState() {
    super.initState();
    _cargarDatos(); // Llama a _cargarDatos aquí para cargar los datos al inicio
 }
 Future<void> _cargarDatos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      documento = prefs.getInt('documento') ?? 0;
    });
 }
 @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reestablecer Contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                obscureText: _isObscure,
                decoration: InputDecoration(
                 labelText: 'Ingresa Contraseña',
                 prefixIcon: Icon(Icons.lock),
                 suffixIcon: IconButton(
          icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
            },
                 ),
                ),
                validator: (value) {
                 if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese su nueva contraseña';
                 }  else if (value.length <= 7) {
                    return 'La contraseña debe tener al menos 8 caracteres';
                 } else if (value.length > 20) {
                    return 'La contraseña no puede tener más de 20 caracteres';
                 }else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{7,20}$').hasMatch(value)) {
                    return 'Debe contener al menos una mayúscula, \n una minúscula y un número';
                }
                 return null;
                },
                onChanged: (value) {
                 setState(() {
                    nuevaContra = value;
                 });
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                obscureText: _isObscure2,
                decoration: InputDecoration(
                 labelText: 'Ingresa Contraseña',
                 prefixIcon: Icon(Icons.lock),
                 suffixIcon: IconButton(
          icon: Icon(_isObscure2 ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _isObscure2 = !_isObscure2;
            });
            },
                 ),
                ),
                validator: (value) {
                 if (value == null || value.isEmpty) {
                    return 'Por favor, confirme su nueva contraseña';
                 } else if (value != nuevaContra) {
                    return 'Las contraseñas no coinciden';
                 }
                 return null;
                },
                onChanged: (value) {
                 setState(() {
                    confirmar = value;
                 });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                 if (_formKey.currentState!.validate()) {
                  print("El documento al cual se le actualizará la contra es $documento");
                  print("Y la contraseña enviada es $nuevaContra");
                   bool confirmar = await actualizarContra(documento, nuevaContra );
                   if(confirmar){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Contraseña actualizada con éxito',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login(title: '',)),
                            );
                 }
                 else{
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Hubo un error inesperado actualizando tu contraseña \n intenta más tarde ',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                 }
                 }
                },
                child: Text('Actualizar',style: TextStyle(color: Colors.black),),
              ),
            ],
          ),
        ),
      ),
    );
 }
}
