import 'package:cloud_firestore/cloud_firestore.dart';
import 'model.dart';

class DatabaseHelper {
  final CollectionReference collection = 
  FirebaseFirestore.instance.collection("products");

  Future<DocumentReference> insertProduct(Product product) {
    return collection.add(product.toMap());
  }

  Future<void> updateProduct(String id,Product product) async {
    return await collection.doc(id).update(product.toMap());
  }

  void deleteProduct(Product product) async {
    await collection.doc(product.referenceId).delete();
  }

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }
}