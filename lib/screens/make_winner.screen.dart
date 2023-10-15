import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:sorteo/util/firebase.helper.dart';

class MakeWinner extends StatefulWidget {
  const MakeWinner({super.key});

  @override
  State<MakeWinner> createState() => _MakeWinnerState();
}

class _MakeWinnerState extends State<MakeWinner> {
  FirebaseService firebaseService = FirebaseService();

  final TextEditingController _controllerWinnerName = TextEditingController();
  final TextEditingController _controllerWinnerEmail = TextEditingController();
  final TextEditingController _controllerWinnerFoto = TextEditingController();
  final TextEditingController _controllerWinnerNumero = TextEditingController();
  final TextEditingController _controllerWinnerPremio = TextEditingController();
  final TextEditingController _controllerWinnerSorteo = TextEditingController();

  String photo = '';
  bool showPhoto = false;

  void showMessage(String message, Color color) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          duration:  const Duration(seconds: 8),
          shape:  const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30) , topRight: Radius.circular(30) ),
          ),
        ),
        
      );
    }


  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>(); 

    void sendData() {
      if (formKey.currentState!.validate()) {
          num? n = num.tryParse(_controllerWinnerPremio.text);
            if(n != null){
              firebaseService.sendWinner(
                _controllerWinnerName.text, 
                _controllerWinnerEmail.text, 
                _controllerWinnerFoto.text, 
                _controllerWinnerNumero.text, 
                _controllerWinnerPremio.text, 
                _controllerWinnerSorteo.text
              );

              FocusScope.of(context).unfocus();
              _controllerWinnerName.text = "";
              _controllerWinnerEmail.text = "";
              _controllerWinnerFoto.text = "";
              _controllerWinnerNumero.text = "";
              _controllerWinnerPremio.text = "";
              _controllerWinnerSorteo.text = '';

              firebaseService.deleteColeccion();
              Navigator.pop(context);

            }else{
                showMessage('Error, Monto o Sorteo en  Formato invalido', Colors.red);
            }
                      
            
          }
    }

    return Scaffold(
      body: Form(
        key: formKey,
        child: ListView(
          
          children: [

            Container(
              height: 50,
            ),
            

            const Text("Crear Ganador"),

            Container(
              height: 20,
            ),

            TextFormField(
              controller: _controllerWinnerName,
              decoration: const InputDecoration(
                hintText: 'Nombre',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa un nombre';
                }
                return null;
              },
            ).px12(),

            TextFormField(
              controller: _controllerWinnerEmail,
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa un email';
                }
                return null;
              },
            ).px12(),

            

            Row(
              
              children: [
                

                Expanded(
                  child: TextFormField(
                  controller: _controllerWinnerFoto,
                  decoration: const InputDecoration(
                    hintText: 'URL Foto',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingresa una Foto';
                    }
                    return null;
                  },
                )
                ),

                IconButton(
                  onPressed: (){
                    if(_controllerWinnerFoto.text.isEmpty  ){
                      showMessage('Debe poner una url',Colors.red);
                    }else{
                      setState(() {
                        photo = _controllerWinnerFoto.text;
                        showPhoto = true;
                      });
                    }
                    
                  }, 
                  icon: const Icon(Icons.send)
                  )
              ],
            ).px12(),

            TextFormField(
              controller: _controllerWinnerNumero,
              decoration: const InputDecoration(
                hintText: 'DD/MM/YYYY',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa una fecha';
                }
                return null;
              },
            ).px12(),

            TextFormField(
              controller: _controllerWinnerPremio,
              decoration: const InputDecoration(
                hintText: '5.00',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa un Monto';
                }
                return null;
              },
            ).px12(),

            TextFormField(
              controller: _controllerWinnerSorteo,
              decoration: const InputDecoration(
                hintText: 'N Sorteo',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa un N Sorteo';
                }
                return null;
              },
            ).px12(),

            Container(
              height: 20,
            ),

            GestureDetector(
              onTap: () {
                sendData();
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                color: Colors.amberAccent,
                child: const Text("Enviar"),
              ),
            ),

            Container(
              height: 20,
            ),

            showPhoto?
            CircleAvatar(
                radius: 70,
                backgroundImage: photo != 'null' ?
                NetworkImage(photo):
                const NetworkImage(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSyC3KlHk3snYFP4HnCG8fFky0LFaNQsAou7Tr38omznxdFGJk0ZmiolvRndigUsFk3QIc&usqp=CAU")
              ):Container(),
          

          ],
        ).px12(),
      ),
    );
  }
}