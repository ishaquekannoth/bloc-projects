import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather_repository/weather_repository.dart'
    as weather_repository;
import 'package:weather_repository/weather_repository.dart' hide WeatherModel;

part 'weather.g.dart';

enum TemperatureUnits { fahrenheit, celsius }

extension TemperatureUnitsX on TemperatureUnits {
  bool get isFahrenheit => this == TemperatureUnits.fahrenheit;
  bool get isCelsius => this == TemperatureUnits.celsius;
}

@JsonSerializable()
class Temperature extends Equatable {
  const Temperature({required this.value});
  @override
  List<Object?> get props => [value];
  final double value;
  factory Temperature.fromJson(Map<String, dynamic> json) =>
      _$TemperatureFromJson(json);
  Map<String, dynamic> toJson() => _$TemperatureToJson(this);
}

@JsonSerializable()
class Weather extends Equatable {
  final WeatherCondition weatherCondition;
  final DateTime lastUpdated;
  final Temperature temperature;
  final String location;

  const Weather(
      {required this.weatherCondition,
      required this.lastUpdated,
      required this.temperature,
      required this.location});
  @override
  List<Object?> get props =>
      [weatherCondition, lastUpdated, temperature, location];

  factory Weather.fromRepository(weather_repository.WeatherModel weather) {
    return Weather(
        weatherCondition: weather.condition,
        lastUpdated: DateTime.now(),
        temperature: Temperature(value: weather.temperature),
        location: weather.location);
  }
  static final empty = Weather(
    weatherCondition: WeatherCondition.unknown,
    lastUpdated: DateTime(0),
    temperature: const Temperature(value: 0),
    location: '--',
  );

  Weather copyWith({
    WeatherCondition? weatherCondition,
    DateTime? lastUpdated,
    Temperature? temperature,
    String? location,
  }) {
    return Weather(
      weatherCondition: weatherCondition ?? this.weatherCondition,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      temperature: temperature ?? this.temperature,
      location: location ?? this.location,
    );
  }

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}
