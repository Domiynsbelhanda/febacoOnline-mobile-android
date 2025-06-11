import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _About();
  }
}

class _About extends State<AboutScreen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(child: Text('Oklm'),),
    );
  }
}