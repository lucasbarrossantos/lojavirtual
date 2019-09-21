import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:lojavirtual/models/cart_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartPrice extends StatelessWidget {
  final VoidCallback buy;

  CartPrice(this.buy);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child:
            ScopedModelDescendant<CartModel>(builder: (context, child, model) {
          var controller = new MoneyMaskedTextController(
              decimalSeparator: ',', thousandSeparator: '.');

          double price =
              parseValue(model.getProductsPrice(), controller).numberValue;
          double discount =
              parseValue(model.getDiscount(), controller).numberValue;
          double ship =
              parseValue(model.getShipPrice(), controller).numberValue;
          double total = (price + ship - discount);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text("Resumo do Pedido",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 12.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Subtotal"),
                    Text(
                        "R\$ ${parseValue(model.getProductsPrice(), controller).text}"),
                  ]),
              Divider(color: Theme.of(context).primaryColor),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Desconto"),
                    Text(
                        "R\$ ${discount > 0 ? "- ${parseValue(model.getDiscount(), controller).text}" : "${parseValue(model.getDiscount(), controller).text}"}"),
                  ]),
              Divider(color: Theme.of(context).primaryColor),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Entrega"),
                    Text(
                        "R\$ ${parseValue(model.getShipPrice(), controller).text}"),
                  ]),
              Divider(color: Theme.of(context).primaryColor),
              SizedBox(height: 12.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Total",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0)),
                    Text("R\$ ${parseValue(total, controller).text}",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0)),
                  ]),
              SizedBox(height: 12.0),
              SizedBox(
                height: 40,
                child: RaisedButton(
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    child: Text("Finalizar Pedido"),
                    onPressed: buy),
              ),
            ],
          );
        }),
      ),
    );
  }
}

MoneyMaskedTextController parseValue(
    double value, MoneyMaskedTextController controller) {
  controller.updateValue(value);
  return controller;
}
