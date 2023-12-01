import 'dart:ui';

import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../blocs/weather_bloc.dart';

class WeatherLocationWidget extends StatelessWidget {
  final WeatherLoaded state;

  const WeatherLocationWidget({Key? key, required this.state}) : super(key: key);

  int kelvinToCelsius(double kelvin) => (kelvin - 273.15).toInt();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textSize = width * 0.05;

    final currentTemperatureCelsius = kelvinToCelsius(state.temperature);
    final feelsLikeInCelsius = kelvinToCelsius(state.feelsLike);

    return Container(
      width: width / 1,
      decoration: BoxDecoration(
        color: brown,
        borderRadius: const BorderRadius.all(Radius.circular(35)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Today",
                    style: TextStyle(
                      fontSize: textSize,
                      fontWeight: FontWeight.w500,
                      color: peach,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(width: width * 0.02),
                  Icon(
                    Icons.keyboard_arrow_down_sharp,
                    color: peach,
                    size: textSize,
                  ),
                ],
              ),
              SizedBox(height: height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/WeatherAssets/Vector.png",
                    width: width / 4,
                    height: 72,
                  ),
                  SizedBox(width: 10),
                  Text.rich(
                    TextSpan(
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.top,
                          child: SizedBox(
                            height: 110.0,
                            child: Text(
                              currentTemperatureCelsius.toString(),
                              style: TextStyle(
                                fontSize: textSize + 60,
                                fontWeight: FontWeight.w600,
                                color: peach,
                                fontFamily: 'Poppins',
                                fontFeatures: const <FontFeature>[FontFeature.superscripts()],
                              ),
                            ),
                          ),
                        ),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.top,
                          child: SizedBox(
                            height: 72.0,
                            child: Text(
                              "\u00B0",
                              style: TextStyle(
                                fontSize: textSize + 8,
                                fontWeight: FontWeight.w500,
                                color: peach,
                                fontFamily: 'Poppins',
                                fontFeatures: const <FontFeature>[FontFeature.superscripts()],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.01),
              Text(
                state.weather,
                style: TextStyle(
                  fontSize: textSize - 2,
                  fontWeight: FontWeight.w600,
                  color: peach,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: height * 0.015),
              Text(
                state.city,
                style: TextStyle(
                  fontSize: textSize - 7,
                  fontWeight: FontWeight.w500,
                  color: peach,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 15),
              Text(
                state.formattedDate,
                style: TextStyle(
                  fontSize: textSize - 7,
                  fontWeight: FontWeight.w500,
                  color: peach,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 15),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Feels like $feelsLikeInCelsius",
                      style: TextStyle(
                        fontSize: textSize - 7,
                        fontWeight: FontWeight.w400,
                        color: peach,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    VerticalDivider(
                      color: peach,
                      thickness: 0.5,
                      indent: 4,
                      endIndent: 4,
                    ),
                    Text(
                      "Sunset ${state.sunsetTime}",
                      style: TextStyle(
                        fontSize: textSize - 7,
                        fontWeight: FontWeight.w400,
                        color: peach,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
