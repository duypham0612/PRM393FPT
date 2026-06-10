import 'package:flutter/material.dart';

void main() {
  runApp(const Lab7ValidationApp());
}

class Lab7ValidationApp extends StatelessWidget {
  const Lab7ValidationApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 7 - Signup Form',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
      ),
      home: const SignupScreen(),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // --- Khóa quản lý Trạng thái Form ---
  final _formKey = GlobalKey<FormState>();

  // --- Bộ điều khiển Dữ liệu Nhập (Controllers) ---
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // --- Quản lý Tiêu điểm Bàn phím (FocusNodes) ---
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  // --- Trạng thái Giao diện UI/UX (Bonus Features) ---
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isCheckingEmail = false;
  bool _acceptTerms = false;
  String _passwordStrength = '';
  Color _strengthColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    // Lắng nghe thay đổi mật khẩu để cập nhật độ mạnh trực gian (Real-time UX)
    _passwordController.addListener(_checkPasswordStrength);
  }

  @override
  void dispose() {
    // Giải phóng bộ nhớ tránh rò rỉ dữ liệu (Memory Leak)
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  // --- Hàm phân tích Độ mạnh Mật khẩu (Bonus Step) ---
  void _checkPasswordStrength() {
    final password = _passwordController.text;
    if (password.isEmpty) {
      setState(() {
        _passwordStrength = '';
        _strengthColor = Colors.transparent;
      });
      return;
    }

    bool hasDigit = RegExp(r'[0-9]').hasMatch(password);
    bool hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

    setState(() {
      if (password.length < 6) {
        _passwordStrength = 'Quá ngắn (Weak)';
        _strengthColor = Colors.red;
      } else if (password.length >= 8 && hasDigit && hasSpecial) {
        _passwordStrength = 'Rất mạnh (Strong)';
        _strengthColor = Colors.green;
      } else if (password.length >= 8 && hasDigit) {
        _passwordStrength = 'Trung bình (Medium)';
        _strengthColor = Colors.orange;
      } else {
        _passwordStrength = 'Yếu (Weak)';
        _strengthColor = Colors.redAccent;
      }
    });
  }

  // --- Quy tắc Kiểm tra Dữ liệu đầu vào (Validators) ---
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Vui lòng nhập họ và tên';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Vui lòng nhập Email';
    // Regex cơ bản kiểm tra định dạng email chuẩn cấu trúc @ và .
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value.trim())) return 'Định dạng Email không hợp lệ';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng nhập mật khẩu';
    if (value.length < 8) return 'Mật khẩu phải chứa ít nhất 8 ký tự';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Mật khẩu phải chứa ít nhất 1 chữ số';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Vui lòng xác nhận lại mật khẩu';
    if (value != _passwordController.text) return 'Mật khẩu xác nhận không trùng khớp';
    return null;
  }

  // --- Xử lý Gửi Biểu mẫu & Bất đồng bộ (Lab 7.4) ---
  Future<void> _submitForm() async {
    // 1. Tắt toàn bộ tiêu điểm bàn phím hiện tại
    FocusScope.of(context).unfocus();

    // 2. Kiểm tra tính hợp lệ cục bộ (Đồng bộ)
    if (!_formKey.currentState!.validate()) return;

    // Kiểm tra ràng buộc điều khoản đi kèm (Bonus Check)
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn phải đồng ý với Điều khoản sử dụng')),
      );
      return;
    }

    // 3. Kích hoạt trạng thái đợi và giả lập gọi API (Bất đồng bộ)
    setState(() => _isCheckingEmail = true);

    // Giả lập độ trễ truyền tải mạng 2 giây
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isCheckingEmail = false);

    // Luật giả lập: Email bắt đầu bằng chuỗi chữ "taken" sẽ coi như đã tồn tại
    if (_emailController.text.trim().toLowerCase().startsWith('taken')) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [Icon(Icons.error, color: Colors.red), SizedBox(width: 8), Text('Lỗi đăng ký')],
          ),
          content: Text('Địa chỉ email "${_emailController.text}" này đã có người sử dụng. Vui lòng chọn email khác.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Đóng')),
          ],
        ),
      );
    } else {
      // Đăng ký hoàn tất thành công
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green[700],
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text('Đăng ký tài khoản ${_nameController.text} thành công!'),
            ],
          ),
        ),
      );
      _formKey.currentState!.reset();
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      setState(() => _acceptTerms = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Chạm ra vùng ngoài vùng nhập liệu sẽ tự động ẩn bàn phím (Lab 7.3)
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text('Đăng Ký Tài Khoản', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500), // Tối ưu hiển thị trên Tablet/Web
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                // Tự động kiểm tra lỗi trực quan ngay khi người dùng tương tác nhập liệu (Lab 7.2)
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: SingleChildScrollView(
                  // SingleChildScrollView ngăn chặn triệt để lỗi Overflow tràn màn hình khi bật bàn phím
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      const Text(
                        'Tạo tài khoản mới để trải nghiệm dịch vụ của chúng tôi.',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 24),

                      // --- Trường Nhập Họ Và Tên ---
                      TextFormField(
                        controller: _nameController,
                        focusNode: _nameFocusNode,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Họ và Tên',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: _validateName,
                        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_emailFocusNode),
                      ),
                      const SizedBox(height: 16),

                      // --- Trường Nhập Email ---
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Địa chỉ Email',
                          prefixIcon: const Icon(Icons.email),
                          hintText: 'Mẹo thử: Nhập "taken@gmail.com" để test lỗi dữ liệu trùng',
                          hintStyle: const TextStyle(fontSize: 11, color: Colors.amber),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: _validateEmail,
                        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocusNode),
                      ),
                      const SizedBox(height: 16),

                      // --- Trường Nhập Mật Khẩu ---
                      TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Mật khẩu',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: _validatePassword,
                        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_confirmPasswordFocusNode),
                      ),

                      // Hiển thị dải băng nhận biết độ mạnh mật khẩu động dưới ô Input (Bonus Layout)
                      if (_passwordStrength.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                          child: Row(
                            children: [
                              Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: _strengthColor)),
                              const SizedBox(width: 8),
                              Text('Độ mạnh mật khẩu: $_passwordStrength', style: TextStyle(fontSize: 13, color: _strengthColor, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),

                      // --- Trường Xác Nhận Lại Mật Khẩu ---
                      TextFormField(
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocusNode,
                        obscureText: _obscureConfirmPassword,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: 'Xác nhận mật khẩu',
                          prefixIcon: const Icon(Icons.lock_clock),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: _validateConfirmPassword,
                        onFieldSubmitted: (_) => _submitForm(),
                      ),
                      const SizedBox(height: 16),

                      // --- Checkbox chấp thuận điều khoản (Bonus Step) ---
                      CheckboxListTile(
                        title: const Text('Tôi đồng ý với mọi Điều khoản dịch vụ và Chính sách bảo mật thông tin.', style: TextStyle(fontSize: 13)),
                        value: _acceptTerms,
                        onChanged: (bool? val) => setState(() => _acceptTerms = val ?? false),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 16),

                      // --- Nút Gửi Đăng Ký Hệ Thống ---
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isCheckingEmail ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: _isCheckingEmail
                              ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                              : const Text('ĐĂNG KÝ NGAY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.1)),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}