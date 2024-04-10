import 'dart:convert';
import 'dart:typed_data';
import 'package:bookwaremovil/Publicaciones.dart';
import 'package:bookwaremovil/catalogo.dart';
import 'package:bookwaremovil/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(Prestamos());
}

class Prestamos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PrestamosScreen(),
      routes: {
        '/publicaciones': (context) => Publicaciones(),
        '/catalogo': (context) => Catalogo(),
        '/prestamos': (context) => PrestamosScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
    
  }
}

class PrestamosScreen extends StatefulWidget {
  @override
  _PrestamosScreenState createState() => _PrestamosScreenState();
}

class _PrestamosScreenState extends State<PrestamosScreen> {
  int _currentIndex= 2;
  int _documento = 0;
  String _nombre = '';
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
      _nombre = prefs.getString('Nombre') ??'';
    });
 }
Future<List<dynamic>> obtenerDatos(int documento) async {
    final url = 'http://bookwaresena-001-site1.htempurl.com/Movil/Prestamos/$documento';
    try {
      print("El documento que me llega es para enviar es el $documento");
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Basic MTExNzAzMjQ6NjAtZGF5ZnJlZXRyaWFs',
          'Content-Type': 'application/json; charset=utf-8',
          'Accept-Language': 'es-ES,es;q=0.9',
        },
        body: jsonEncode(<String,dynamic>{
              "documento" : documento
            }),
        );
        print("Respuesta del servidor: ${response.body}");
      if (response.statusCode == 200) {
        print("todo llegó fine");
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
 final DateFormat formatoOriginal = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS');
 final DateFormat formatoDeseado = DateFormat('yyyy-MM-dd');
 final DateTime fechaConvertida = formatoOriginal.parse(fecha);
 final String fechaFormateada = formatoDeseado.format(fechaConvertida);
 return fechaFormateada;
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
          child: Text(
            "Préstamos",
            style: TextStyle(
              fontSize: 32.0, // Ajusta el tamaño de la fuente según sea necesario
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<dynamic>>(
        future: obtenerDatos(_documento),
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
                var nombre = item['nombreEjemplar'] ?? 'Valor Nombre predeterminado';
                var estado = item['estado']?? 'Valor Estado predeterminado';
                var isbnE = item['isbnEjemplar'] ?? 0;
                var imagen = item['imagenliro']?? 'ImagenLibro';
                var fechaInicio = item['fechaInicio']?? 'Fecha inicio';
                var fechaFin = item['fechaFin']??'Fecha Fin';
                String fechaSinHora = convertirFecha(fechaFin);
                String base64Image = imagen;
                String base64Data = base64Image.split(',').last;
                Uint8List decodedImage = base64.decode(base64Data);
        void mostrarOverlay(BuildContext context) {
                overlayEntry = OverlayEntry(
                    builder: (context) => Center(
                      child: Material(
                        child: Container(
                          width: 380,
                          height: 380,
                          color: Colors.white,
                          child: Center(
                            child : Scrollbar(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.memory(decodedImage,
                      width: 100,
                      height: 100,
                      ),
                      const SizedBox(width: 16.0),
                                const Text('Fecha Inicio ',style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24 ),
                                ),
                                const SizedBox(height: 20),
                                Text(fechaInicio),
                                const SizedBox(height: 20),
                                const Text('Fecha finalización',style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24 ),
                                ),
                                const SizedBox(height: 20),
                                Text(fechaFin),
                                const SizedBox(height: 20),
                                const Text('Isbn del ejemplar en préstamo',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
                                const SizedBox(height: 20),
                                Text(isbnE),
                                 const SizedBox(height: 30),
                                ElevatedButton(
                                onPressed: () {
                                    overlayEntry?.remove();
                                },
                                child: const Text('Cerrar'),
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
                      width: 100,
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
                            Text(isbnE),
                            const SizedBox(height: 8.0),
                            Text("Estado del préstamo",style: TextStyle(fontWeight: FontWeight.bold),),
                            Text(
                              estado,
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Text("Fecha devolución",style: TextStyle(fontWeight: FontWeight.bold),),
                            Text(fechaSinHora),
                            
                            const SizedBox(height: 16.0),
                            // ElevatedButton(
                            //   onPressed: () {
                            //      mostrarOverlay(context);
                            //   },
                            //     child: const Text('Información'),
                            // ),
                          ]
                        )
                      )
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