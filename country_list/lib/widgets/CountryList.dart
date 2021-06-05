import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:math';
import '../models/Country.dart';

class CountryList extends StatefulWidget {
  @override
  _CountryListState createState() => _CountryListState();
}

class _CountryListState extends State<CountryList> {
  Future<List<Country>> _fetchedCountries;

  Future<List<Country>> fetchCountries() async {
    //Create an instance of Dio class
    final Dio dio = Dio();
    //Empty countries list
    List<Country> countries = [];
    try {
      //Perform a get request on the given url
      final response = await dio.get("https://api.first.org/data/v1/countries");

      if (response.statusCode == 200) {
        //If status code is 200
        //Extract data property containing countries detail from response json.
        final Map<String, dynamic> data = response.data["data"];
        //Loop through all the keys in the data map
        for (MapEntry entry in data.entries) {
          //Create Country model from each entry in the map and add to it countries list
          countries
              .add(Country.fromJson(countryCode: entry.key, data: entry.value));
        }
      }
      return countries;
    } on DioError catch (e) {
      //On fetch error raise an exception
      throw Exception('Failed to fetch country data');
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _fetchedCountries = fetchCountries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchedCountries,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: TextStyle(fontSize: 18),
              ),
            );
          }
          if (snapshot.hasData) {
            List<Country> countries = snapshot.data;
            return countryListView(countries: countries);
          }
        }
      },
    );
  }

  Widget countryListView({List<Country> countries}) {
    return ListView.builder(
      itemCount: countries.length,
      itemBuilder: (BuildContext context, int index) {
        Country country = countries[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            height: 70,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Color(
                      (Random().nextDouble() * 0xFFFFFF).toInt(),
                    ).withOpacity(1.0),
                    child: Text(
                      country.code,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              country.name,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Text(
                            country.region,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0Xff3366ff),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
