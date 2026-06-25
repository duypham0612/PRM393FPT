import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class JsonStorageService {
  // Tìm đường dẫn thư mục lưu trữ an toàn của ứng dụng trên thiết bị
  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/local_students_db.json');
  }

  // Đọc dữ liệu từ file local, nếu chưa có file thì tạo mới với dữ liệu mặc định ban đầu
  Future<List<dynamic>> readFromJsonFile() async {
    try {
      final file = await _getLocalFile();
      if (!await file.exists()) {
        // Tạo file trống ban đầu nếu chưa tồn tại
        await file.writeAsString(jsonEncode([]));
        return [];
      }
      final contents = await file.readAsString();
      return jsonDecode(contents) as List<dynamic>;
    } catch (e) {
      return [];
    }
  }

  // Ghi toàn bộ danh sách (List) quay ngược lại thành file JSON cục bộ (Auto-save)
  Future<File> writeToJsonFile(List<dynamic> listData) async {
    final file = await _getLocalFile();
    return file.writeAsString(jsonEncode(listData));
  }
}