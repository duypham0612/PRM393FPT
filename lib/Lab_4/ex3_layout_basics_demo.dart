import 'package:flutter/material.dart';

class LayoutBasicsDemo extends StatelessWidget {
  // Danh sách dữ liệu mẫu mô phỏng danh sách phim
  final List<String> movies = [
    'Avatar: The Way of Water',
    'Avengers: Endgame',
    'Inception',
    'Interstellar',
    'The Dark Knight',
    'Spiderman: No Way Home'
  ];

  LayoutBasicsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 3: Layout Basics')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section 1: Tiêu đề danh mục (Sử dụng Padding + Row)
          Padding(
            padding: const EdgeInsets.all(16.0), // Khoảng cách đều 16px
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text( // Đặt const ở đây
                  'Trending Movies',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text( // Đặt const ở đây
                  'See All',
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
          ),

          // Section 2: Danh sách phim cuộn (Sử dụng Expanded chống lỗi tràn màn hình)
          Expanded(
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.movie, color: Colors.redAccent),
                      title: Text(movies[index]), // Biến động hiển thị theo index nên KHÔNG có const
                      subtitle: Text('Genre: Sci-Fi / Action (Rank #${index + 1})'), // Biến động KHÔNG có const
                      trailing: const Icon(Icons.play_arrow),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}