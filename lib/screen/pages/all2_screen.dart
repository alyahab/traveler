import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traveler/models/destination.model.dart';
import 'package:traveler/models/Url.Dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllPage2 extends StatelessWidget {
  const AllPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<List<DestinationModel>> _recommendedRandom() async {
      final response = await http.get(
        Uri.parse(API_URL + 'destination/randomAll'),
      );
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var data = jsonResponse['data'] as List;
        List<DestinationModel> destination =
            data.map((e) => DestinationModel.fromJson(e)).toList();
        return destination;
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: Text(
            "Popular",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
            padding: EdgeInsets.only(top: 10.0),
            margin: EdgeInsets.only(left: 20, right: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: StreamBuilder(
                  stream: _recommendedRandom().asStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data as List<DestinationModel>;
                      return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: GridView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.8,
                                    crossAxisSpacing: 10),
                            children: data.map((e) {
                              return Card(
                                  margin: EdgeInsets.only(bottom: 10.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 4.0,
                                  child: Container(
                                    width: 200,
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                topRight:
                                                    Radius.circular(10.0)),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                  API_URL +
                                                      'assets/thumb/' +
                                                      e.thumb.toString(),
                                                ),
                                                fit: BoxFit.cover),
                                          ),
                                          height: 120.0,
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(top: 10.0),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            alignment: Alignment.centerLeft,
                                            child: Row(children: [
                                              Container(
                                                width: 143,
                                                child: Text(
                                                  e.name.toString(),
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey[900],
                                                  ),
                                                ),
                                              ),
                                            ])),
                                        Container(
                                          margin: EdgeInsets.only(bottom: 7.7),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                color: Colors.grey[900],
                                                size: 12,
                                              ),
                                              Container(
                                                child: Text(
                                                  // City, Country
                                                  e.city.toString() +
                                                      "," +
                                                      e.country.toString(),
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey[900],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(bottom: 10.0),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Rp. " +
                                                    e.price.toString() +
                                                    "k / person",
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey[900],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {},
                                                child: Icon(
                                                    Icons.favorite_border,
                                                    size: 16,
                                                    color: Colors.grey[900]),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                            }).toList(),
                          ));
                    } else if (snapshot.hasError) {
                      return Text("");
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            )));
  }
}
