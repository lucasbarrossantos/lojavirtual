import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class OrderTile extends StatelessWidget {
  final controller = new MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.');

  final String orderId;

  OrderTile(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection("orders")
                .document(orderId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              else {
                int status = snapshot.data["status"];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Código do pedido: ${snapshot.data.documentID}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4.0),
                    Text(_buildProductsText(snapshot.data)),
                    SizedBox(height: 4.0),
                    Text("Status do Pedido:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _buildCircle("1", "Preparação", status, 1, context),
                        Container(height: 1.0, width: 40.0, color: Colors.grey[500]),
                        _buildCircle("2", "Transporte", status, 2, context),
                        Container(height: 1.0, width: 40.0, color: Colors.grey[500]),
                        _buildCircle("3", "Entregue", status, 3, context),
                      ],
                    )
                  ],
                );
              }
            }),
      ),
    );
  }

  String _buildProductsText(DocumentSnapshot snapshot) {
    String text = "Descrição:\n";
    for (LinkedHashMap p in snapshot.data["products"]) {
      controller.updateValue(p["product"]["price"]);
      text +=
          "${p["quantity"]} x ${p["product"]["title"]} (R\$ ${controller.text}) \n";
    }
    controller.updateValue(snapshot.data["totalPrice"]);
    text += "Total: R\$ ${controller.text}";
    return text;
  }

  Widget _buildCircle(String title, String subTitle,
      int status, int thisStatus, BuildContext context) {

    Color backColor;
    Widget child;

    if (status < thisStatus) {
      backColor = Colors.grey[500];
      child = Text(title, style: TextStyle(color: Colors.white));
    } else if (status == thisStatus) {
      backColor = Theme.of(context).primaryColor;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(title, style: TextStyle(color: Colors.white)),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    } else {
      backColor = Theme.of(context).primaryColor;
      child = Icon(Icons.check, color: Colors.white);
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subTitle)
      ],
    );
  }
}
