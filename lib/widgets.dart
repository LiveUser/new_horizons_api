import 'package:flutter/material.dart';

AppBar appBar(){
  return AppBar(
    centerTitle: true,
    title: Image.asset(
      "images/logo.png",
      width: 100,
    ),
    backgroundColor: Colors.black,
  );
}
class SimpleButton extends StatelessWidget {
  const new({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });
  final IconData icon;
  final String text;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTap();
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        color: Colors.black,
        child: Row(
          spacing: 10,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}