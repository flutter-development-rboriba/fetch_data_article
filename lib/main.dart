import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:fetch_data_article/model.dart';

void main() {
  runApp(MaterialApp(home: JsonApiPhp()));
}

class JsonApiPhp extends StatefulWidget {
  @override
  _JsonApiPhpState createState() => _JsonApiPhpState();
}

class _JsonApiPhpState extends State<JsonApiPhp> {
  bool loading = true;
  final String url = 'https://jsonplaceholder.typicode.com/users';
  var client = http.Client();
  List<Users> users = [];

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    http.Response response = await client.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Connection Ok
      List responseJson = json.decode(response.body);
      responseJson.map((m) => users.add(new Users.fromJson(m))).toList();
      setState(() {
        loading = false;
      });
    } else {
      throw ('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: loading
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {
                    var address = users[index].address!.geo!.lat;
                    return Card(
                      child: ListTile(
                        title: Text(address!),
                      ),
                    );
                  },
                )),
    );
  }
}
