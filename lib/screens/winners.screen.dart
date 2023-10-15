import 'package:flutter/material.dart';
import 'package:sorteo/util/size.congif.dart';
import 'package:sorteo/util/app.styles.dart';
import 'package:sorteo/util/firebase.helper.dart';

class WinnersScreen extends StatefulWidget {
  const WinnersScreen({super.key});

  @override
  State<WinnersScreen> createState() => _WinnersScreenState();
}

class _WinnersScreenState extends State<WinnersScreen> {
  final FirebaseService firebaseService = FirebaseService();
  List<Map<String, dynamic>> winnersList = [];
  
  @override
  void initState() {
    super.initState();
    showWinners();
  }

  Future<void> showWinners() async {
    final  winnersList_ = await firebaseService.getWinners();

    setState(() {
      winnersList = winnersList_;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        
          child: Column(
            children: [
              
              Container(
                color: kWhiteColor,
                padding: const EdgeInsets.only(
                  top: 40,
                  right: 24,
                  left: 24
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    
                    Text('Lista de ganadores', style: kJakartaHeading2.copyWith(
                      fontSize: SizeConfig.blockSizeHorizontal! * kHeading2, 
                      color: kDark10Color
                    ),),
                    
                  ],
                ),
              ),
        
              Container(
                height: 20,
                color: kWhiteColor,
              ),
        
             
    
              ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: winnersList.length,
              itemBuilder: (BuildContext context, int index) {
                final datos = winnersList[index];
                String sorteo = datos['sorteo'];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: datos['foto'].toString() != 'null' ? 
                      NetworkImage(datos['foto']) : 
                      const NetworkImage(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSyC3KlHk3snYFP4HnCG8fFky0LFaNQsAou7Tr38omznxdFGJk0ZmiolvRndigUsFk3QIc&usqp=CAU") 
                      
                      ,
                  ),
                  title: Text(datos['email'], style: kJakartaHeading4.copyWith(
                    fontSize: SizeConfig.blockSizeHorizontal! * kHeading4,
                    color: kDark10Color
                  ),),
                  subtitle: Text(datos['numero'].toString(), style: kJakartaBodyRegular.copyWith(
                    fontSize: SizeConfig.blockSizeHorizontal! * kBody1,
                  )),
                  
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sorteo #$sorteo", style: kJakartaBodyBold.copyWith(
                        fontSize: SizeConfig.blockSizeHorizontal! * kHeading4,
                        color: kDark10Color
                      )),
    
                      Text(datos['premio'], style: kJakartaBodyRegular.copyWith(
                        fontSize: SizeConfig.blockSizeHorizontal! * kBody1,
                      )),
    
                      
                    ],
                  ),
                );
              },
            ),
    
            Container(
              height: 20,
            ),
        
              
            IconButton(onPressed: (){
              showWinners();
            }, icon: const  Icon(Icons.refresh, size: 35,))
            
        
            ],
          ),
        
      ),
    );
  }
}