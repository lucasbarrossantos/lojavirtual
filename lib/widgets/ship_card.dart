import 'package:flutter/material.dart';

class ShipCard extends StatefulWidget {
  @override
  _ShipCardState createState() => _ShipCardState();
}

class _ShipCardState extends State<ShipCard> {
  IconData iconData = Icons.keyboard_arrow_down;

  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          "Calcular Frete",
          textAlign: TextAlign.start,
          style:
              TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        leading: Icon(Icons.location_on, color: Theme.of(context).primaryColor),
        trailing: Icon(iconData, color: Theme.of(context).primaryColor),
        onExpansionChanged: (bool isAlterado) {
          if (isAlterado) {
            setState(() {
              iconData = Icons.keyboard_arrow_up;
            });
          } else if (!isAlterado) {
            setState(() {
              iconData = Icons.keyboard_arrow_down;
            });
          }
        },
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: "",
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  hintText: "Digite seu CEP"),
              onFieldSubmitted: (text) {},
            ),
          ),
        ],
      ),
    );
  }
}
