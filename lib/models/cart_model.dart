import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/datas/cart_product.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;

  bool isIsloading = false;

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  List<CartProduct> products = [];
  String couponCode;
  int discountPercentage = 0;

  CartModel(this.user) {
    if (user.isLoggedIn()) _loadCartItems();
  }

  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct);
    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .add(cartProduct.toMap())
        .then((doc) {
      cartProduct.cid = doc.documentID;
    });

    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) {
    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cid)
        .delete();

    products.remove(cartProduct);
    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.quantity--;
    updateCartProduct(cartProduct);
    notifyListeners();
  }

  void incProduct(CartProduct cartProduct) {
    cartProduct.quantity++;
    updateCartProduct(cartProduct);
    notifyListeners();
  }

  void _loadCartItems() async {
    QuerySnapshot query = await getCartsByUsers();

    products =
        query.documents.map((doc) => CartProduct.fromDocument(doc)).toList();
    notifyListeners();
  }

  void setCoupon(String couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  void updatePrices() {
    notifyListeners();
  }

  double getProductsPrice() {
    double price = 0.0;
    products.forEach((c) {
      if (c.productData != null) price += c.quantity * c.productData.price;
    });

    return price;
  }

  double getDiscount() {
    return getProductsPrice() * discountPercentage / 100;
  }

  double getShipPrice() {
    return 10.0;
  }

  Future<String> finishOrder() async {
    if (products.length == 0) return null;

    isIsloading = true;
    notifyListeners();

    double productsPrices = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    DocumentReference referenceOrder = await _createOrder(shipPrice, productsPrices, discount);
    await _setIdOrder(referenceOrder);
    QuerySnapshot query = await getCartsByUsers();

    _removeAllCartsFromCurrentUser(query);

    products.clear();
    couponCode = null;
    discountPercentage = 0;
    isIsloading = false;
    notifyListeners();

    return referenceOrder.documentID;
  }

  void _removeAllCartsFromCurrentUser(QuerySnapshot query) {
    query.documents.forEach((doc) {
      doc.reference.delete();
    });
  }

  Future<QuerySnapshot> getCartsByUsers() async {
    QuerySnapshot query = await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .getDocuments();
    return query;
  }

  Future _setIdOrder(DocumentReference referenceOrder) async {
    await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("orders")
        .document(referenceOrder.documentID)
        .setData({"orderId": referenceOrder.documentID});
  }

  Future<DocumentReference> _createOrder(double shipPrice, double productsPrices, double discount) async {
    DocumentReference referenceOrder =
        await Firestore.instance.collection("orders").add({
      "clientId": user.firebaseUser.uid,
      "products": products.map((cartProduct) => cartProduct.toMap()).toList(),
      "shipPrice": shipPrice,
      "productsPrices": productsPrices,
      "discount": discount,
      "totalPrice": productsPrices - discount + shipPrice,
      "status": 1
    });
    return referenceOrder;
  }

  void updateCartProduct(CartProduct cartProduct) {
    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());
  }
}
