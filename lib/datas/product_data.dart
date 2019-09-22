import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

var controller = new MoneyMaskedTextController(
    decimalSeparator: ',', thousandSeparator: '.');

class ProductData {
  String category;
  String id;
  String title;
  String description;
  double price;
  List images;
  List sizes;

  ProductData.fromDocments(DocumentSnapshot snapshot) {
    controller.updateValue(snapshot.data["price"] + 0.0);
    id = snapshot.documentID;
    title = snapshot.data["title"];
    description = snapshot.data["description"];
    price = controller.numberValue;
    images = snapshot.data["images"];
    sizes = snapshot.data["size"];
  }

  Map<String, dynamic> toResumeMap() {
    return {"title": title, "price": price};
  }
}
