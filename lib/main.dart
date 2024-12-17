import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather',
      
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final TextEditingController _cityController = TextEditingController();
  String _weatherInfo = '';
  String _currentCity = '';

  Future<void> fetchWeather(String city) async {
    final apiKey = '9df91d0ded0314055be3399b3f92482b'; // Replace with your OpenWeatherMap API key
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _currentCity = city; // Save the city for refresh
          _weatherInfo =
          'City: ${data['name']}\nTemperature: ${data['main']['temp']}°C\nWeather: ${data['weather'][0]['description']}';
        });
      } else {
        setState(() {
          _weatherInfo = 'City not found!';
        });
      }
    } catch (e) {
      setState(() {
        _weatherInfo = 'Error fetching weather data.';
      });
    }
  }

  Future<void> _refreshWeather() async {
    if (_currentCity.isNotEmpty) {
      await fetchWeather(_currentCity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather'),
      actions: [
        Icon(Icons.location_on_rounded,color: Colors.green,)
      ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
         decoration: BoxDecoration(
           image: DecorationImage(
             image: AssetImage('assets/background.png'), // Path to the image asset
             fit: BoxFit.cover, // Fit the image to cover the container
           ),
         ),
        child: RefreshIndicator(
          onRefresh: _refreshWeather,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                TextField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    labelText: 'Enter City Name',
                    labelStyle: TextStyle(color: Colors.black), // Black label color
                    filled: true, // Enables background color
                    fillColor: Colors.white, // White background color
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final city = _cityController.text;
                    if (city.isNotEmpty) {
                      fetchWeather(city);
                    }
                  },
                  child: Text('Get Weather'),
                ),
                SizedBox(height: 20),
                Text(
                  _weatherInfo,

                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18,color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
