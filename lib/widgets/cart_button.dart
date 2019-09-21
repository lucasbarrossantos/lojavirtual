import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/cart_model.dart';
import 'package:lojavirtual/screens/cart_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class CartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ScopedModelDescendant<CartModel>(builder: (context, child, model) {
        if (model.products.length > 0)
          return Badge(
            badgeContent: Text(model.products.length.toString()),
            badgeColor: Color.fromARGB(255, 211, 118, 130),
            padding: EdgeInsets.all(11),
            animationType: BadgeAnimationType.scale,
            child: FloatingActionButton(
              child: Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CartScreen()));
              },
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        else
          return FloatingActionButton(
            child: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => CartScreen()));
            },
            backgroundColor: Theme.of(context).primaryColor,
          );
      }),
    );
  }
}
