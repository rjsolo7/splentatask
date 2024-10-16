import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/post_provider.dart';

import 'widgets/post_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PostProvider()),
      ],
      child: MaterialApp(
        title: 'Dynamic Form and Post List',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:const PostListScreen(),
      ),
    );
  }
}

