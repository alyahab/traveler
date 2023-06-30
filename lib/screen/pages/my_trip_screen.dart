import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traveler/models/destination.model.dart';
import 'package:traveler/models/Url.Dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class MyTripPage extends StatefulWidget {
  const MyTripPage({Key? key}) : super(key: key);

  @override
  State<MyTripPage> createState() => _MyTripPageState();
}

class _MyTripPageState extends State<MyTripPage> {
  Future<List<DestinationModel>> _listFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    final response = await http.get(
      Uri.parse(API_URL + 'booked?email=' + email!),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.only(top: 40, left: 20, right: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Booked",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[900],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          // ==================
          // Card Image at left, and text at right
          StreamBuilder(
              stream: _listFavorite().asStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data as List<DestinationModel>;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Card(
                          margin: EdgeInsets.only(
                              bottom: 20.0, right: 1.0, left: 1.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 4.0,
                          child: Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0)),
                                    image: DecorationImage(
                                        image: NetworkImage(API_URL +
                                            'assets/thumb/' +
                                            data[index].thumb.toString()),
                                        fit: BoxFit.cover),
                                  ),
                                  height: 150.0,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.only(
                                              top: 16.0,
                                              left: 16.0,
                                              right: 16.0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: 150,
                                                  child: Text(
                                                    data[index].name.toString(),
                                                    style: GoogleFonts.inter(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.grey[900],
                                                    ),
                                                  ),
                                                ),
                                              ])),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 16.0),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              color: Colors.grey[900],
                                              size: 12,
                                            ),
                                            Text(
                                              data[index].city.toString() +
                                                  ", " +
                                                  data[index]
                                                      .country
                                                      .toString(),
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey[900],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Text( "Rp. " +
                                          data[index].price.toString() +
                                              "K / person",
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
                              ],
                            ),
                          ));
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("");
                } else {
                  return Center(
                  );
                }
              })
          // ==================
          //
        ]),
      ),
    ));
  }
}
