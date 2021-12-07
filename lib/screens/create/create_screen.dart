import 'package:flutter/material.dart';

class CreatePostScreen extends StatelessWidget {
  static const String routeName = '/create';
  const CreatePostScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Create'),
      ),
    );
  }
}
