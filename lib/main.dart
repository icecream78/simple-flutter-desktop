import 'package:desktop_app_sample/weather/response.dart';
import 'package:flutter/material.dart';
import './weather/client.dart';
import './chart.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App by Fa[K]eR?!',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Weather App by Fa[K]eR?!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final citySearchController = TextEditingController();
  String iconUrl = 'https://picsum.photos/250?image=9';
  double currentTemperature = 0;
  double himidity = 0;
  double windSpeed = 0;
  double pressure = 0;
  List<TempToHour> chartData = List();

  void searchCity() async {
    final cityName = citySearchController.text;
    WeatherApi client = new WeatherApi();
    WeatherApiResponse weather = await client.getWeatherByCity(cityName);

    setState(() {
      var tmp = weather.list
          .sublist(0, 8)
          .map((e) => TempToHour(e.dtTxt.hour, (e.main.temp - 273.15).toInt()))
          .toList();
      tmp.sort((a, b) => a.hour.compareTo(b.hour));

      chartData = tmp;
      final weatherIcondID = weather.list[0].weather[0].icon;
      iconUrl = 'http://openweathermap.org/img/wn/$weatherIcondID@2x.png';

      himidity = weather.list[0].main.humidity.toDouble();
      windSpeed = weather.list[0].wind.speed;
      pressure = weather.list[0].main.pressure.toDouble();
      currentTemperature = (weather.list[0].main.temp - 273.15);
    });
  }

  @override
  void dispose() {
    citySearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            TextField(
              controller: citySearchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                labelText: 'Название города',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: searchCity,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(5)),
            Row(
              children: [
                Row(
                  children: [
                    Image.network(
                      iconUrl,
                      width: 120,
                      height: 120,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Text(
                      // TODO: split this part into separate block with different styles
                      // '12 °C | °F',
                      '${currentTemperature.toStringAsFixed(2)} °C | °F',
                      style: TextStyle(fontSize: 30),
                    )
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    Text('Давление: ${pressure.toStringAsFixed(2)} Па'),
                    Text('Влажность: ${himidity.toStringAsFixed(2)} %'),
                    Text('Ветер: ${windSpeed.toStringAsFixed(2)} м/с'),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
            Container(
              child: new TempToHourChart(
                // TempToHourChart.convertToLiniarData([
                //   TempToHour(0, 3),
                //   TempToHour(12, 12),
                //   TempToHour(15, 13),
                //   TempToHour(18, 13),
                //   TempToHour(21, 7),
                // ]),
                TempToHourChart.convertToLiniarData(chartData),
                animate: true,
              ),
              width: 500,
              height: 500,
            ),
          ],
        ),
      ),
    );
  }
}
