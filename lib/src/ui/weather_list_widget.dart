import 'dart:ui';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../models/weather_forecast.dart';

class WeatherListWidget extends StatelessWidget {
  final List<WeatherForecast> forecastsList;

  const WeatherListWidget({Key? key, required this.forecastsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textSize = width * 0.05;

    final splitIndex = (forecastsList.length / 2).ceil();
    final firstRow = forecastsList.sublist(0, splitIndex);
    final secondRow = forecastsList.sublist(splitIndex);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        color: brown.withOpacity(0.1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            width: width,
            height: height * 0.17,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildForecastRow(context, firstRow, textSize),
                Divider(
                  color: basewhite.withOpacity(0.3),
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                _buildForecastRow(context, secondRow, textSize),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForecastRow(BuildContext context, List<WeatherForecast> forecasts, double textSize) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: forecasts.map((forecast) {
          return Container(
            width: MediaQuery.of(context).size.width / 6.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  forecast.time,
                  style: TextStyle(color: basewhite, fontSize: textSize - 8, fontFamily: 'Poppins'),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.001),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/WeatherAssets/cloud.png", scale: 2,),
                    SizedBox(width: 3,),
                    Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.top,
                            child: SizedBox(
                              height: 16.0,
                              child: Text(
                                forecast.temperature.toStringAsFixed(0),
                                style: TextStyle(fontSize: textSize - 8, color: basewhite, fontFamily: 'Poppins'),
                              ),
                            ),
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.top,
                            child: SizedBox(
                              height: 20.0,
                              child: Text(
                                "\u00B0",
                                style: TextStyle(fontSize: textSize - 8, color: basewhite, fontFamily: 'Poppins'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
