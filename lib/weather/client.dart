import 'dart:core';
import 'dart:async';
import 'package:http/http.dart';
import './response.dart';

class WeatherApi {
  String host = 'api.openweathermap.org';
  String apiKey = 'a01a2c84df7b627b40735481c924f605';

  Future<WeatherApiResponse> getWeatherByCity(String cityName) async {
    var cityCode = 0;
    var countryCode = 7;
    var queryParameters = {
      'q': '$cityName,$cityCode,$countryCode',
      'appid': apiKey
    };
    var uri = Uri.http(host, '/data/2.5/forecast', queryParameters);
    final response = await get(uri);

    String jsonString = response.body;
    final weatherApiResponse = weatherApiResponseFromJson(jsonString);
    return weatherApiResponse;
  }
}
