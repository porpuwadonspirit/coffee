import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop/model.dart';
import 'package:coffee_shop/reportmodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Report extends StatefulWidget {
  String? id;
  Report({this.id});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  double number = 0;
  List<ReportModel> items = [];

  CollectionReference report_c =
      FirebaseFirestore.instance.collection("report");

  getitem() async {
    QuerySnapshot data = await report_c.get();
    items = [];
    int  i = 0;
    for (var data_f in data.docs) {
      print(data_f.data());
      Map<String, dynamic> item = data_f.data() as Map<String, dynamic>;
     
      items.add(ReportModel(
        id: item['id'],
        date: item['date'],
        items: []
      ));
      for(var data_p in item['items']){
        items[i].items!.add(ItemsProduct(
            id: data_p['id'],
            name: data_p['name'],
            price: data_p['price'],
            qty: data_p['qty'],
        ));
      }
      i += 1;
    }
    //sort
    items.sort(((a, b) => b.date!.compareTo(a.date!)));
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getitem();
  }

  double total(List<ItemsProduct?>? items){
    double _total = 0;
    for(var item in items!){
      _total += item!.price!;
    }
    return _total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Report")),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(items.length, (index){
            var item = items[index];
            return  ExpansionTile(
                title: Text('${item.id}'),
                subtitle: Text('${item.date}'),
                onExpansionChanged: (value) {},
                
                children: <Widget>[
                    for(var product in item.items!)
                        ListTile(
                            title: Text('${product!.name}'),
                            subtitle: Text('${product.price}'),
                            trailing: Text('${product.qty}'),
                        ),

                      Text('Total : ${total(item.items)} Bath') 
                ],
              );
          }),
        ),
      ),
    );
  }
}


// 
    // id
    // date
    // items
        // [

        // ]
// 
