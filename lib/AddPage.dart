import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:coffee_shop/model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'database_helper.dart';

class ProductForm extends StatefulWidget {
  String? id;
  ProductForm({required this.dbHelper, this.id});
  DatabaseHelper dbHelper;

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _image = TextEditingController();
  final _price = TextEditingController();

  CollectionReference product_c =
      FirebaseFirestore.instance.collection("products");
  final keyfrom = GlobalKey<FormState>();
  Random random = Random();
  FirebaseStorage firestore = FirebaseStorage.instance;

  Future<String> uploadImage(
      {File? file, String? location, String? prefix, String image = ''}) async {
    int i = random.nextInt(100000);
    if (image.isNotEmpty) await firestore.refFromURL(image).delete();
    await firestore.ref().child('$location/$prefix$i.jpg').putFile(file!);
    String urlPhoto =
        await firestore.ref().child('$location/$prefix$i.jpg').getDownloadURL();
    return urlPhoto;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.id != null) {
      getitem();
    }
  }

  getitem() async {
    DocumentSnapshot data = await product_c.doc(widget.id).get();
    Product item = Product.fromMap(data.data() as Map<String, dynamic>);
    _name.text = item.name!;
    _description.text = item.description!;
    _image.text = item.image!;
    _price.text = item.price.toString();
  }

  final ImagePicker _picker = ImagePicker();
  File? images;
  imgPicker(ImageSource img) async {
    try {
      final XFile? picker = await _picker.pickImage(
        source: img,
        maxWidth: 640,
        maxHeight: 640,
        imageQuality: 50,
      );
      setState(() {
        images = File(picker!.path);
      });
    } catch (e) {
      print(e);
    }
  }

  ImageProvider imageProvider({File? file, String url = ''}) {
    ImageProvider? img;
    if (file == null) {
      img = NetworkImage(url);
    } else {
      img = FileImage(file);
    }
    return img;
  }

  final int _favorite = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: keyfrom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ListTile(
                  title: Center(
                    child: Text(
                      'Product input Form',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => imgPicker(ImageSource.camera),
                  child: Container(
                    width: 165,
                    height: 165,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(211, 221, 231, 1),
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                            image: imageProvider(
                              file: images,
                              url: _image.text,
                            ),
                            onError: (err, stackTrace) => {},
                            fit: BoxFit.cover)),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: TextFormField(
                        controller: _name,
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: 'Product Name',
                          hintText: 'input your name of product',
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: TextFormField(
                        controller: _description,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'input description of product',
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: TextFormField(
                        controller: _price,
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          hintText: 'input price',
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: ElevatedButton(
                          child:  Text(widget.id == null?'Add':"Update"),
                          onPressed: () async {
                            if (images != null) {
                              _image.text = await uploadImage(
                                  file: images,
                                  location: "IMGProoducts",
                                  prefix: "Prd");
                            }
                            Product newProduct = Product(
                                name: _name.text,
                                description: _description.text,
                                price: double.parse(_price.text),
                                favorite: 0,
                                image: _image.text,
                                referenceId: null);
                            if (widget.id == null) {
                              await widget.dbHelper
                                  .insertProduct(newProduct)
                                  .then((value) =>
                                      newProduct.referenceId = value.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      '${newProduct.name} is inserted complete...'),
                                ),
                              );
                            }else {
                              await widget.dbHelper.updateProduct(widget.id!,newProduct).then(
                                    (value) => newProduct.referenceId = widget.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${newProduct.name} is update complete...'),
                                        ),
                                    );
                            }

                            Navigator.pop(context);
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
