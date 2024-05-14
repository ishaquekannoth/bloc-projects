import 'package:json_annotation/json_annotation.dart';
part 'weather.g.dart';
@JsonSerializable()
class Weather {
  const Weather({required this.temperature, required this.weatherCode});
  final double temperature;
  @JsonKey(name: 'weatherCode')
  final double weatherCode;
}
