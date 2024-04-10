import 'package:bookwaremovil/registrar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookwaremovil/Publicaciones.dart';
import 'package:bookwaremovil/Recuperar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
void main() {
 runApp(const MyApp());
}

class MyApp extends StatelessWidget {
 const MyApp({Key? key}) : super(key: key);
 @override
 Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inicio de sesión ',
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.light(),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2.0),
          ),
          labelStyle: TextStyle(color: Colors.black),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const Login(title: 'Login'),
    );
 }
}

class Login extends StatefulWidget {
 const Login({Key? key, required this.title}) : super(key: key);

 final String title;

 @override
 State<Login> createState() => _Login();
}

class _Login extends State<Login> {
 final _formKey = GlobalKey<FormState>();
 int _documento = 0;
 String _contra = '';
 String name = '';
 int id = 0;
 bool _isObscure = true;


  Future<int> validarInicioSesion(int documento, String contrasena) async {
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
    Map<String, dynamic> responseBody = jsonDecode(response.body);
      // Acceder a los datos de UserEncontrado
       name = responseBody['name']?? 'NOMBRE PORQUE NO LLEGÓ'; // Asegúrate de usar la clave correcta
       id = responseBody['id']?? 1; // Asegúrate de usar la clave correcta
      print("Nombre: $name, ID: $id");
      return 200 ;
  } else if(response.statusCode==503){
      print("LLEGÓ PERO MAL");
      return 503;
  }else if(response.statusCode==500){
    print("INHABILITADO.com");
    return 500; 
  }
  return 503; 
  }catch(e){
    print('Error obteniendo : $e');
      if (e.toString().contains('SocketException')) {
        throw Exception('Error de conexión: $e');
      } else {
        throw Exception('Error desconocido: $e');
      }
  }
  }
  Future<void> guardarCredenciales(int documento, String contrasena,int id,String nombre) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('documento', documento);
    await prefs.setString('contrasena', contrasena);
    await prefs.setInt('id', id);
    await prefs.setString('Nombre', nombre);
  }
 @override
 Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Bookware',
                style: TextStyle(
                 fontWeight: FontWeight.bold,
                 fontSize: 40,
                 color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Container(
                    margin: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Centra horizontalmente
                      children: [
                        Image.asset(
                          'assets/images/Sanlorenzo.png',
                          width: 200, // Ajusta el ancho de la imagen
                          height: 200,
                        ),
                        Text("")
                      ],
                    ),
                ),
                ),

              const Text(
                'Iniciar Sesión',
                style: TextStyle(
                 fontSize: 40,
                 color: Colors.black,
                 fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
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
                    return 'Ingrese su contraseña';
                 } else if (value.length <= 7) {
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
                    _contra = value;
                 });
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          int esValido = await validarInicioSesion(_documento, _contra);
                          if (esValido==200) {
                            await guardarCredenciales(_documento, _contra,id,name);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Bienvenido a BookWare',
                                  style: TextStyle(color: Colors.white),
                                ),
                                
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Publicaciones()),
                            );
                            
                          } else if(esValido==503){
                            ScaffoldMessenger.of(context).showSnackBar(
                              
                              const SnackBar(
                                content: Text(
                                  'Documento  o contraseña incorrectos',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }else if(esValido==500){
                            ScaffoldMessenger.of(context).showSnackBar(
                              
                              const SnackBar(
                                content: Text(
                                  'No puedes ingresar, te encuentras inhabilitado o suspendido',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                    },
                    style: ElevatedButton.styleFrom(
                        
                        backgroundColor: Colors.white,
                    ),
                    
                    child: const Text('Iniciar sesión',
                    style: TextStyle(color: Colors.black),
                    ),
),

              ),
              const SizedBox(height: 20),
              RichText(
                  text: TextSpan(
                      text: '¿Olvidaste tu contraseña?',
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Recuperar()),
                          );
                        },
                  ),
                  ),
                  const SizedBox(height: 20),
              RichText(
                  text: TextSpan(
                      text: '¿Aún no tienes una cuenta? ¡Registrate!',
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegistroUsuario()),
                          );
                        },
                  ),
                  )
            ],
          ),
        ),
      ),
    );
 }
}