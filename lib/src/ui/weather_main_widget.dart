import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../blocs/weather_bloc.dart';
import '../ui/weather_list_widget.dart';
import 'weather_location_details_widget.dart';

class WeatherMainWidget extends StatelessWidget {
  final WeatherLoaded state;

  const WeatherMainWidget({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textSize = width * 0.05;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          WeatherLocationWidget(state: state),
          SizedBox(height: height * 0.04),
          WeatherListWidget(forecastsList: state.forecasts),
          SizedBox(height: height * 0.05),
          weatherDetailsWidget(context),
        ],
      ),
    );
  }

Widget  weatherDetailsWidget(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  final textSize = width * 0.05;
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Random Text",
            style: TextStyle(
              fontSize: textSize,
              fontWeight: FontWeight.w600,
              color: basewhite,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        Text(
          "Improve him believe opinion offered met and end cheered forbade. "
              "Friendly as stronger speedily by recurred. "
              "Son interest wandered sir addition end say. "
              "Manners beloved affixedpicture men ask.",
          style: TextStyle(
            fontSize: textSize - 7,
            fontWeight: FontWeight.w400,
            color: basewhite,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}
