import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailFolderPage extends StatefulWidget {
  const DetailFolderPage({super.key});

  @override
  State<DetailFolderPage> createState() => DetailFolderPageState();
}

class DetailFolderPageState extends State<DetailFolderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Folder'),
      ),
      body: Container(
        child: Center(
          child: Text('Detail Folder Page'),
        ),
      ),
    );
  }
}
