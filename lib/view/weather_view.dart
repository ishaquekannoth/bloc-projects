import 'package:blocprojects/settings/setting_page.dart';
import 'package:blocprojects/theme/cubit/theme_cubit.dart';
import 'package:blocprojects/weather/cubit/weather_cubit.dart';
import 'package:blocprojects/weather/widgets/weather_empty.dart';
import 'package:blocprojects/weather/widgets/weather_error.dart';
import 'package:blocprojects/weather/widgets/weather_loading.dart';
import 'package:blocprojects/weather/widgets/weather_populated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherViewWidget extends StatefulWidget {
  const WeatherViewWidget({super.key});

  @override
  State<WeatherViewWidget> createState() => _WeatherViewWidgetState();
}

class _WeatherViewWidgetState extends State<WeatherViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push<void>(
                SettingsPage.route(context.read<WeatherCubit>()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: BlocConsumer<WeatherCubit, WeatherState>(
          builder: (context, state) {
            switch (state.weatherStatus) {
              case WeatherStatus.initial:
                return const WeatherEmpty();
              case WeatherStatus.loading:
                return const WeatherLoading();
              case WeatherStatus.failure:
                return const WeatherError();
              case WeatherStatus.success:
                return WeatherPopulated(
                    weather: state.weather!,
                    units: state.temperatureUnits,
                    onRefresh: () async {
                      await context.read<WeatherCubit>().refreshWeather();
                    });
            }
          },
          listener: (context, state) {
            if (state.weatherStatus.isSuccess) {
              context.read<ThemeCubit>().updateTheme(state.weather);
            }
          },
        ),
      ),
    );
  }
}
