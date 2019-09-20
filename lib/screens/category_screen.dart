import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/datas/product_data.dart';
import 'package:lojavirtual/tiles/product_tile.dart';

class CategoryScreen extends StatelessWidget {
  final DocumentSnapshot snapshot;

  CategoryScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Qtd de tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(snapshot.data["title"]),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(icon: Icon(Icons.grid_on)),
              Tab(icon: Icon(Icons.list))
            ],
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
            future: Firestore.instance
                .collection("products")
                .document(snapshot.documentID)
                .collection("items")
                .getDocuments(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              else
                return TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      buildGridView(snapshot),
                      buildListView(snapshot),
                    ]);
            }),
      ),
    );
  }

  // Lista em Grade
  GridView buildGridView(AsyncSnapshot<QuerySnapshot> snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(4.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          childAspectRatio: 0.65),
      itemCount: snapshot.data.documents.length,
      itemBuilder: (context, index) {
        ProductData data = ProductData.fromDocments(snapshot.data.documents[index]);
        data.category = this.snapshot.documentID;
        return ProductTile(
            "grid", data);
      },
    );
  }

  // Lista normal
  ListView buildListView(AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView.builder(
        padding: EdgeInsets.all(4.0),
        itemCount: snapshot.data.documents.length,
        itemBuilder: (context, index) {
          ProductData data = ProductData.fromDocments(snapshot.data.documents[index]);
          data.category = this.snapshot.documentID;
          return ProductTile(
              "list", data);
        });
  }

}
