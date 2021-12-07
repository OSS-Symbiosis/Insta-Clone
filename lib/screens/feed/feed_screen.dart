import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  static const String routeName = '/feed';
  const FeedScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => Scaffold(
                      appBar: AppBar(
                        title: Text(
                          'hello!',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ))),
            child: Text('Feed')),
      ),
    );
  }
}
