import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class FirebaseService {

  final db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getWinners() async{
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await db.collection('ganadores').get();

      List<Map<String, dynamic>> datos = [];

      for (var doc in snapshot.docs) {
        datos.add(doc.data());
      }
      return datos;
    } catch (e) {
      return [];
    }
  
  }

  Future<Map<String, dynamic>>  getWinner() async{

    final doc = db.doc("/DataApp/gHCxGCgKoz76qoeS1Xm5");
    final snapshot1 = await doc.get();
    String sorteoName  = snapshot1.data()?['sorteo'];

      QuerySnapshot<Map<String, dynamic>> snapshot =
          await db.collection('participaciones')
          .where('sorteo', isEqualTo: sorteoName)
          .get();

      int count = snapshot.size;
      final random = Random();

      try{
        int n = 0 + random.nextInt(count - 0);
        final documents = snapshot.docs;
        final randomDocument = documents[n];
        return randomDocument.data();

      }catch (e){
        return {'nombre': 'error', 'email': 'error', 'fecha': 'error', 'sorteo': 'error', 'urlPhoto': 'error'};
      }
  }

  Future<bool> addWinner(String foto, String nombre, String numero,  String sorteo, String email)async {
    final doc = db.doc("/DataApp/gHCxGCgKoz76qoeS1Xm5");
    final snapshot = await doc.get();
    num monto = snapshot.data()?['monto'];
    String resultado = "${monto.toStringAsFixed(2)} USD";


    CollectionReference participaciones =  db.collection('ganadores');
    try{
        await participaciones.add({
        'foto': foto,
        'nombre': nombre,
        'numero': numero,
        'premio': resultado,
        'sorteo': sorteo,
        'email': email
      });
    }catch (e){
      return false;
    }
    return true;
  } 


  Future<Map<String, dynamic>> getDataApp() async {
    final doc = db.doc("/DataApp/gHCxGCgKoz76qoeS1Xm5");
    final snapshot = await doc.get();
    String nombre = snapshot.data()?['sorteo'];
    String estado = snapshot.data()?['estado'];
    String anuncio = snapshot.data()?['anuncio'];
    num valor = snapshot.data()?['valor'];
    num monto = snapshot.data()?['monto'];
    return {'nombre': nombre, 'valor': valor, 'estado': estado, 'monto': monto, 'anuncio': anuncio};
  }

  Future<void> updateSorteoName(sorteoName) async {
    final doc = db.doc("/DataApp/gHCxGCgKoz76qoeS1Xm5");
    await doc.update({
      'sorteo': sorteoName
    });
    
  }

  Future<void> updateSorteoNumber() async {
    final doc = db.doc("/DataApp/gHCxGCgKoz76qoeS1Xm5");
    final snapshot = await doc.get();
    String nombre = snapshot.data()?['sorteo'];
    num? n = num.tryParse(nombre);
    if(n != null){
      n = n + 1;
      await doc.update({
        'sorteo': n.toString()
      });
    }
  }

  Future<void> updateMonto(monto) async {
    final doc = db.doc("/DataApp/gHCxGCgKoz76qoeS1Xm5");
    await doc.update({
      'monto': monto
    });
  }

  Future<void> updateSorteoState(sorteoState) async {
    final doc = db.doc("/DataApp/gHCxGCgKoz76qoeS1Xm5");
    await doc.update({
      'estado': sorteoState
    });
  }

  Future<void> updateValue(value) async {
    final doc = db.doc("/DataApp/gHCxGCgKoz76qoeS1Xm5");
    await doc.update({
      'valor': value
    });
  }

  Future<void> updateAd(ad) async{
    final doc = db.doc("/DataApp/gHCxGCgKoz76qoeS1Xm5");
    await doc.update({
      'anuncio': ad
    });
  }

  Future<void> sendWinner(nombre, email, foto, numero, premio, sorteo) async{

    Map<String, dynamic> data = {
      'nombre': nombre,
      'email': email,
      'foto': foto,
      'numero': numero,
      'premio': '$premio USD' ,
      'sorteo': sorteo,
    };

    db.collection('ganadores')
    .add(data)
    .then((value) {

      return 'Documento agregado con ID: ${value.id}';
    })
    .catchError((error) {
      return 'Error al agregar el documento: $error';
    });

  }

  Future<void> deleteColeccion() async {
  QuerySnapshot querySnapshot = await db.collection('participaciones').get();

  for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
    await documentSnapshot.reference.delete();
  }
}

Future<int> obtenerNumeroDocumentos() async {
  QuerySnapshot querySnapshot = await db.collection('participaciones').get();
  return querySnapshot.size;
}
 
  
}
