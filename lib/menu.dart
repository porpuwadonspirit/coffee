import 'dart:io';
import 'package:coffee_shop/AddPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'model.dart';
import 'package:coffee_shop/database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuPage extends StatefulWidget {
  MenuPage({Key? key, required this.dbHelper}) : super(key: key);
  DatabaseHelper dbHelper;
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Product> _menuItems = [];
  late DatabaseHelper _dbHelper;

  List<Product> _searchItems = [];

  CollectionReference product_c =
      FirebaseFirestore.instance.collection("products");

  getitems() async {
    QuerySnapshot data = await product_c.get();
    _menuItems = [];
    _searchItems = [];
    for (var data_f in data.docs) {
      print(data_f.data());
      Map<String, dynamic> item = data_f.data() as Map<String, dynamic>;
      item["id"] = data_f.id;
      _menuItems.add(Product.fromMap(item));
      _searchItems.add(Product.fromMap(item));
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getitems();
  }

    void delete(BuildContext context,String id) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductForm(
                              dbHelper: widget.dbHelper,
                              id: id,
                            )),
                  );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Menu of You'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductForm(
                            dbHelper: widget.dbHelper,
                          )),
                ).then((value) => getitems());
              },
              icon: Icon(Icons.add))
        ],
      ),

      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
                labelText: "search",
                icon: Icon(Icons.search, color: Colors.black),
                labelStyle: TextStyle(color: Colors.black)),
            onChanged: (value) {
              _menuItems = _searchItems
                  .where((u) =>
                      (u.name!.toLowerCase().contains(value.toLowerCase())))
                  .toList();
              setState(() {});
            },
          ),
          Expanded(
            child: ListView.builder(
              primary: true,
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                var item = _menuItems[index];
                void edit(BuildContext context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>  ProductForm(
                              dbHelper: widget.dbHelper,
                              id: item.id,
                            )),
                  ).then((value) => getitems()); 

                }
                void delete(BuildContext context) {
                  showDialog(context: context, builder: (_){
                    return AlertDialog(
                      content: Text('You want to delete ${item.name}?'),
                      actions: [
                        // ok
                        TextButton(
                          onPressed: ()async{
                          await widget.dbHelper.deleteProduct(item.id!);
                          await getitems();
                          Navigator.pop(_);
                        }, child: Text('Delete',style: TextStyle(color: Colors.red))),
                        // canell
                        TextButton(onPressed: ()=>Navigator.pop(_), child: Text('Cancel'))
                      ],
                    );
                  });;
                }
                return Slidable(
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [

                      SlidableAction(
                        onPressed: edit,
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                       SlidableAction(
                        onPressed: delete,
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: Card(
                    child: InkWell(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              width: 60,
                              height: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(211, 221, 231, 1),
                                  borderRadius: BorderRadius.circular(0),
                                  image: DecorationImage(
                                      image: imageProvider(
                                        url: item.image!,
                                      ),
                                      onError: (err, stackTrace) => {},
                                      fit: BoxFit.cover)),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name!,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  item.description!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text('${item.price}'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      //  Container(
      //                       width: 165,
      //                       height: 165,
      //                       alignment: Alignment.center,
      //                       decoration: BoxDecoration(
      //                           color: Color.fromRGBO(211, 221, 231, 1),
      //                           borderRadius: BorderRadius.circular(100),
      //                           image: DecorationImage(
      //                               image: imageProvider(
      //                                 file: images,
      //                               ),
      //                               onError: (err, stackTrace) => {},
      //                               fit: BoxFit.cover)),

      //                     ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}
