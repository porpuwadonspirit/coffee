import 'package:coffee_shop/database_helper.dart';
import 'package:coffee_shop/menu.dart';
import 'package:coffee_shop/model.dart';
import 'package:coffee_shop/promotion.dart';
import 'package:coffee_shop/sell.dart';
import 'package:flutter/material.dart';
import'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(CoffeeShopApp());
}


class CoffeeShopApp extends StatefulWidget {

CoffeeShopApp({Key? key}) : super(key: key);
  
  @override
  _CoffeeShopAppState createState() => _CoffeeShopAppState();}


class _CoffeeShopAppState extends State<CoffeeShopApp> {
  // add List of Product variable for List creation
   List<Product> products = [];


  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Shop',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: HomePage(
       dbHelper: DatabaseHelper(),),
    );
  }
}



class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.dbHelper}) : super(key: key);
   DatabaseHelper dbHelper;

  @override
  _HomePageState createState() => _HomePageState();}
  class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coffee Shop'),
        backgroundColor: Colors.brown[400],
        
      ),
      
      body: Column(
        children: [
          Image.asset(
            'assets/poss.jpeg',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          
  


          SizedBox(height: 16),
          Center(
            child: Text(
              'Welcome to our Coffee Shop!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          
          
          SizedBox(height: 16),
          Center(
            child: Text(
              'We serve the best coffee in town, made with premium beans from around the world.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),


      
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuPage(dbHelper:DatabaseHelper(),)),
                );
              },
              child: Text('View Menu'),
            ),
          ),


          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PromotionPage()),
                );
              },
              child: Text('View Promotion'),
            ),
          ),


           Center(
             child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SellSystemPage()),
                );
              },
              child: Text('Buy Now'),
          ),
           ),

          //  Center(
          //    child: ElevatedButton(
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => SellSystemPage()),
          //       );
          //     },
          //     child: Text('Sell Now'),
          //    ),
          //  ),


          // ElevatedButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => EditCoffeePage()),
          //     );
          //   },
          //   child: Text('Edit Coffee'),
          // ),
          
        ],
      ),
    );
  }
}
