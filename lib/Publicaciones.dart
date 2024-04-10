import 'package:bookwaremovil/main.dart';
import 'package:flutter/material.dart';
import 'package:bookwaremovil/Catalogo.dart';
import 'package:bookwaremovil/prestamos.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

void main() async{ runApp(PublicacionesApp());
}

class PublicacionesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Publicaciones(),
      routes: {
        '/publicaciones': (context) => Publicaciones(),
        '/catalogo': (context) => Catalogo(),
        'prestamos': (context) => Prestamos(),
      },
    );
  }
}

class Publicaciones extends StatefulWidget {
  @override
  _PublicacionesState createState() => _PublicacionesState();
}
Future<List<dynamic>> obtenerDatos() async {
    final url = 'http://bookwaresena-001-site1.htempurl.com/Movil/Publicaciones';
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
 String convertirFecha(String fecha) {
 final DateFormat formatoOriginal = DateFormat('yyyy-MM-ddTHH:mm:ss');
 final DateFormat formatoDeseado = DateFormat('yyyy-MM-dd');
 final DateTime fechaConvertida = formatoOriginal.parse(fecha);
 final String fechaFormateada = formatoDeseado.format(fechaConvertida);
 return fechaFormateada;
}
 @override
class _PublicacionesState extends State<Publicaciones> {
  int _currentIndex = 0;
  String nombre = '';
  Color color = Color(0xFF1E6042);

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Lógica para la pestaña de Publicaciones
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
      nombre = prefs.getString('Nombre') ?? 'Invitadote';
      
    });
 }
 

  Widget _buildPublicacionesView() {
    return FutureBuilder<List<dynamic>>(
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
              var nombre = item['nombre'] ?? 'Valor Nombre predeterminado';
              var tipo =  item['tipo'] ?? 'Tipo publicacion';
              var fechainicio = item['fechaInicio'] ?? 'Fecha inicio de la publicación';
              var fechaFin = item['fechaFin'] ?? 'Fecha fin de la publicación';
              var imagen = item['imagen'] ?? 'Imagen Publicacion';
              var descripcion = item['descripcion']??'nadota';
              String fechainsin = convertirFecha(fechainicio);
              String fechafinsin = convertirFecha(fechaFin);
String base64Image = imagen.replaceAll(RegExp(r'^data:image/\w+;base64,'), '');

// Decodifica la cadena base64
Uint8List decodedImage;
try {
 decodedImage = base64.decode(base64Image);
} catch (e) {
 print('Error decodificando la imagen: $e');
 // Aquí puedes manejar el error, por ejemplo, asignando una imagen predeterminada a decodedImage
 decodedImage = Uint8List.fromList([]); // Imagen vacía como ejemplo
}

return GestureDetector(
 onTap: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            height: 400, // Ajusta la altura según sea necesario
            child: Center(child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                 Text(
                    'Detalles de la Publicación',
                    style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
                 ),
                 SizedBox(height: 16),
                 Text('Descripción',
                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                 SizedBox(height: 16),
                 Text(descripcion),
                 SizedBox(height: 8),
                                Text('Fecha de inicio: ', style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
                                Text(fechainsin),
                                SizedBox(width: 16),
                                Text('Fecha de fin: ', style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
                                Text(fechafinsin),
                 ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Cierra el modal
                    },
                    child: Text('Cerrar'),
                 ),
                ],
              ),
            ),
            ),
          ),
        );
      },
    );
 },
 child: Card(
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      
      children: [
        Image.memory(decodedImage, errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
          // Aquí puedes devolver un widget de reemplazo, como un Icon o un Text
          return const Icon(Icons.error);
        }),
                      const SizedBox(width: 16.0),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tipo Publicación'),
                            Text(
                              tipo,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text('Nombre Publicación'),
                            Text(
                              nombre,
                              style: TextStyle(fontSize: 16),
                            ),
                            
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
          },
        );
      }
    },
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        title: const Text("Bienvenido"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.login_rounded,color: Colors.black,),
            tooltip: "login",
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Login(title: "login",))),
          ),
        ],
      ),
     body: Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: Text(
            "Publicaciones",
            style: TextStyle(
              fontSize: 32.0, // Ajusta el tamaño de la fuente según sea necesario
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: _buildPublicacionesView(),
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
        BottomNavigationBarItem(icon: Icon(Icons.book_online_rounded),label: 'Préstamos'),
      ],
    ),
 );
  }
}
