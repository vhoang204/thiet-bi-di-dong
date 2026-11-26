import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductNotifier extends ChangeNotifier {
  List<Product> products = [];
  List<String> categories = [];
  String selectedCategory = 'Tất cả';
  bool isLoading = false;
  String? error;

  // Tải danh sách sản phẩm và danh mục lần đầu
  Future<void> initData() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        ApiService.getProducts(),
        ApiService.getCategories(),
      ]);
      products = results[0] as List<Product>;
      categories = ['Tất cả', ...(results[1] as List<String>)];
      selectedCategory = 'Tất cả';
    } catch (e) {
      error = errorMessage(e);
    }

    isLoading = false;
    notifyListeners();
  }

  // Tải lại toàn bộ sản phẩm
  Future<void> loadProducts() async {
    isLoading = true;
    error = null;
    selectedCategory = 'Tất cả';
    notifyListeners();

    try {
      products = await ApiService.getProducts();
    } catch (e) {
      error = errorMessage(e);
    }

    isLoading = false;
    notifyListeners();
  }

  // Tìm kiếm theo từ khóa
  Future<void> search(String keyword) async {
    if (keyword.trim().isEmpty) {
      await loadProducts();
      return;
    }
    isLoading = true;
    error = null;
    selectedCategory = 'Tất cả';
    notifyListeners();

    try {
      products = await ApiService.searchProducts(keyword.trim());
    } catch (e) {
      error = errorMessage(e);
    }

    isLoading = false;
    notifyListeners();
  }

  // Lọc theo chip danh mục
  Future<void> selectCategory(String slug) async {
    if (slug == 'Tất cả') {
      await loadProducts();
      return;
    }
    isLoading = true;
    error = null;
    selectedCategory = slug;
    notifyListeners();

    try {
      products = await ApiService.getProductsByCategory(slug);
    } catch (e) {
      error = errorMessage(e);
    }

    isLoading = false;
    notifyListeners();
  }
}
