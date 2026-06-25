import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  // Bản đồ tọa độ cứng của một số thành phố ở Việt Nam để test nhanh
  final Map<String, Map<String, double>> cityCoordinates = {
    'Hà Nội': {'lat': 21.0285, 'lon': 105.8542},
    'TP. Hồ Chí Minh': {'lat': 10.8231, 'lon': 106.6297},
    'Đà Nẵng': {'lat': 16.0544, 'lon': 108.2022},
  };

  Future<WeatherModel> fetchWeather(String cityName) async {
    final coords = cityCoordinates[cityName];
    if (coords == null) {
      throw Exception("Không tìm thấy dữ liệu tọa độ cho thành phố này.");
    }

    final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=${coords['lat']}&longitude=${coords['lon']}&current_weather=true');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return WeatherModel.fromJson(data, cityName);
      } else {
        throw Exception("Lỗi server: Mã phản hồi ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Lỗi kết nối mạng: Không thể tải dữ liệu thời tiết.");
    }
  }
}