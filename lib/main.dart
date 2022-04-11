
import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'dart:convert';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({ Key? key }) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  
  Future<Map> getWeather (location) async {
    //get location ID
    var url = Uri.parse('https://www.metaweather.com/api/location/search/?query=$location');
    var response = await get(url);
    Map decodedResponse = jsonDecode(response.body).asMap();
    int locationID = decodedResponse[0]['woeid'];

    url = Uri.parse('https://www.metaweather.com/api/location/$locationID');
    response = await get(url);

    return jsonDecode(response.body)['consolidated_weather'][0];
  }
  
  String? location;
  Map? weather;
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather app',
      home: Scaffold (
        appBar: AppBar(
          title: const Text('Weather app'),
        ),
        floatingActionButton: FloatingActionButton (
          child: const Icon(Icons.check),
          onPressed: () async {
            weather = await getWeather(location);
            setState (() {
              weather;
            });
          }
        ),
        body: Center (
          child: Padding (
            padding: const EdgeInsets.all(50),
            child: Column (
              children: [
                TextField (
                  decoration: const InputDecoration(
                    helperText: 'Insert location',
                  ),
                  onChanged: (value) {
                    setState (() {
                      location = value;
                    });
                  }
                ),
                const SizedBox(height: 20),
                if (weather != null) Column (
                  children: [
                    ListTile(
                    	title: const Text('Weather'),
                    	trailing: Text(weather!['weather_state_name'])
                    ),
                    ListTile(
                    	title: const Text('Temperature (C)'),
                    	trailing: Text(weather!['the_temp'].toString())
                    ),
                    ListTile(
                    	title: const Text('Humidity (%)'),
                    	trailing: Text(weather!['humidity'].toString())
                    ),
                    ListTile(
                    	title: const Text('Air pressure (mbar)'),
                    	trailing: Text(weather!['air_pressure'].toString())
                    ),
                    ListTile(
                    	title: const Text('Wind speed (mph)'),
                    	trailing: Text(weather!['wind_speed'].toStringAsFixed(2))
                    ),
                  ]
                ),
                const Expanded(child: SizedBox()),
                const Text('Data provided by MetaWeather'),
              ]
            )
          )
        )
      ),
    );
  }
}
