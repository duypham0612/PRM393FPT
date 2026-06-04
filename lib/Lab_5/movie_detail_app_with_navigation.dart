import 'package:flutter/material.dart';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Detail App',
      debugShowCheckedModeBanner: false,
      // Thiết lập Theme đồng bộ theo phong cách rạp phim (Dark Theme)
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.red,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Colors.redAccent,
          secondary: Colors.amber,
        ),
      ),
      home: const MovieHomeScreen(),
    );
  }
}

// ==================== STEP 2: DEFINE DATA MODEL & SAMPLE DATA ====================
class Trailer {
  final String name;
  final String duration;

  const Trailer({required this.name, required this.duration});
}

class Movie {
  final String id;
  final String title;
  final String posterUrl;
  final String overview;
  final List<String> genres;
  final double rating;
  final List<Trailer> trailers;
  bool isFavorite; // Dùng cho tính năng nâng cao (Favorite Toggle)

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.genres,
    required this.rating,
    required this.trailers,
    this.isFavorite = false,
  });
}

// Dữ liệu mẫu (Static Sample Data) sử dụng hình ảnh chất lượng từ Unsplash
final List<Movie> sampleMovies = [
  Movie(
    id: '1',
    title: 'Interstellar',
    posterUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=600',
    overview: 'Phim kể về một nhóm các nhà thám hiểm vũ trụ sử dụng một hố đen mới được khám phá để vượt qua các giới hạn thông thường của du hành không gian, tìm kiếm một hành tinh mới có thể duy trì sự sống cho nhân loại đang trên bờ vực diệt vong.',
    genres: ['Khoa học viễn tưởng', 'Phiêu lưu', 'Kịch tính'],
    rating: 8.7,
    trailers: [
      const Trailer(name: 'Official Teaser Trailer', duration: '1:52'),
      const Trailer(name: 'Main Official Trailer', duration: '2:34'),
      const Trailer(name: 'Inception Crossing Featurette', duration: '4:15'),
    ],
  ),
  Movie(
    id: '2',
    title: 'Avatar: The Way of Water',
    posterUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=600',
    overview: 'Lấy bối cảnh hơn một thập kỷ sau các sự kiện của phần phim đầu tiên, bộ phim kể câu chuyện về gia đình Sully (Jake, Neytiri và con cái của họ), những rắc rối bám theo họ, những nỗ lực họ vượt qua để bảo vệ nhau và những bi kịch họ phải chịu đựng.',
    genres: ['Hành động', 'Viễn tưởng', 'Chấn động'],
    rating: 7.6,
    trailers: [
      const Trailer(name: 'Official Teaser', duration: '2:10'),
      const Trailer(name: 'Official Trailer 2', duration: '2:28'),
    ],
  ),
  Movie(
    id: '3',
    title: 'The Dark Knight',
    posterUrl: 'https://images.unsplash.com/photo-1478760329108-5c3ed9d495a0?w=600',
    overview: 'Khi mối đe dọa được gọi là Joker gây ra sự hỗn loạn và tàn phá người dân Gotham, Người Dơi phải chấp nhận một trong những thử thách tâm lý và thể chất lớn nhất để chống lại sự bất công độc ác này.',
    genres: ['Hành động', 'Tội phạm', 'Giật gân'],
    rating: 9.0,
    trailers: [
      const Trailer(name: 'Teaser Trailer', duration: '1:40'),
      const Trailer(name: 'Theatrical Trailer', duration: '2:30'),
    ],
  ),
];

// ==================== STEP 3: BUILD HOME SCREEN ====================
class MovieHomeScreen extends StatefulWidget {
  const MovieHomeScreen({super.key});

  @override
  State<MovieHomeScreen> createState() => _MovieHomeScreenState();
}

class _MovieHomeScreenState extends State<MovieHomeScreen> {
  List<Movie> _filteredMovies = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredMovies = sampleMovies; // Ban đầu hiển thị toàn bộ phim
  }

  // Optional Enhancement: Bộ lọc tìm kiếm phim đơn giản
  void _filterMovies(String query) {
    setState(() {
      _filteredMovies = sampleMovies
          .where((movie) => movie.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎬 Phim Mới Rạp', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Optional Enhancement: Thanh tìm kiếm trực quan
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterMovies,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm phim...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Danh sách phim cuộn mượt mà sử dụng ListView.builder
          Expanded(
            child: _filteredMovies.isEmpty
                ? const Center(child: Text('Không tìm thấy phim phù hợp!'))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _filteredMovies.length,
              itemBuilder: (context, index) {
                final movie = _filteredMovies[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 5,
                  child: InkWell(
                    // Thực hiện Technical Requirement 1 & 2: Navigator.push truyền đối tượng Movie
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(movie: movie),
                        ),
                      );
                      // SetState chạy lại khi từ màn hình Detail bấm Back về để cập nhật trạng thái Favorite
                      setState(() {});
                    },
                    child: Row(
                      children: [
                        // Ảnh Poster bên trái Card
                        Image.network(
                          movie.posterUrl,
                          width: 110,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(
                            width: 110, height: 150, color: Colors.grey,
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                        // Thông tin Text bên phải Card
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${movie.rating} / 10',
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Hiển thị tối đa 2 tag thể loại đại diện
                                Wrap(
                                  spacing: 6,
                                  children: movie.genres.take(2).map((g) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(g, style: const TextStyle(fontSize: 11, color: Colors.redAccent)),
                                  )).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        )
                      ],
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

// ==================== STEP 4: BUILD MOVIE DETAIL SCREEN ====================
class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      // Sử dụng SingleChildScrollView để toàn bộ màn hình có thể cuộn linh hoạt, chống tràn lỗi pixel
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Banner (Sử dụng Stack + Image.network + Hiệu ứng Gradient)
            Stack(
              children: [
                ShaderMask(
                  shaderCallback: (rect) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black, Colors.transparent],
                    ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.network(
                    movie.posterUrl,
                    width: double.infinity,
                    height: 320,
                    fit: BoxFit.cover,
                  ),
                ),
                // Nút Back thủ công tùy biến nổi lên trên Banner
                Positioned(
                  top: 40,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context), // Quay lại màn hình trước
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Title hiển thị lớn và nổi bật
                  Text(
                    movie.title,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // 3. Danh sách thể loại Genres hiển thị dưới dạng Wrap + Chip
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: movie.genres.map((genre) => Chip(
                      label: Text(genre),
                      backgroundColor: Colors.grey[900],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                    )).toList(),
                  ),
                  const SizedBox(height: 12),

                  // 4. Row of Action Buttons (Favorite, Rate, Share)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Nút Tương tác Yêu Thích (Có cập nhật State trực tiếp trên màn hình)
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(
                              movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: movie.isFavorite ? Colors.red : Colors.white,
                            ),
                            iconSize: 28,
                            onPressed: () {
                              setState(() {
                                movie.isFavorite = !movie.isFavorite; // Đảo ngược trạng thái
                              });
                            },
                          ),
                          const Text('Favorite', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      // Nút Đánh giá Rate hiển thị Điểm số phim
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.star, color: Colors.amber),
                            iconSize: 28,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Bạn đã chấm bộ phim này ${movie.rating} điểm!')),
                              );
                            },
                          ),
                          Text('${movie.rating} / 10', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      // Nút Chia sẻ Share
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.share, color: Colors.blueAccent),
                            iconSize: 28,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Đang chia sẻ phim: ${movie.title}')),
                              );
                            },
                          ),
                          const Text('Share', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 5. Phần nội dung tóm tắt phim (Overview)
                  const Text(
                    'Nội dung phim',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.overview,
                    style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.white70),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 24),

                  // 6. Danh sách Trailers sử dụng cấu hình ListView.builder thu gọn (shrinkWrap)
                  const Text(
                    'Trailers & Clips',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true, // Quan trọng: Cho phép ListView lồng gọn vào SingleChildScrollView cha
                    physics: const NeverScrollableScrollPhysics(), // Tắt cuộn độc lập để cuộn theo màn hình lớn
                    itemCount: movie.trailers.length,
                    itemBuilder: (context, tIndex) {
                      final trailer = movie.trailers[tIndex];
                      return Card(
                        color: Colors.grey[900],
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: const Icon(Icons.play_circle_fill, color: Colors.red, size: 36),
                          title: Text(trailer.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                          subtitle: Text('Thời lượng: ${trailer.duration}'),
                          trailing: const Icon(Icons.arrow_right, color: Colors.grey),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Đang phát video: ${trailer.name}')),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30), // Tạo khoảng cách trống an toàn dưới chân trang
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Định nghĩa màu chữ bạc hỗ trợ chế độ đọc dịu mắt
extension ThemeColors on TextStyle {
  Color get whiteBF => const Color(0xFFE0E0E0);
}