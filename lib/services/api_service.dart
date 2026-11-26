import 'package:dio/dio.dart';
import '../models/product.dart';
import '../models/user.dart'; // <-- 1. Thêm dòng import này

class ApiService {
  static final Dio dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));

  // --- CÁC HÀM SẢN PHẨM (Giữ nguyên) ---
  static Future<List<Product>> getProducts() async {
    final response = await dio.get('/products', queryParameters: {'limit': 30});
    final List data = response.data['products'];
    return data.map((json) => Product.fromJson(json)).toList();
  }

  static Future<List<Product>> searchProducts(String keyword) async {
    final response = await dio.get(
      '/products/search',
      queryParameters: {'q': keyword},
    );
    final List data = response.data['products'];
    return data.map((json) => Product.fromJson(json)).toList();
  }

  static Future<List<String>> getCategories() async {
    final response = await dio.get('/products/category-list');
    return List<String>.from(response.data);
  }

  static Future<List<Product>> getProductsByCategory(String slug) async {
    final response = await dio.get('/products/category/$slug');
    final List data = response.data['products'];
    return data.map((json) => Product.fromJson(json)).toList();
  }

  static Future<Product> getProduct(int id) async {
    final response = await dio.get('/products/$id');
    return Product.fromJson(response.data);
  }

  // --- 2. THÊM 3 HÀM ĐĂNG NHẬP / BEARER TOKEN DƯỚI ĐÂY ---
  static Future<User> login(String username, String password) async {
    final response = await dio.post(
      '/auth/login',
      data: {'username': username, 'password': password},
    );
    final token = response.data['accessToken'];
    dio.options.headers['Authorization'] = 'Bearer $token';
    return User.fromJson(response.data);
  }

  static Future<User> getMe() async {
    final response = await dio.get('/auth/me');
    return User.fromJson(response.data);
  }

  static void logout() {
    dio.options.headers.remove('Authorization');
  }
}

// Hàm chuyển lỗi Dio sang câu thông báo tiếng Việt
String errorMessage(Object e) {
  if (e is DioException) {
    final code = e.response?.statusCode;
    if (code == null) {
      return 'Không kết nối được máy chủ. Kiểm tra mạng và thử lại.';
    }
    if (code == 400) return 'Tên đăng nhập hoặc mật khẩu không đúng.';
    if (code == 401) return 'Phiên đăng nhập đã hết hạn.';
    if (code == 404) return 'Không tìm thấy dữ liệu.';
  }
  return 'Đã có lỗi xảy ra. Vui lòng thử lại.';
}
