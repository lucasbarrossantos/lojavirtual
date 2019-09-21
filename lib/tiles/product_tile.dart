import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:lojavirtual/datas/product_data.dart';
import 'package:lojavirtual/screens/product_screen.dart';

class ProductTile extends StatelessWidget {
  final controller = new MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.');
  final String type;
  final ProductData product;

  ProductTile(this.type, this.product) {
    this.controller.updateValue(this.product.price);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ProductScreen(product))
        );
      },
      child: Card(
        child: type == "grid" ? buildColumn(context) : buildRow(context),
      ),
    );
  }

  Row buildRow(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Image.network(product.images[0],
              fit: BoxFit.cover, height: 250.0),
        ),
        Flexible(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(product.title,
                    style: TextStyle(fontWeight: FontWeight.w500)),
                Text("R\$ ${controller.text}",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        )
      ],
    );
  }

  Column buildColumn(BuildContext context) {
    return Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 0.8,
          child: Image.network(product.images[0], fit: BoxFit.cover),
        ),
        Expanded(
            child: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(product.title,
                  style: TextStyle(fontWeight: FontWeight.w500)),
              Text("R\$ ${controller.text}",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ))
      ],
    );
  }
}
