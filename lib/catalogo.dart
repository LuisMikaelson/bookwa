import 'package:bookwaremovil/main.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:bookwaremovil/Publicaciones.dart';
import 'package:bookwaremovil/prestamos.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
 runApp(MyAppCa());
}

class MyAppCa extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
    return MaterialApp(
      home: Catalogo(),
      routes: {
        '/publicaciones': (context) => Publicaciones(),
        '/catalogo': (context) => Catalogo(),
        '/prestamos':(context) => Prestamos(),
      },
    );
 }
}

class Catalogo extends StatefulWidget {
 @override
 _CatalogoState createState() => _CatalogoState();
}

class _CatalogoState extends State<Catalogo> {
 int _documento = 0;
 String _contrasena = '';
 int _id = 0;
 String _nombre = '';
 int _currentIndex = 1;
 Color color = Color(0xFF1E6042);

  OverlayEntry? overlayEntry;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Publicaciones()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Catalogo()),
        );
        break;
        case 2:
        Navigator.push(context,MaterialPageRoute(builder: (context)=>Prestamos()),
        );
        break; 
    }
  }
 @override
 void initState() {
    super.initState();
    _cargarDatos();
 }
 Future<void> _cargarDatos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _documento = prefs.getInt('documento') ?? 0;
      _contrasena = prefs.getString('contrasena') ?? '';
      _nombre = prefs.getString('Nombre') ?? '';
      _id = prefs.getInt('id') ?? 0;
      
      
    });
 }
Future<int> registrarPeticion(int documento, int idEjemplar) async {
  final url = 'http://bookwaresena-001-site1.htempurl.com/Movil/RegistrarPeticion';
    try{
          print("EL DOCUMENTO ");
          print(documento);
          print("EL ID EJEMPLAR");
          print(idEjemplar);
          print(_id);
          print("NOMBRE: ");
          print(_nombre);
        final response = await http.post(
            Uri.parse(url),
            headers: <String, String>{
              'Authorization': 'Basic MTExNzAzMjQ6NjAtZGF5ZnJlZXRyaWFs',
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept-Language': 'es-ES,es;q=0.9',
            },
            body: jsonEncode(<String,dynamic>{
              'Peticion':{
                "Id_ejemplar": idEjemplar,
                "Id_usuario": _id,
                "Motivo" : "Prestamo Libro"
              },
              'Id_Rol':1,
              
            }),
        );
        print("LA RESPUESTA DEL SISTEMA ES: ");
          print(response.statusCode);
          if (response.statusCode == 200) {
            print("YA QUEDÓ MELITO");
              return 200;
          }else if(response.statusCode==405){
            print("NO LLEGÓ EL DOCUMENTO");
            return 405;
          }else if(response.statusCode==502){
              print("Ya tienes una reserva activa");
              return 502; 
          }else if(response.statusCode==505){
              print("PRESTAMO EN CURSO");
              return 505;
          }else if(response.statusCode==506){
            print("Reserva registrada");
            return 506; 
          }else if(response.statusCode==507){
            print("petición en espera");
            return 507; 
          } else if(response.statusCode==503){
            print("Prestamo en curso");
            return 503;
          } else if(response.statusCode==500){
            print("PETICIÓN EN ESPERA");
            return 500;
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
 Future<List<dynamic>> obtenerDatos() async {
    final url = 'http://bookwaresena-001-site1.htempurl.com/Movil/Catalogo';
    try {
      print("INTENTANDO INGRESAR A LA APLICACIÓN");
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Basic MTExNzAzMjQ6NjAtZGF5ZnJlZXRyaWFs',
          'Content-Type': 'application/json; charset=utf-8',
          'Accept-Language': 'es-ES,es;q=0.9',
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print(response.statusCode);
        throw Exception('Error al obtener los datos: ${response.statusCode}');
      }
    } catch (e) {
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
        backgroundColor: color,
        title: Text("Bienvenid@ $_nombre"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.login_rounded),
            tooltip: "login",
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyApp(),
              ),
            ),
          ),
        ],
      ),
      body: Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: const Text(
            "Catálogo",
            style: TextStyle(
              fontSize: 32.0, // Ajusta el tamaño de la fuente según sea necesario
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<dynamic>>(
        future: obtenerDatos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var item = snapshot.data![index];
                var nombre = item['titulo'] ?? 'Valor Nombre predeterminado';
                var estado = item['ejemplares'][0]['estado'] ?? 'Valor Estado predeterminado';
                var idEjemplar = item['ejemplares'][0]['id'] ?? 'Valor Estado predeterminado';
                var imagen = item['imagen']?? 'Imagen Libro';
                var autores = item['autoresRelacionados'].map((autor) => autor['nombre']).join(', ');
                var generosR = item['generosRelacionados'].map((autor) => autor['nombre']).join(', ');
                var descripcion = item['descripcion']?? 'DESCRIPCIÓN DEL LIBRO';
                String base64Image = imagen;
                String base64Data = base64Image.split(',').last;
                Uint8List decodedImage = base64.decode(base64Data);
                void mostrarOverlay(BuildContext context) {
 overlayEntry = OverlayEntry(
    builder: (context) => Center(
      child: Material(
        child: Container(
          width: 350,
          height: 370,
          color: Colors.white,
          child: Center(
            child : Scrollbar(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Descripción',style: TextStyle(
                  fontWeight: FontWeight.bold,
               
                  fontSize: 24 ),
                ),
                SizedBox(height: 20),
                Text(descripcion),
                Text('Generos Relacionados',style: TextStyle(
                  fontWeight: FontWeight.bold,
                
                  fontSize: 24 ),
                ),
                SizedBox(height: 20),
                Text(generosR),
                ElevatedButton(
                 onPressed: () {
                    overlayEntry?.remove(); 
                 },
                 child: Text('Cerrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    ),
 );
      
 Overlay.of(context).insert(overlayEntry!);
}
                return Card(
                 margin: const EdgeInsets.all(16.0),
                 child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.memory(decodedImage,
                      width: 100, // Ajusta el ancho de la imagen
                      height: 100,
                      ),
                      
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nombre,
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8.0),
                            
                            const SizedBox(height: 8.0),
                            Text("Autor(es)"),
                            Text(
                              autores,
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            const SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: () {
                                 mostrarOverlay(context);
                              },
                                child: const Text('Información'),
                            ),
                            ElevatedButton(onPressed:  () async {
                                 int esValido = await registrarPeticion(_documento, idEjemplar);
                                 if (esValido==200){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Se ha realizado la petición con éxito :)',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                 }
                                 else if (esValido==503){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Ya tienes un prestamo en curso, no puedes solicitar otro libro',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                 }
                                 else if (esValido==505){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Ya tienes un prestamo en curso, no puedes solicitar otro libro',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                 }else if(esValido==500){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Ya tienes una petición activa, no puedes solicitar otro libro',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }else if(esValido==502){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Ya tienes una reserva activa, no puedes solicitar otro libro',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }else if(esValido==506){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Se ha realizado la reserva con éxito :)',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }else if(esValido==507){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Tienes una petición en espera, no puedes solicitar otro libro',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                  else if(esValido==404){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Algo falló en tu solicitud, intenta más tarde',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                              },
                            child: const Text('Solicitar'))
                          ],
                        ),
                      ),
                      const SizedBox(width: 16.0),
                    ],
                 ),
                );
              },
            );
      
          }
        },
        
      ),
      
      ),
      ],
      ),
      
    bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Publicaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Catálogo',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.book_online_sharp),label: 'Préstamos'),
        ],
      ),
    );
 }
}