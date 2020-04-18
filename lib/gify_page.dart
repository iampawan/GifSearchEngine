import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

class GifyPage extends StatefulWidget {
  @override
  _GifyPageState createState() => _GifyPageState();
}

class _GifyPageState extends State<GifyPage> {
  final url =
      "https://api.giphy.com/v1/gifs/search?api_key=pe3ZWyViWslU9f87eJGnEdq3vg4gYkJ0&limit=25&offset=0&rating=G&lang=en&q=";

  final TextEditingController controller = TextEditingController();
  bool showLoading = false;
  var data;

  @override
  void initState() {
    super.initState();
  }

  getData(String searchText) async {
    showLoading = true;
    setState(() {});
    final res = await http.get(url + searchText);
    data = jsonDecode(res.body)["data"];
    setState(() {
      showLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Vx.gray800,
        body: Theme(
          data: ThemeData.dark(),
          child: VStack([
            "Gify App".text.white.xl4.make().objectCenter(),
            [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Search here"),
                ),
              ),
              30.widthBox,
              RaisedButton(
                onPressed: () {
                  getData(controller.text);
                },
                child: "Go".text.make(),
                shape: Vx.roundedSm,
              ).h8(context)
            ]
                .hStack(
                    axisSize: MainAxisSize.max,
                    crossAlignment: CrossAxisAlignment.center)
                .p24(),
            if (showLoading)
              CircularProgressIndicator().centered()
            else
              VxConditional(
                condition: data != null,
                builder: (context) => GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: context.isMobile ? 2 : 3),
                  itemBuilder: (context, index) {
                    final imgUrl =
                        data[index]["images"]["fixed_height"]["url"].toString();

                    return ZStack(
                      [
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Image.network(
                            imgUrl,
                            fit: BoxFit.cover,
                            color: Colors.black.withOpacity(0.8),
                            colorBlendMode: BlendMode.darken,
                          ),
                        ),
                        Image.network(
                          imgUrl,
                          fit: BoxFit.contain,
                        )
                      ],
                      fit: StackFit.expand,
                    ).card.roundedSM.make().p4();
                  },
                  itemCount: data.length,
                ),
                fallback: (context) =>
                    "Nothing found".text.gray500.xl3.makeCentered(),
              ).h(context.percentHeight * 70)
          ]).p16().scrollVertical(physics: NeverScrollableScrollPhysics()),
        ));
  }
}
