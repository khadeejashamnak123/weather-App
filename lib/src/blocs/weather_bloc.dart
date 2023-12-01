import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/weather_forecast.dart';

class WeatherEvent {}

class GetWeather extends WeatherEvent {}

class WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final String location;
  final double temperature;
  final String city;
  final String weather;
  final String formattedDate;
  final double feelsLike;
  final String sunsetTime;
  final List<WeatherForecast> forecasts;

  WeatherLoaded({
    required this.location,
    required this.temperature,
    required this.city,
    required this.weather,
    required this.feelsLike,
    required this.formattedDate,
    required this.sunsetTime,
    required this.forecasts,
  });
}

class WeatherError extends WeatherState {
  final String message;

  WeatherError({required this.message});
}

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherLoading()) {
    on<GetWeather>(_onGetWeather);
  }

  Future<void> _onGetWeather(GetWeather event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    try {
      Position position = await _getCurrentPosition();
      String apiKey = _getApiKey();
      final response = await _fetchWeatherData(position, apiKey);

      if (response.statusCode == 200) {
        _processWeatherData(response.body, position, emit);
      } else {
        emit(WeatherError(message: 'Failed to get weather data. Status code: ${response.statusCode}'));
      }
    } catch (e) {
      emit(WeatherError(message: 'Failed to get weather data. Error: $e'));
    }
  }

  Future<Position> _getCurrentPosition() async {
    LocationPermission permission = await Geolocator.requestPermission();
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  String _getApiKey() {
    // Fetch API key from a secure location (e.g., environment variable or config file)
    return 'fd81889eb96cec1800f5dd85addd5174';
  }

  Future<http.Response> _fetchWeatherData(Position position, String apiKey) {
    return http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey',
      ),
    );
  }

  void _processWeatherData(String responseBody, Position position, Emitter<WeatherState> emit) {
    final Map<String, dynamic> data = json.decode(responseBody);
    final List<dynamic> forecasts = data['list'];
    List<dynamic> forecastList = data['list'];
    final String dateString = forecasts[0]['dt_txt'];
    final DateTime dateTime = DateTime.parse(dateString);
    final String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
    final double currentTemperature = forecasts[0]['main']['temp'].toDouble();
    final String city = data['city']['name'];
    final String weather = forecastList[0]['weather'][0]['description'];
    final double feelsLike = forecasts[0]['main']['feels_like'].toDouble();
    int sunsetTimestamp = data['city']['sunset'];
    DateTime sunsetDateTime = DateTime.fromMillisecondsSinceEpoch(sunsetTimestamp * 1000).toLocal();
    String formattedSunsetTime = DateFormat('HH:mm').format(sunsetDateTime);

    DateTime currentDate = DateTime.now();
    String currentDay = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
    DateTime nextDay = currentDate.add(const Duration(days: 1));
    String nextDayDate = "${nextDay.year}-${nextDay.month.toString().padLeft(2, '0')}-${nextDay.day.toString().padLeft(2, '0')}";

    List<WeatherForecast> forecastsList = forecasts.where((item) {
      DateTime dateTime = DateTime.parse(item['dt_txt']);
      bool isCurrentDate = dateTime.isAtSameMomentAs(DateTime.now());
      bool isTargetDate = item['dt_txt'].toString().contains(currentDay) || item['dt_txt'].toString().contains(nextDayDate);
      return isCurrentDate || isTargetDate;
    }).map((item) {
      DateTime dateTime = DateTime.parse(item['dt_txt']);
      bool isCurrentDate = dateTime.isAtSameMomentAs(DateTime.now());
      String formattedTime = isCurrentDate ? 'Now' : _getFormattedTime(dateTime);
      return WeatherForecast(
        time: formattedTime,
        temperature: (item['main']['temp'] - 273.15),
      );
    }).toList();

    emit(WeatherLoaded(
      location: position.toString(),
      temperature: currentTemperature,
      city: city,
      weather: weather,
      formattedDate: formattedDate,
      feelsLike: feelsLike,
      sunsetTime: formattedSunsetTime,
      forecasts: forecastsList,
    ));
  }

  String _getFormattedTime(DateTime dateTime) {
    String period = ' AM';
    int hour = dateTime.hour;

    if (hour >= 12) {
      period = ' PM';
      if (hour > 12) {
        hour -= 12;
      }
    } else if (hour == 0) {
      hour = 12;
      period = ' AM';
    }

    return '$hour$period';
  }
}
