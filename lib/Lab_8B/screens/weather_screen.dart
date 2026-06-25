import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  late Future<WeatherModel> _weatherFuture;
  String _selectedCity = 'Hà Nội';

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  void _loadWeather() {
    setState(() {
      _weatherFuture = _weatherService.fetchWeather(_selectedCity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🌤️ Trợ Lý Thời Tiết Lab 8B', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade100, Colors.white],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Form chọn thành phố đơn giản
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Chọn khu vực:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    DropdownButton<String>(
                      value: _selectedCity,
                      items: ['Hà Nội', 'Đà Nẵng', 'TP. Hồ Chí Minh'].map((String city) {
                        return DropdownMenuItem<String>(
                          value: city,
                          child: Text(city, style: const TextStyle(fontSize: 16)),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          _selectedCity = newValue;
                          _loadWeather(); // Gọi lại API khi đổi thành phố
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 2. Khu vực FutureBuilder xử lý dữ liệu API
            Expanded(
              child: FutureBuilder<WeatherModel>(
                future: _weatherFuture,
                builder: (context, snapshot) {
                  // A. TRẠNG THÁI LOADING
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.blueAccent),
                          SizedBox(height: 16),
                          Text('Đang kết nối API trạm khí tượng...'),
                        ],
                      ),
                    );
                  }

                  // B. TRẠNG THÁI LỖI (Ví dụ: Tắt mạng) -> Có nút Retry bấm để tải lại
                  if (snapshot.hasError) {
                    return Center(
                      child: Card(
                        color: Colors.red.shade50,
                        margin: const EdgeInsets.all(16),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.wifi_off, color: Colors.red, size: 48),
                              const SizedBox(height: 12),
                              Text(
                                '${snapshot.error}',
                                style: const TextStyle(color: Colors.red, fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: _loadWeather,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Thử lại ngay'),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  // C. TRẠNG THÁI THÀNH CÔNG -> Hiển thị thông tin & mục đích ứng dụng
                  if (snapshot.hasData) {
                    final weather = snapshot.data!;
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          // Card hiển thị thông số thô
                          Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                children: [
                                  Text(weather.cityName, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue)),
                                  const SizedBox(height: 8),
                                  Text(weather.weatherDescription, style: TextStyle(fontSize: 18, color: Colors.grey.shade700)),
                                  const SizedBox(height: 16),
                                  Text('${weather.temperature}°C', style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w300, color: Colors.black87)),
                                  const SizedBox(height: 16),
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          const Icon(Icons.air, color: Colors.blueGrey),
                                          const SizedBox(height: 4),
                                          Text('Gió: ${weather.windSpeed} km/h', style: const TextStyle(fontSize: 14)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // CARD MỤC ĐÍCH ỨNG DỤNG: Đưa ra lời khuyên thực tế (Purpose-driven)
                          Card(
                            elevation: 4,
                            color: Colors.amber.shade50,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(color: Colors.amber.shade300, width: 1)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(Icons.lightbulb, color: Colors.amber, size: 24),
                                      SizedBox(width: 8),
                                      Text('Khuyến nghị hôm nay:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    weather.recommendation,
                                    style: const TextStyle(fontSize: 16, height: 1.4, color: Colors.black87, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }

                  return const Center(child: Text('Không có dữ liệu nào.'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}