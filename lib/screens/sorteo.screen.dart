import 'package:flutter/material.dart';
import 'package:sorteo/util/size.congif.dart';
import 'package:sorteo/util/app.styles.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sorteo/util/firebase.helper.dart';
import 'package:sorteo/screens/winners.screen.dart';
import 'package:sorteo/screens/make_winner.screen.dart';
import 'dart:async';

class SorteoScreen extends StatefulWidget {
  const SorteoScreen({super.key});

  @override
  State<SorteoScreen> createState() => _SorteoScreenState();
}

class _SorteoScreenState extends State<SorteoScreen> {
  final FirebaseService firebaseService = FirebaseService();

  String name = '';
  String email = '';
  String sorteo = '';
  String photo = '';
  String numero = '';

  bool getWinner = false;
  bool showButton = false;
  bool isInitNewSorteo = false;
   
  
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

  Future<void> initNewSorteo() async {
    num n = 0;
    firebaseService.updateMonto(n);
    firebaseService.updateSorteoNumber();
    firebaseService.updateSorteoState('Sorteo activo');
    setState(() {
      isInitNewSorteo = true;
    });
  }

  Future<void> getWinnerData() async{
    final winnerData = await firebaseService.getWinner();
    setState(() {
      name = winnerData['nombre'];
      email = winnerData['email'];
      numero = winnerData['fecha'];
      sorteo = winnerData['sorteo'];
      photo = winnerData['urlPhoto'].toString();
      getWinner = true;
    });

    bool flag = await firebaseService.addWinner(
      photo, 
      name, 
      numero, 
      sorteo, 
      email);

    if(flag == true){
      setState(() {
        showButton = true;
        initNewSorteo();
      });
    }else{
      showMessage('Error, no se pudo publicar el ganador', Colors.red);
    }

  }

  void initSorteo(){

    try{
      firebaseService.updateSorteoState('Fin del sorteo');
      getWinnerData();
      
    }catch (e){
      firebaseService.updateSorteoState('Error');
    }

  }

  
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final db = FirebaseFirestore.instance;
    final doc = db.doc("/DataApp/gHCxGCgKoz76qoeS1Xm5");

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [

            Container(
              height: 50,
            ),

            isInitNewSorteo?
            Text('Nuevo sorteo iniciado', style: kJakartaHeading3.copyWith(
              fontSize: SizeConfig.blockSizeHorizontal! * kHeading3,
              color: kParagraphColor
            ),):
            GestureDetector(
              onTap: (){
                initSorteo();
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                color: kBackgroundColor,
                child: const Text("Iniciar Sorteo"),
              ),
            ),

            Container(
              height: 20,
            ),

            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>> (
                stream: doc.snapshots(),
                builder: (context, snapshot) {

                  if(!snapshot.hasData){
                    return const CircularProgressIndicator();
                  }
                  final docSnap = snapshot.data!;
                  String sorteo = docSnap['sorteo'];
                  return Text('Sorteo #$sorteo', style:  kJakartaBodyBold.copyWith(
                    fontSize: SizeConfig.blockSizeHorizontal! * kHeading2,
                    color: kParagraphColor
                  ), );
                },
              ),

              Container(
              height: 20,
            ),

            Container(
              height: 20,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Monto', style: kJakartaHeading3.copyWith(
                  fontSize: SizeConfig.blockSizeHorizontal! * kHeading3,
                  color: kPrimaryColor
                ),),
                
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>> (
                stream: doc.snapshots(),
                builder: (context, snapshot) {

                  if(!snapshot.hasData){
                    return const CircularProgressIndicator();
                  }
                  final docSnap = snapshot.data!;
                  String monto = docSnap['monto'].toStringAsFixed(2);
                  return Text(monto, style:  kJakartaBodyBold.copyWith(
                    fontSize: SizeConfig.blockSizeHorizontal! * kHeading3,
                    color: kParagraphColor
                  ), );
                },
              ),

              ],
            ).px20(),            

            Container(
              height: 20,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Estado : '),
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>> (
                stream: doc.snapshots(),
                builder: (context, snapshot) {

                  if(!snapshot.hasData){
                    return const CircularProgressIndicator();
                  }
                  final docSnap = snapshot.data!;
                  String monto = docSnap['estado'];
                  return Text(monto,);
                },
              ),

              ],
            ),

            Container(
              height: 20,
            ),

            const Divider(
              thickness: 2,
              color: kBackgroundColor,
            ),

            getWinner?
            Text('Ganador Sorteo #$sorteo', style: kJakartaHeading3.copyWith(
              fontSize: SizeConfig.blockSizeHorizontal! * kHeading2,
              color: kPrimaryColor
            ),):
            Container(),

            Container(
              height: 10,
            ),

            getWinner?
              CircleAvatar(
                radius: 50,
                backgroundImage: photo != 'null' ?
                NetworkImage(photo):
                const NetworkImage(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSyC3KlHk3snYFP4HnCG8fFky0LFaNQsAou7Tr38omznxdFGJk0ZmiolvRndigUsFk3QIc&usqp=CAU")
              ):Container(),  

            Container(
              height: 10,
            ),

            getWinner?       
            Text(name, style: kJakartaHeading3.copyWith(
              fontSize: SizeConfig.blockSizeHorizontal! * kHeading3,
              color: kParagraphColor
            ) ):Container()  ,

            Container(
              height: 10,
            ),

            getWinner?       
            Text(email, style: kJakartaBodyRegular.copyWith(
              fontSize: SizeConfig.blockSizeHorizontal! * kHeading4,
              color: kParagraphColor
            ) ):Container(),

            Container(
              height: 10,
            ),


            getWinner?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(numero, style: kJakartaBodyRegular.copyWith(
                  fontSize: SizeConfig.blockSizeHorizontal! * kHeading4,
                  color: kParagraphColor
                )),
                
                Text('Sorteo #$sorteo', style: kJakartaBodyRegular.copyWith(
                  fontSize: SizeConfig.blockSizeHorizontal! * kHeading4,
                  color: kParagraphColor
                ))
              ],
            ).px20():Container(),

            Container(
              height: 10,
            ),

            showButton?
            Text('Ganador publicado!',  style: kJakartaBodyRegular.copyWith(
                  fontSize: SizeConfig.blockSizeHorizontal! * kHeading4,
                  color: kParagraphColor
                )):
            Container(),

            Container(
              height: 10,
            ),

            showButton?
            Text('Iniciando nuevo sorteo!',  style: kJakartaBodyRegular.copyWith(
                  fontSize: SizeConfig.blockSizeHorizontal! * kHeading4,
                  color: kParagraphColor
                )):
            Container(),

            Container(
              height: 10,
            ),

            GestureDetector(
              onTap: (){ 
                Navigator.push(context, MaterialPageRoute(builder: (context) => const WinnersScreen() ));
               },
              child: Container(
                padding: const EdgeInsets.all(15),
                color: kBackgroundColor,
                child: const Text("Ver lista de Ganadores"),
              ),
            ),

            Container(
              height: 10,
            ),


            GestureDetector(
              onTap: (){ 
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MakeWinner() ));
               },
              child: Container(
                padding: const EdgeInsets.all(15),
                color: kBackgroundColor,
                child: const Text("Crear Ganador"),
              ),
            ),


          ],
        ),
      ),
    );
  }
}