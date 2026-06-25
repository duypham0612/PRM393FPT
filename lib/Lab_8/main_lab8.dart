import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 8 - API List Screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const PostListScreen(),
    );
  }
}

// ==========================================
// 1. DATA MODEL LAYER (Lab 8.2)
// ==========================================
class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  const Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'] ?? 0,
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'body': body,
    };
  }
}

// ==========================================
// 2. SERVICE LAYER (Lab 8.1 & 8.4)
// ==========================================
class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Post>> fetchPosts() async {
    try {
      final response = await client.get(Uri.parse('$_baseUrl/posts'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((jsonItem) => Post.fromJson(jsonItem)).toList();
      } else {
        throw Exception('Lỗi máy chủ: Mã trạng thái ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: Vui lòng kiểm tra lại internet.');
    }
  }

  Future<Post> createPost(String title, String body) async {
    try {
      final response = await client.post(
        Uri.parse('$_baseUrl/posts'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'title': title,
          'body': body,
          'userId': 1,
        }),
      );

      if (response.statusCode == 201) {
        return Post.fromJson(json.decode(response.body));
      } else {
        throw Exception('Tạo bài viết thất bại: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Không thể gửi dữ liệu: $e');
    }
  }
}

// ==========================================
// 3. UI PRESENTATION LAYER (Lab 8.2 & 8.3)
// ==========================================
class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  void _loadPosts() {
    setState(() {
      _postsFuture = _apiService.fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Posts Feed', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo.shade50,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPosts,
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadPosts(),
        child: FutureBuilder<List<Post>>(
          future: _postsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            else if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_off, color: Colors.red, size: 64),
                      const SizedBox(height: 16),
                      Text(
                        '${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _loadPosts,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Thử lại'),
                      ),
                    ],
                  ),
                ),
              );
            }

            else if (snapshot.hasData) {
              final posts = snapshot.data!;
              if (posts.isEmpty) {
                return const Center(child: Text('Không có bài viết nào.'));
              }

              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    elevation: 1,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigo.shade100,
                        child: Text('${post.id}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      title: Text(
                        post.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        post.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.chevron_right, size: 20),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostDetailScreen(post: post),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }

            return const Center(child: Text('Đã xảy ra lỗi không xác định.'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePostSheet(context),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreatePostSheet(BuildContext context) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24, left: 20, right: 20,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Tạo Bài Viết Mới (POST)',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Tiêu đề', border: OutlineInputBorder()),
                  validator: (val) => val!.isEmpty ? 'Vui lòng nhập tiêu đề' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: bodyController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Nội dung', border: OutlineInputBorder()),
                  validator: (val) => val!.isEmpty ? 'Vui lòng nhập nội dung' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14)
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đang gửi request POST...')),
                      );

                      try {
                        Post result = await _apiService.createPost(
                          titleController.text,
                          bodyController.text,
                        );

                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.green),
                                  SizedBox(width: 8),
                                  Text('Thành công (201)'),
                                ],
                              ),
                              content: Text('Đã tạo thành công bài viết ID: ${result.id}.\n\nTiêu đề: ${result.title}'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Đóng'))
                              ],
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
                          );
                        }
                      }
                    }
                  },
                  child: const Text('Gửi Request POST', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ==========================================
// 4. DETAIL VIEW SCREEN
// ==========================================
class PostDetailScreen extends StatelessWidget {
  final Post post;
  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết bài viết #${post.id}'),
        backgroundColor: Colors.indigo.shade50,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Chip(
                  avatar: const Icon(Icons.person, size: 16, color: Colors.indigo),
                  label: Text('User ID: ${post.userId}'),
                ),
                const SizedBox(width: 8),
                Chip(
                  avatar: const Icon(Icons.tag, size: 16, color: Colors.indigo),
                  label: Text('Post ID: ${post.id}'),
                ),
              ],
            ),
            const Divider(height: 40, thickness: 1),
            const Text(
              'Nội dung chi tiết:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              post.body,
              style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}