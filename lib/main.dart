import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipeapp23/models.dart';
import 'package:webview_flutter/webview_flutter.dart';

main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
    theme: ThemeData.dark(),
  ));
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Model> list = <Model>[];
  String? text;
  final url = 
        'https://api.edamam.com/search?q=chicken&app_id=345706de&app_key=9bebb891a5739bc2806c6cc104fd4e75&from=0&to=100&calories=591-722&health=alcohol-free';

  getApiData() async {
    var response = await http.get(Uri.parse(url));
    Map json = jsonDecode(response.body);
    json['hits'].forEach((e){
      Model model = Model(
        url: e['recipe']['url'],
        image: e['recipe']['image'],
        source: e['recipe']['source'],
        label: e['recipe']['label']
      );
      setState(() {
        list.add(model);
      });
    });
  }

  @override 
  void initState() {

    super.initState();
    getApiData();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
          elevation: 8, 
          title: const Center( 
            child: 
              Text('RecipeApp')),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                onChanged: (v){
                  text = v;
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context)=> SearchPage(search: text,)));
                    }, 
                    icon: Icon(Icons.search),
                  ),
                  hintText: "Search for Recipe",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),  
                  fillColor: Colors.green.withOpacity(0.05),
                  filled: true),
              ),
              SizedBox(
                height: 15,
              ),
              GridView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                primary: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,  
                    mainAxisSpacing: 15), 
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => WebPage(
                            url: x.url,
                          )
                        )
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(x.image.toString())
                        ),
                        borderRadius: (
                            BorderRadius.circular(25)
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(3),
                            height: 40,
                            color: Colors.black.withOpacity(0.6),
                            child: Center(child: Text( x.label.toString())),
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            height: 25,
                            color: Colors.black.withOpacity(0.6),
                            child: Center(child: Text("Source: " + x.source.toString())),
                          ),
                        ])
                    ),
                  );
                })
            ],
          ),
        ),
      ),
    );
  }
}

class WebPage extends StatelessWidget {
  final url;
  WebPage({this.url});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: url ,
        ),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  String? search;

  SearchPage({this.search});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Model> list = <Model>[];
  String? text;

  getApiData(search) async {
    final url = 
    'https://api.edamam.com/search?q=$search&app_id=345706de&app_key=9bebb891a5739bc2806c6cc104fd4e75&from=0&to=100&calories=591-722&health=alcohol-free';
    
    var response = await http.get(Uri.parse(url));
    Map json = jsonDecode(response.body);
    json['hits'].forEach((e){
      Model model = Model(
        url: e['recipe']['url'],
        image: e['recipe']['image'],
        source: e['recipe']['source'],
        label: e['recipe']['label']
      );
      setState(() {
        list.add(model);
      });
    });
  }

  @override 
  void initState() {

    super.initState();
    getApiData(widget.search);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 8, title: Text('RecipeApp')),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GridView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                primary: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, 
                    crossAxisSpacing: 15, 
                    mainAxisSpacing: 15), 
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => WebPage(
                            url: x.url,
                          )
                        )
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(x.image.toString())
                        )
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(3),
                            height: 40,
                            color: Colors.black.withOpacity(0.5),
                            child: Center(child: Text( x.label.toString())),
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            height: 40,
                            color: Colors.black.withOpacity(0.5),
                            child: Center(child: Text("Source: " + x.source.toString())),
                          ),
                        ])
                    ),
                  );
                })
            ],
          ),
        ),
      ),
    );
  }
}