import 'package:flutter/material.dart';
import 'package:m_product/db/localDb.dart';

import '../model/product.dart';
import '../widget/cart_tile.dart';

class Stock extends StatefulWidget {
  const Stock({super.key});

  @override
  State<Stock> createState() => _StockState();
}

class _StockState extends State<Stock> {
  List<dynamic> productList = [];
  List<Product> product = [];
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      productList = await LocalDataBase(context).getAllProducts();
      product = productList.map((data) {
        return Product(
          id: data['id'],
          title: data['title'],
          description: data['description'],
          image: data['image'],
          sellingPrice: data['sellingPrice'],
          purchasePrice: data['purchasePrice'],
          quantity: data['quantity'],
        );
      }).toList();
     
      setState(() {
        isLoading = false;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          // title: Text(AppLocalizations.of(context)!.home_message),
          title: Text('dsds'),
          centerTitle: false,
          actions: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Icon(Icons.refresh)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemBuilder: (context, index) => CartTile(
                          product: product[index],
                        ),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 20),
                        itemCount: product.length,
                      ),
                    ),
                  ],
                ),
        ));
  }
}
