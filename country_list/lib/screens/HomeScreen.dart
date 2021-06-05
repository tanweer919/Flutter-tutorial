import 'package:flutter/material.dart';
import '../widgets/CountryList.dart';
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Country List')
      ),
      body: CountryList(),
    );
  }
}
