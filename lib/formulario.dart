import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class Registrar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar'),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AdditionalForm(),
        ),
      ),
    );
  }
}

class AdditionalForm extends StatefulWidget {
  @override
  _AdditionalFormState createState() => _AdditionalFormState();
}

class _AdditionalFormState extends State<AdditionalForm> {
  String _nombre = '';
  String _documento = '';
  String _email = '';
  String _apellido = '';
  String _password = '';
  String _confirmPassword = '';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Ingresa nombre',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Por favor, Ingresa tu nombre para poder efectuar tu registro';
              }
              return null;
            },
            onSaved: (value) {
              setState(() {
                _nombre = value!;
              });
            },
          ),
          const SizedBox(height: 15),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Apellidos',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Por favor llena el campo.';
              }
              return null;
            },
            onSaved: (value) {
              setState(() {
                _apellido = value!;
              });
            },
          ),
          const SizedBox(height: 15),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Documento',
              border: OutlineInputBorder(),
            ),
              keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Por favor ingrese su documento';
              }else if(value.length<7 || value.length>10){
                return 'tu documento como minimo debe de tener más de 7 digitos y como maximo 10';
              }
              return null;
            },
            onSaved: (value) {
              setState(() {
                _documento = value!;
              });
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Gmail',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Por favor ingrese tu Gmail';
              }
              return null;
            },
            onSaved: (value) {
              setState(() {
                _email = value!;
              });
            },
          ),
          const SizedBox(height: 15),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Contraseña',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Ingresa tu contraseña';
              } else if (value.length <= 10) {
                return 'Debes ingresar más de 10 caracteres';
              } else if (value.length > 20) {
                return 'No puedes ingresar más de 20 caracteres';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _password = value;
              });
            },
          ),
          const SizedBox(height: 15),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Confirmar contraseña ',
              border: OutlineInputBorder(),
            ),
         
            validator: (value) {
              if (value!.isEmpty) {
                return 'Por favor, llena el campo';
              }
              if (value != _password) {
                return 'Las contraseñas no coinciden';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _confirmPassword = value;
              });
            },
          ),
          const SizedBox(height: 30,),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Usuario registrado con éxito',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Color.fromARGB(255, 143, 255, 147),
                    ),
                  );
                }
              },
              
              style: ElevatedButton.styleFrom(
                shadowColor: const Color.fromARGB(255, 0, 0, 0),
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
              ),
              child: const Text('Registrar'),
            ),
          ),
        ],
      ),
    );
  }
}