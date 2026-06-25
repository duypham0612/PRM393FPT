class WeatherModel {
  final double temperature;
  final double windSpeed;
  final int weatherCode;
  final String cityName;

  WeatherModel({
    required this.temperature,
    required this.windSpeed,
    required this.weatherCode,
    required this.cityName,
  });

  // Convert từ JSON của Open-Meteo sang Dart Object
  factory WeatherModel.fromJson(Map<String, dynamic> json, String city) {
    final current = json['current_weather'];
    return WeatherModel(
      temperature: (current['temperature'] as num).toDouble(),
      windSpeed: (current['windspeed'] as num).toDouble(),
      weatherCode: (current['weathercode'] as num).toInt(),
      cityName: city,
    );
  }

  // Khía cạnh thực tế (Purpose-driven): Đưa ra lời khuyên dựa trên thời tiết
  String get recommendation {
    if (weatherCode >= 51 && weatherCode <= 67) {
      return "🌧️ Trời đang mưa đấy! Nhớ mang theo ô (dù) khi ra ngoài nhé.";
    } else if (weatherCode >= 71 && weatherCode <= 86) {
      return "❄️ Có tuyết rơi hoặc trời rất lạnh, hãy mặc áo khoác thật ấm!";
    } else if (temperature > 32) {
      return "🥵 Trời khá nóng gay gắt, hạn chế hoạt động thể thao ngoài trời và uống nhiều nước.";
    } else if (temperature >= 20 && temperature <= 28) {
      return "🍃 Thời tiết quá lý tưởng! Rất thích hợp để đi dạo hoặc làm một tách cà phê đá.";
    } else {
      return "☀️ Thời tiết bình thường, chúc bạn có một ngày làm việc/học tập vui vẻ!";
    }
  }

  // Lấy text trạng thái thời tiết dựa trên mã Code của Tổ chức Khí tượng
  String get weatherDescription {
    if (weatherCode == 0) return "Trời quang mây tạnh";
    if (weatherCode >= 1 && weatherCode <= 3) return "Ít mây / Mây rải rác";
    if (weatherCode >= 45 && weatherCode <= 48) return "Có sương mù";
    if (weatherCode >= 51 && weatherCode <= 67) return "Trời có mưa";
    return "Nhiều mây";
  }
}