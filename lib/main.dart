import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() {
  runApp(MyApp(cart: getData()));
}

class Cart{
  final num id;
  final String title;
  final num price;
  final String description;
  final String category;

  Cart({required this.id, required this.title, required this.price, required this.description, required this.category});
}

Future<ShoppingList> getData() async {
  String uri = 'https://fakestoreapi.com/products';
  final response = await http.get(Uri.parse(uri));
  if(response.statusCode == 200){
    return fromJson(json.decode(response.body));
  }else{
    throw Exception('Failed to load post');
  }
}

class ShoppingList{
  late final List<Cart> result;
  ShoppingList({required this.result});
}

ShoppingList fromJson(List<dynamic> json){
  List<Cart> listShopping = <Cart>[];
  json.forEach((data) {
    Cart contrib =  new Cart(
        price: data['price'],
        id: data['id'],
        description: data['description'],
        category: data['category'],
        title: data['title']
    );
    listShopping.add(contrib);
  });
  return new ShoppingList(result: listShopping);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<ShoppingList> cart;

  MyApp({required this.cart});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping',
      home: Scaffold(
        body: Center(
          child: FutureBuilder<ShoppingList>(
            future: cart,
            builder: (context, fetchData) {
              if(fetchData.hasData) {
                return ListView.builder(
                  itemCount: fetchData.data!.result.length,
                  itemBuilder: (context, index) {
                    final cart = fetchData.data!.result[index];
                    return ListTile(
                      title: new Row(
                        children: <Widget>[
                          Expanded(child:
                            Text(cart.title)
                          )
                        ]
                      ),
                        subtitle: Text("Gía: ${cart.price.toStringAsFixed(2)}"),
                        trailing: Column(
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        title: new Text('Nhập số lượng'),
                                        content: new SingleChildScrollView(
                                          child: TextField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: 'Nhập số lượng',
                                            ),
                                          )
                                        ),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          child: Text('Chọn'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  }
                                );
                              },
                              child: Text('Mua')
                            )
                          ]
                        )
                    );
                  }
                );
              } else if(fetchData.hasError){
                return Text("${fetchData.error}");
              }
              return CircularProgressIndicator();
            }
          )
        )
      ),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}


