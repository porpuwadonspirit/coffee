import 'dart:math';
import 'package:flutter/material.dart';


class PromotionPage extends StatelessWidget {
  final List<String> _menuItems = [    
    'Latte',
    'Cappuccino',
    'Americano',    
    'Espresso',    
    'Mocha',    
    'Flat White',    
    'Macchiato',  ];

  final List<String> _imagePaths = [    
    'assets/poss.jpeg',    
    'assets/poss.jpeg',    
    'assets/poss.jpeg',    
    'assets/poss.jpeg',    
    'assets/poss.jpeg',    
    'assets/poss.jpeg',    
    'assets/poss.jpeg',  ];

  final Random _random = Random();
  final int _randomIndex;

  PromotionPage() : _randomIndex = Random().nextInt(7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('Promotion'),
      ),


      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              _imagePaths[_randomIndex],
              fit: BoxFit.cover,
              height: 300,
              width: 300,
            ),
            Text(
              'Buy 1 Get 1 Free',
              style: TextStyle(
                fontSize: 30,
              ),
            ),


           
            Text(
              'Congratulations!',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            

   
            Text(
              'You have won a free ${_menuItems[_randomIndex]}!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.red,
              ),
            ),
            


            Text(
              'Have a nice day!',
              style: TextStyle(
                fontSize: 18,),
            ),
          ],
        ),
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}
