import 'package:flaevr/components/productGrid.dart';
import 'package:flaevr/models/Folder.dart';
import 'package:flaevr/services/ProductService.dart';
import 'package:flutter/material.dart';
import 'package:flaevr/models/ProductModel.dart';

class Products extends StatefulWidget {
  Products({Key key, this.folder}) : super(key: key);

  final Folder folder;

  @override
  ProductsState createState() => ProductsState();
}

class ProductsState extends State<Products> {
  Future<List<ProductModel>> futureProducts;

  void initState() {
    futureProducts =
        ProductService.getAllProductsInFolder(this.widget.folder.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(children: [
        Container(
          margin: EdgeInsets.only(bottom: 10),
        ),
        FutureBuilder<List<ProductModel>>(
          future: futureProducts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ProductGrid(
                  physics: new NeverScrollableScrollPhysics(),
                  built: true,
                  products: snapshot.data);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return ProductGrid(
                physics: new NeverScrollableScrollPhysics(),
                built: false,
                products: []);
          },
        ),
      ])),
    );
  }
}
