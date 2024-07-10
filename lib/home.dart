import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:infinie/model_class.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isloading = true;
  ScrollController scrollController = ScrollController();
  List<Result> result = [];
  int offset = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    handlenext();
    _fetchdata(offset);
  }

  void handlenext() {
    scrollController.addListener(
      () async {
        if (scrollController.position.maxScrollExtent ==
            scrollController.position.pixels) {
          _fetchdata(offset);
        }
      },
    );
  }

  Future<void> _fetchdata(paraOffset) async {
    final dio = Dio();
    print(offset);
    try {
      var response = await dio.get(
          'https://pokeapi.co/api/v2/pokemon?offset=${paraOffset}&limit=20#');
      if (response.statusCode == 200) {
        print(response.data);
        print("success");

        ModelClass modelClass = ModelClass.fromJson(response.data);
        result += modelClass.results;
        int localOffset = offset + 15;

        setState(() {
          _isloading = false;
          offset = localOffset;
        });
      }
    } catch (e) {
      print("Error   $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("infinie page scroll"),
      ),
      body: ListView.builder(
        controller: scrollController,
        itemBuilder: (context, index) {
          return ListTile(
            tileColor: index % 2 == 0
                ? const Color.fromARGB(255, 210, 235, 232)
                : Colors.white,
            title: Text(
              result[index].name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(result[index].url),
          );
        },
        itemCount: result.length,
      ),
    );
  }
}
