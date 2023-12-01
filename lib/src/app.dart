import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project/src/ui/weather_main_widget.dart';
import 'blocs/weather_bloc.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<WeatherBloc>(context).add(GetWeather());
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var width = queryData.size.width;
    var height = queryData.size.height;
    double textSize = width * 0.05;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/WeatherAssets/background_img.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 34, right: 34, top: 53),
          child: BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if (state is WeatherLoading) {
                return const Center(
                    child: SizedBox(
                        height: 60,
                        width: 60,
                        child: CircularProgressIndicator()));
              } else if (state is WeatherLoaded) {
                return WeatherMainWidget(
                  state: state,
                );
              } else if (state is WeatherError) {
                return Text('Error: ${state.message}');
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
