import 'package:flutter/material.dart';

void main() {
  runApp(const BookReaderApp());
}

class BookReaderApp extends StatelessWidget {
  const BookReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng dụng Đọc Sách',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFBF6EE), // Màu nền giấy ngả vàng giúp dịu mắt
      ),
      home: const BookHomeScreen(),
    );
  }
}

// ==================== MÔ HÌNH DỮ LIỆU (DATA MODEL) ====================
class Chapter {
  final String title;
  final String content;

  const Chapter({required this.title, required this.content});
}

class Book {
  final String id;
  final String title;
  final String author;
  final String coverUrl;
  final List<Chapter> chapters;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.chapters,
  });
}

// Dữ liệu mẫu (Mock Data) gồm 2 cuốn sách, mỗi cuốn có nhiều chương
const List<Book> mockBooks = [
  Book(
    id: '1',
    title: 'Dế Mèn Phiêu Lưu Ký',
    author: 'Tô Hoài',
    coverUrl: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400',
    chapters: [
      Chapter(title: 'Chương 1: Tôi sống độc lập từ thuở bé', content: 'Tôi sống độc lập từ thuở bé. Ấy là tục lệ lâu đời trong họ dế chúng tôi. Vả lại, mẹ tôi thường nghĩ rằng người ta ai cũng phải tự lập sớm... Ngẫm ra thì tôi có vẻ một chàng dế thanh niên cường tráng lắm rồi!'),
      Chapter(title: 'Chương 2: Cuộc phiêu lưu bất ngờ', content: 'Một tai họa đến từ sự ngông cuồng của tôi. Tôi đã trêu chị Cốc để rồi dẫn đến cái chết thương tâm của người bạn hàng xóm xấu số là anh Dế Choắt. Bài học đường đời đầu tiên ấy tôi không bao giờ quên...'),
      Chapter(title: 'Chương 3: Đường ra thế giới rộng lớn', content: 'Từ giã bãi cỏ thân thương đầy kỷ niệm, tôi quyết tâm lên đường chu du thiên hạ, tìm kiếm những người bạn chí hướng, cùng nhau xây dựng thế giới đại đồng muôn loài thân thiện.'),
    ],
  ),
  Book(
    id: '2',
    title: 'Lão Hạc',
    author: 'Nam Cao',
    coverUrl: 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=400',
    chapters: [
      Chapter(title: 'Chương 1: Lão Hạc và cậu Vàng', content: 'Lão Hạc ngồi trao đổi với tôi về việc bán con chó. Con chó ấy lão quý lắm, gọi nó là cậu Vàng như một đứa con nuôi. Cuộc sống túng quẫn ép lão vào đường cùng...'),
      Chapter(title: 'Chương 2: Quyết định đau lòng', content: 'Cậu Vàng đã bán rồi! Lão Hạc sang nhà tôi khóc hu hu mếu máo như một đứa trẻ. Lão thương con chó, lão trách mình đã già đầu mà còn đi đánh lừa một con chó.'),
      Chapter(title: 'Chương 3: Sự lựa chọn cuối cùng', content: 'Lão Hạc chọn cái chết bằng bả chó để bảo toàn tiền và mảnh vườn cho đứa con trai đi đồn điền cao su chưa về. Một cái chết dữ dội, đau đớn nhưng tràn đầy lòng tự trọng.'),
    ],
  ),
];

// Quản lý Bookmark đơn giản (Biến static toàn cục để demo nhanh trên lớp)
class BookmarkManager {
  static List<String> bookmarkedChapters = []; // Định dạng lưu: "bookId_chapterIndex"

  static void toggleBookmark(String bookId, int chapterIndex) {
    String key = "${bookId}_$chapterIndex";
    if (bookmarkedChapters.contains(key)) {
      bookmarkedChapters.remove(key);
    } else {
      bookmarkedChapters.add(key);
    }
  }

  static bool isBookmarked(String bookId, int chapterIndex) {
    return bookmarkedChapters.contains("${bookId}_$chapterIndex");
  }
}

// ==================== MÀN HÌNH 1: CHỌN SÁCH (HOME) ====================
class BookHomeScreen extends StatelessWidget {
  const BookHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📚 Thư Viện Số', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.amber[600],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sách Hay Nên Đọc',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.brown),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: mockBooks.length,
                itemBuilder: (context, index) {
                  final book = mockBooks[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          book.coverUrl,
                          width: 60,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        book.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tác giả: ${book.author}', style: const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text('${book.chapters.length} Chương', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.amber),
                      onTap: () {
                        // Chuyển sang Màn hình Mục Lục
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookTableOfContentsScreen(book: book),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== MÀN HÌNH 2: MỤC LỤC (TABLE OF CONTENTS) ====================
class BookTableOfContentsScreen extends StatefulWidget {
  final Book book;
  const BookTableOfContentsScreen({super.key, required this.book});

  @override
  State<BookTableOfContentsScreen> createState() => _BookTableOfContentsScreenState();
}

class _BookTableOfContentsScreenState extends State<BookTableOfContentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
        backgroundColor: Colors.amber[400],
      ),
      body: Column(
        children: [
          // Banner thông tin sách ngắn gọn
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.amber.withOpacity(0.1),
            child: Row(
              children: [
                Icon(Icons.menu_book, size: 40, color: Colors.amber[800]),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('MỤC LỤC CHI TIẾT', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                      Text('Chọn một chương để bắt đầu đọc', style: TextStyle(color: Colors.brown[700])),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Danh sách các chương
          Expanded(
            child: ListView.builder(
              itemCount: widget.book.chapters.length,
              itemBuilder: (context, index) {
                final chapter = widget.book.chapters[index];
                final isBookmarked = BookmarkManager.isBookmarked(widget.book.id, index);

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.amber[200],
                    child: Text('${index + 1}', style: const TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(
                    chapter.title,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  // Hiển thị icon nhỏ nếu chương này đang được bookmark
                  trailing: isBookmarked
                      ? const Icon(Icons.bookmark, color: Colors.redAccent)
                      : const Icon(Icons.arrow_forward),
                  onTap: () async {
                    // Chuyển sang màn hình Đọc Sách và đợi kết quả trả về để cập nhật lại icon Bookmark (nếu có thay đổi)
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReadingScreen(
                          book: widget.book,
                          chapterIndex: index,
                        ),
                      ),
                    );
                    setState(() {}); // Làm mới lại màn hình mục lục khi quay ra
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== MÀN HÌNH 3: ĐỌC SÁCH (READING SCREEN) + BOOKMARK ====================
class ReadingScreen extends StatefulWidget {
  final Book book;
  final int chapterIndex;

  const ReadingScreen({
    super.key,
    required this.book,
    required this.chapterIndex,
  });

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  late int _currentChapterIndex;
  double _fontSize = 18.0; // Tính năng bổ sung tăng trải nghiệm: Chỉnh size chữ

  @override
  void initState() {
    super.initState();
    _currentChapterIndex = widget.chapterIndex;
  }

  @override
  Widget build(BuildContext context) {
    final currentChapter = widget.book.chapters[_currentChapterIndex];
    final isBookmarked = BookmarkManager.isBookmarked(widget.book.id, _currentChapterIndex);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title, style: const TextStyle(fontSize: 16)),
        backgroundColor: Colors.amber[300],
        actions: [
          // Nút cấu hình cỡ chữ nhanh
          IconButton(
            icon: const Icon(Icons.format_size),
            onPressed: () {
              setState(() {
                _fontSize = _fontSize == 18.0 ? 22.0 : (_fontSize == 22.0 ? 26.0 : 18.0);
              });
            },
            tooltip: 'Thay đổi cỡ chữ',
          ),
          // NÚT BOOKMARK (Tính năng cốt lõi bắt buộc)
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? Colors.red : Colors.black87,
              size: 28,
            ),
            onPressed: () {
              setState(() {
                BookmarkManager.toggleBookmark(widget.book.id, _currentChapterIndex);
              });
              // Hiển thị thông báo Toast nhẹ ở cạnh dưới
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isBookmarked ? 'Đã hủy dấu trang!' : 'Đã đánh dấu trang này!'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Tiêu đề chương độc lập
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: Colors.brown.withOpacity(0.05),
            child: Text(
              currentChapter.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown),
              textAlign: TextAlign.center,
            ),
          ),

          // Nội dung văn bản đọc sách chính
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                currentChapter.content,
                style: TextStyle(
                  fontSize: _fontSize,
                  height: 1.6, // Khoảng cách dòng thưa dễ đọc
                  color: Colors.black87,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ),

          // Thanh điều hướng Đổi chương nhanh (Next / Previous Chapter) dưới chân trang
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, -2))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _currentChapterIndex > 0
                      ? () => setState(() => _currentChapterIndex--)
                      : null,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Chương trước'),
                ),
                Text(
                  '${_currentChapterIndex + 1} / ${widget.book.chapters.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: _currentChapterIndex < widget.book.chapters.length - 1
                      ? () => setState(() => _currentChapterIndex++)
                      : null,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Chương sau'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}