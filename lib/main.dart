import 'package:flutter/material.dart';
import 'util/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'util/size.congif.dart';
import 'util/app.styles.dart';
import 'util/firebase.helper.dart';
import 'package:velocity_x/velocity_x.dart';
import 'screens/sorteo.screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseService firebaseService = FirebaseService();
  
  final TextEditingController _controllerSorteoName = TextEditingController();
  final TextEditingController _controllerMonto = TextEditingController();
  final TextEditingController _controllerState = TextEditingController();
  final TextEditingController _controllerValue = TextEditingController();
  final TextEditingController _controllerAd = TextEditingController();

  String sorteo = '';
  String estado = '';
  String valor = '';
  String anuncio = '';
  num monto = 0;
  int nParticiapaciones = 0;

  @override
  void initState(){
    super.initState();
    getData();
  }

  void getData() async{
    
    final data = await firebaseService.getDataApp();
    int n = await firebaseService.obtenerNumeroDocumentos();
    setState(() {
      nParticiapaciones = n;
      sorteo = data['nombre'];
      estado = data['estado'];
      monto = data['monto'];
      anuncio = data['anuncio'];
      valor = data['valor'].toString();
    });
    
  }

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
    SizeConfig().init(context);

    return  Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){ getData(); },
              child: Image.asset('assets/logo.png', scale: 4,)
              ),

            Text(nParticiapaciones.toString()),

            Row(
              
              children: [
                

                Expanded(
                  child: TextField(
                    controller:  _controllerSorteoName,
                    decoration: InputDecoration(
                      hintText: sorteo
                    ),
                    
                    
                  ),
                ),

                IconButton(
                  onPressed: (){
                    if(_controllerSorteoName.text != ''){
                      firebaseService.updateSorteoName(_controllerSorteoName.text);
                      FocusScope.of(context).unfocus();
                      getData();
                      _controllerSorteoName.clear();

                    }
                    
                  }, 
                  icon: const Icon(Icons.send)
                  )
              ],
            ).px20(),

            Container(
              height: 10,
            ),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controllerMonto,
                    decoration: InputDecoration(
                      hintText: monto.toStringAsFixed(2)
                    ),
                    
                  ),
                ),

                IconButton(
                  onPressed: (){
                    if(_controllerMonto.text != ''){
                      num? n = num.tryParse(_controllerMonto.text);
                      if(n != null){
                        firebaseService.updateMonto(n);
                        FocusScope.of(context).unfocus();
                        getData();
                        _controllerMonto.clear();

                      }else{
                        showMessage('Error, Formato invalido', Colors.red);
                      }
                      
                    }
                    

                  }, 
                  icon: const Icon(Icons.send)
                  )
              ],
            ).px20(),

            Container(
              height: 10,
            ),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controllerState,
                    decoration: InputDecoration(
                      hintText: estado
                    ),
                    
                  ),
                ),

                IconButton(
                  onPressed: (){
                    if(_controllerState.text != ''){
                      firebaseService.updateSorteoState(_controllerState.text);
                      FocusScope.of(context).unfocus();
                      getData();
                      _controllerState.clear();
                    }

                  }, 
                  icon: const Icon(Icons.send)
                  )
              ],
            ).px20(),

            Container(
              height: 10,
            ),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controllerValue,
                    decoration: InputDecoration(
                      hintText: valor
                    ),
                    
                  ),
                ),

                IconButton(
                  onPressed: (){
                    if(_controllerValue.text != ''){
                      num? n = num.tryParse(_controllerValue.text);
                      if(n != null){
                        firebaseService.updateValue(n);
                        getData();
                        FocusScope.of(context).unfocus();
                        _controllerValue.clear();
                      }
                    }

                  }, 
                  icon: const Icon(Icons.send)
                  )
              ],
            ).px20(),

            Container(
              height: 10,
            ),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controllerAd,
                    decoration: InputDecoration(
                      hintText: anuncio
                    ),
                    
                  ),
                ),

                IconButton(
                  onPressed: (){
                    if(_controllerAd.text != ''){
                      firebaseService.updateAd(_controllerAd.text);
                      getData();
                      FocusScope.of(context).unfocus();
                      _controllerAd.clear();

                    }

                  }, 
                  icon: const Icon(Icons.send)
                  )
              ],
            ).px20(),

            Container(
              height: 10,
            ),

            IconButton(
              onPressed: (){
                getData();
                FocusScope.of(context).unfocus();

              }, 
              icon: const Icon(Icons.refresh, size: 35,)
            ),

            Container(
              height: 10,
            ),

            GestureDetector(
              onTap: (){ Navigator.push(
                context,  
                MaterialPageRoute(builder: (context) =>  const SorteoScreen() ) 
                ); 
              },
              child: Container(
                color: kDark40Color,
                padding: const EdgeInsets.all(15),
                child: Text("Sorteo", style: kJakartaHeading4.copyWith(
                  color: kWhiteColor
                )),
              ),
            )
            
          ],
        ),
      ),
    );
  }
}
