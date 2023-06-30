import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traveler/models/destination.model.dart';
import 'package:traveler/models/Url.Dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedButton = '';
  String selectedCategory = 'random';
  String isFavorite = '0';

  Future<void> addToFavorite(DestinationModel destination) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? id = prefs.getString('id');
    print(id);
    final response = await http.post(
      Uri.parse(API_URL + 'favorite'),
      body: {
        'email': email,
        'id': destination.id.toString(),
      },
    );
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['status'] == true) {
      String isFavorite = jsonResponse['id_fav'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(jsonResponse['message']),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        destination.id_fav = isFavorite.toString();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(jsonResponse['message']),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  Future<void> removeFromFavorite(DestinationModel destination) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    final response = await http.post(
      Uri.parse(API_URL + 'favorite/delete'),
      body: {
        'email': email,
        'id': destination.id.toString(),
      },
    );

    var jsonResponse = json.decode(response.body);
    if (jsonResponse['status'] == true) {
      bool isFavorite = jsonResponse['id_fav'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(jsonResponse['message']),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        destination.id_fav = isFavorite.toString();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(jsonResponse['message']),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<List<DestinationModel>> _recommendedRandom() async {
    final response = await http.get(
      Uri.parse(API_URL + 'destination/' + selectedCategory + '4'),
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

  Future<List<DestinationModel>> _popular() async {
    final response = await http.get(
      Uri.parse(API_URL + 'destination/' + selectedCategory + '6'),
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 40, left: 20, right: 20),
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                            "LOCATION",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.grey[900],
                            ),
                            Text(
                              "Penajam, Indonesia",
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[900],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.notifications_rounded,
                          color: Colors.grey[900],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Search Destination",
                    hintStyle: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[900],
                    ),
                    suffixIcon: IconButton(
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {},
                      icon: Icon(
                        Icons.search,
                        color: Colors.grey[400],
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedButton = 'Beach';
                          selectedCategory = 'beach';
                        });
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: selectedButton == 'Beach'
                                      ? Colors.grey.shade600
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey[200],
                                child: Image(
                                  image: AssetImage('images/icons/beach.png'),
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Beach",
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: selectedButton == 'Beach'
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: Colors.grey[900],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedButton = 'Mountain';
                          selectedCategory = 'mountain';
                        });
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: selectedButton == 'Mountain'
                                      ? Colors.grey.shade600
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey[200],
                                child: Image(
                                  image:
                                      AssetImage('images/icons/mountain.png'),
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Mountain",
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: selectedButton == 'Mountain'
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: Colors.grey[900],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedButton = 'Monument';
                          selectedCategory = 'monument';
                        });
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: selectedButton == 'Monument'
                                      ? Colors.grey.shade600
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey[200],
                                child: Image(
                                  image:
                                      AssetImage('images/icons/monument.png'),
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Monument",
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: selectedButton == 'Monument'
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: Colors.grey[900],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recommended For You",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[900],
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/all_1');
                        },
                        child: Text("See All")),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                // ==================
                StreamBuilder(
                    stream: _recommendedRandom().asStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        );
                      } else if (snapshot.data == null) {
                        return Center(
                          child: Text("No Data"),
                        );
                      } else {
                        var data = snapshot.data;
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                              child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: data!.map((e) {
                              return Card(
                                  margin: EdgeInsets.only(
                                      right: 25.0, bottom: 10.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Container(
                                    width: 193,
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () => Navigator.pushNamed(
                                              context, '/detail',
                                              arguments: e),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(10.0),
                                                  topRight:
                                                      Radius.circular(10.0)),
                                              image: DecorationImage(
                                                  image: NetworkImage(API_URL +
                                                      'assets/thumb/' +
                                                      e.thumb!),
                                                  fit: BoxFit.cover),
                                            ),
                                            height: 120.0,
                                            width: double.infinity,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => Navigator.pushNamed(
                                              context, '/detail',
                                              arguments: e),
                                          child: Container(
                                              margin:
                                                  EdgeInsets.only(top: 10.0),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16.0),
                                              alignment: Alignment.centerLeft,
                                              child: Row(children: [
                                                Text(
                                                  e.name!,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey[900],
                                                  ),
                                                ),
                                              ])),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(bottom: 20.0),
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
                                                e.city! + "," + e.country!,
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
                                                    e.price! +
                                                    "k / person",
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey[900],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  if (e.id_fav == '0') {
                                                    addToFavorite(e);
                                                  } else {
                                                    removeFromFavorite(e);
                                                  }
                                                },
                                                child: CircleAvatar(
                                                  radius: 15,
                                                  backgroundColor:
                                                      Colors.grey[200],
                                                  child: Icon(
                                                    e.id_fav == '0'
                                                        ? Icons
                                                            .favorite_border_outlined
                                                        : Icons.favorite,
                                                    color: Colors.red,
                                                    size: 15,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                            }).toList(),
                          )),
                        );
                      }
                    }),
                // ==================
                SizedBox(
                  height: 35,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Popular For Me",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[900],
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/all_2');
                        },
                        child: Text("See All")),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                StreamBuilder(
                    stream: _popular().asStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        );
                      } else if (snapshot.data == null) {
                        return Center(
                          child: Text("No Data"),
                        );
                      } else {
                        var data = snapshot.data;
                        return Column(
                          children: data!.map((e) {
                            return Card(
                                margin: EdgeInsets.only(
                                    bottom: 20.0, right: 1.0, left: 1.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 4.0,
                                child: Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () => Navigator.pushNamed(
                                            context, '/detail',
                                            arguments: e),
                                        child: Container(
                                          width: 150,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                bottomLeft:
                                                    Radius.circular(10.0)),
                                            image: DecorationImage(
                                                image: NetworkImage(API_URL +
                                                    'assets/thumb/' +
                                                    e.thumb!),
                                                fit: BoxFit.cover),
                                          ),
                                          height: 150.0,
                                        ),
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
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.pushNamed(
                                                              context,
                                                              '/detail',
                                                              arguments: e);
                                                        },
                                                        child: Container(
                                                          width: 150,
                                                          child: Text(
                                                            e.name!,
                                                            style: GoogleFonts
                                                                .inter(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Colors
                                                                  .grey[900],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ])),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 16.0),
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
                                                    e.city! + "," + e.country!,
                                                    style: GoogleFonts.inter(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.grey[900],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16.0),
                                              child: Text(
                                                "Rp. " +
                                                    e.price! +
                                                    "k / person",
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
                          }).toList(),
                        );
                      }
                    }),
                // ==================
                //
              ],
            ),
          ),
        ),
      ),
    );
  }
}
