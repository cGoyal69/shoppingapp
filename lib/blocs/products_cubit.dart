import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/product_repository.dart';
import '../models/product_model.dart';

class ProductsState {
  final List<Product> products;
  final bool hasReachedMax;
  final int page;

  ProductsState({
    this.products = const [],
    this.hasReachedMax = false,
    this.page = 0,
  });

  ProductsState copyWith({
    List<Product>? products,
    bool? hasReachedMax,
    int? page,
  }) {
    return ProductsState(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
    );
  }
}

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsService _productsService;

  ProductsCubit(this._productsService) : super(ProductsState());

  Future<void> loadProducts() async {
    if (state.hasReachedMax) return;

    try {
      final result = await _productsService.fetchProducts(state.page);
      final newProducts = result['products'] as List<Product>;
      final total = result['total'];

      emit(state.copyWith(
        products: List.of(state.products)..addAll(newProducts),
        hasReachedMax: state.products.length >= total,
        page: state.page + 1,
      ));
    } catch (e) {
      emit(state.copyWith(hasReachedMax: true));
    }
  }
}