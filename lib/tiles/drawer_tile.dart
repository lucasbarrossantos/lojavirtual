import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final PageController pageController;
  final int page;

  const DrawerTile(this.icon, this.text, this.pageController, this.page);

  @override
  Widget build(BuildContext context) {
    // return Material(); para dar um efeito visual
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          pageController.jumpToPage(this.page);
        },
        child: Container(
          height: 60.0,
          child: Row(
            children: <Widget>[
              Icon(this.icon,
                  size: 32.0,
                  color: pageController.page.round() == page
                      ? Theme.of(context).primaryColor
                      : Colors.grey[700]),
              SizedBox(width: 32.0),
              Text(this.text,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: pageController.page.round() == page
                          ? Theme.of(context).primaryColor
                          : Colors.grey[700]))
            ],
          ),
        ),
      ),
    );
  }
}
