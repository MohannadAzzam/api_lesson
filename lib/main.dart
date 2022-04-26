import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


   getPhones() async {
    // var url = Uri.parse('https://picsum.photos/v2/list');
    var url = Uri.parse('https://dummyjson.com/products/');

    var response = await http.get(url);

    var resopnseBody = jsonDecode(response.body);

    return resopnseBody;
  }

  postPhones() async {
     var url = Uri.parse('https://dummyjson.com/products/add');

     var response = await http.post(url, body: {
       "id": 31,
       "title": "iPhone 9",
       "description": "An apple mobile which is nothing like apple",
       "price": 549,
       "discountPercentage": 12.96,
       "rating": 4.69,
       "stock": 94,
       "brand": "Apple",
       "category": "smartphones",
       "thumbnail": "https://dummyjson.com/image/i/products/1/thumbnail.jpg",
       "images": [
         "https://dummyjson.com/image/i/products/1/1.jpg",
         "https://dummyjson.com/image/i/products/1/2.jpg",
         "https://dummyjson.com/image/i/products/1/3.jpg",
         "https://dummyjson.com/image/i/products/1/4.jpg",
         "https://dummyjson.com/image/i/products/1/thumbnail.jpg"
       ]
     });

     var responseBody = jsonDecode(response.body);

     print(responseBody);

     return responseBody;
  }

  initState(){
     postPhones();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: postPhones, child: Icon(Icons.add),),
      appBar: AppBar(
        title: Text('Api'),
      ),
      body: FutureBuilder(
          future: getPhones(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                separatorBuilder: (context,i){
                  return Divider();
                },
                physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data['products'].length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      isThreeLine: true,
                      title: Text('${snapshot.data['products'][i]['title']}'),
                      // title: Text(' ${snapshot.data[i]['author']}'),
                      subtitle: Text('${snapshot.data['products'][i]['description']}'),
                      leading:
                        Container(height: 50, width: 50, child: Image.network(
                          '${snapshot.data['products'][i]['thumbnail']}',
                          fit: BoxFit.cover,
                        ),),
                      // Container(height: 50, width: 50, child: Image.network(
                      //     '${snapshot.data[i]['download_url']}',
                      //     fit: BoxFit.cover,
                      //   ),),
                      trailing: Text('${snapshot.data['products'][i]['price']}\$') ,
                    );
                  });
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
