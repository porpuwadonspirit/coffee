import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop/model.dart';
import 'package:coffee_shop/report.dart';
import 'package:coffee_shop/reportmodel.dart';
import 'package:flutter/material.dart';

class SellSystemPage extends StatefulWidget {
  @override
  _SellSystemPageState createState() => _SellSystemPageState();
}

class _SellSystemPageState extends State<SellSystemPage> {
  List<Product> _products = [
    
  ];

 CollectionReference product_c =
      FirebaseFirestore.instance.collection("products");

  CollectionReference report_c =
      FirebaseFirestore.instance.collection("report");

 
  getitems() async { 
    
    QuerySnapshot data = await product_c.get();
    _products = [];
    for (var data_f in data.docs) {
      print(data_f.data());
      Map<String,dynamic> item = data_f.data() as Map<String,dynamic>;
      item["id"] = data_f.id;
      _products.add(Product.fromMap(item));
    }
    setState(() {
      
    });
  }
 
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getitems();
  }

  List<ItemsProduct> _cart = [];

  double _total = 0;

  void _addToCart(ItemsProduct product) {
    setState(() {
      _cart.add(product);
      _total += product.price!;
    });
  }


  void _removeFromCart(int index) {
    setState(() {
      _total -= _cart[index].price!;
      _cart.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sell System'),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=>Report()));
          }, icon: Icon(Icons.history))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.brown[400])),
          
          Expanded(
            child: ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: ListTile(
                    iconColor: Colors.brown[400],
                    title: Text(product.name!),
                    subtitle: Text('${product.price}\Bath'),
                    trailing: IconButton(
                      icon: Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        _addToCart(ItemsProduct(
                          name: product.name,
                          price: product.price,
                          id: product.id,
                          qty: 1,
                        ));
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          
          Expanded( 
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
             children: [
              Padding(
               padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Orders',
                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.brown[400]),
                    ), 
                     ),

          Expanded(
            child: ListView.builder(
              itemCount: _cart.length,
              itemBuilder: (context, index) {
                final product = _cart[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.blue,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.check_circle),
                    iconColor: Colors.lightBlue[400],
                    title: Text(product.name!),
                    subtitle: Text('${product.price}\Bath'),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_shopping_cart),
                      onPressed: () {
                        _removeFromCart(index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          
          
          SizedBox(
            height: 56,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total of coffee: ${_cart.length}\Cup',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  
                ],
              ),
          )
          ),



          
          
          SizedBox(
            height: 56,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: ${_total.toStringAsFixed(2)}\Bath',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () async{
                      Random random = Random();
                      ReportModel item = ReportModel(
                        id: random.nextInt(999).toString(),
                        date: DateTime.now().toString(),
                        items: _cart
                      );
                      await report_c.doc().set(item.toMap());
                      // 
                      _cart = [];
                      _total = 0;
                      setState(() {});
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Thank you!'),
                          content: Text('Your bill has been checked.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text('Check Bill'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
          ),
        ],
      ),
    );
    
  }
}
