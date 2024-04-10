import 'package:bookwaremovil/reesablecer.dart';
import 'package:bookwaremovil/solicitar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmarState extends StatefulWidget {
 @override
 Confirmar createState() => Confirmar();
}
class Confirmar extends State<ConfirmarState> {
  int codigo = 0;
  int verificar = 0;
  final _formKey = GlobalKey<FormState>();
  void initState() {
    super.initState();
    _cargarDatos();
 }
 Future<void> _cargarDatos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      codigo = prefs.getInt('codigo')??0;
    });
 }
 Future<bool> verificarDatos(int codigo,int codigoverificar) async {
  print("EL CODIGO ESCRITO ES $codigoverificar y el codigo guardado es $codigo");
    if(codigoverificar!=codigo){
      return false;
    }else{
      return true;
    }
 }
 @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmar Código'),
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
                 labelText: 'Ingrese Código de verificación',
                 prefixIcon: Icon(Icons.numbers),
                ),
                validator: (value) {
                 if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese el código de verificación';
                 } else if (value.length !=5) {
                    return 'El código contiene 5 digitos, verifica';
                 }
                 return null;
                },
                onChanged: (value) {
  setState(() {
    // Aquí cambiamos el nombre de la variable
    verificar = int.tryParse(value) ?? 0;
  });
},
  

              ),
               const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                  bool verificarD = await verificarDatos(codigo, verificar);

                      if(verificarD){
                            ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Código correcto, ahora puedes actualizar tu contraseña',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Reestablecer()),
                                  );
                                  
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'El código no coincide, verifica por favor',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                      }
                 }
                },
                child: Text('Verificar',style: TextStyle(color: Colors.black),),
              ),
            ],
          ),
        ),
      ),
    );
 }
}