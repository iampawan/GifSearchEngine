import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

class HackOnPage extends StatefulWidget {
  @override
  _HackOnPageState createState() => _HackOnPageState();
}

class _HackOnPageState extends State<HackOnPage> {
  final TextEditingController controller = TextEditingController();
  final String url =
      "https://api.giphy.com/v1/gifs/search?api_key=pe3ZWyViWslU9f87eJGnEdq3vg4gYkJ0&limit=25&offset=0&rating=G&lang=en&q=";
  var data;

  getData(String searchInput) async {
    var res = await http.get(url + searchInput);
    data = jsonDecode(res.body)["data"];
    setState(() {});
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Vx.gray800,
      body: Theme(
        data: ThemeData.dark(),
        child: Column(
          children: [
            "Gify App".text.white.xl4.make().objectCenter(),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Search here",
                    ),
                  ),
                ),
                30.widthBox,
                RaisedButton(
                  onPressed: () {
                    getData(controller.text);
                  },
                  shape: Vx.roundedSm,
                  child: Text("Go"),
                ).h8(context)
              ],
            ).p8(),
            VxConditional(
              condition: data != null,
              builder: (context) => GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: context.isMobile ? 2 : 3,
                ),
                itemBuilder: (context, index) {
                  final url =
                      data[index]["images"]["fixed_height"]["url"].toString();
                  return Image.network(
                    url,
                    fit: BoxFit.cover,
                  ).card.roundedSM.make();
                },
                itemCount: data.length,
              ),
              fallback: (context) => "Nothing found".text.gray500.xl3.make(),
            ).h(context.percentHeight * 70)
          ],
        ).p16(),
      ),
    );
  }
}
