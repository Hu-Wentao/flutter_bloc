import 'package:flutter/material.dart';

void main()=>runApp(MaterialApp(
  title: "my demo",
  theme: ThemeData(primarySwatch: Colors.lightBlue),
  home: HomePage(),
));

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("demo"),),
      body: Center(
        child: Text(""),
      ),
    );
  }
}

abstract class BaseBloc{
  void dispose();
}

class CountPage extends StatefulWidget{
  @override
  createState()=> _CountPageState();
}

class _CountPageState extends State<CountPage> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
//    return ;
  }
}
class BlocProvider