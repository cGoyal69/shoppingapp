import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product_model.dart';

class CartState {
  final List<Product> items;

  CartState({this.items = const []});

  double get totalPrice => items.fold(
      0, (total, product) => total + (product.finalPrice * product.quantity));
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState());

  void addToCart(Product product) {
    final existingProductIndex = state.items.indexWhere((p) => p.id == product.id);

    if (existingProductIndex != -1) {
      final updatedItems = List<Product>.from(state.items);
      updatedItems[existingProductIndex] = updatedItems[existingProductIndex].copyWith(
        quantity: updatedItems[existingProductIndex].quantity + 1,
      );
      emit(CartState(items: updatedItems));
    } else {
      emit(CartState(items: [...state.items, product.copyWith(quantity: 1)]));
    }
  }

  void removeFromCart(Product product) {
    final updatedItems = List<Product>.from(state.items)
      ..removeWhere((p) => p.id == product.id);
    emit(CartState(items: updatedItems));
  }
}

// Extension method to create a copy of Product with optional quantity update
extension ProductCopyWith on Product {
  Product copyWith({int? quantity}) {
    return Product(
      id: id,
      title: title,
      price: price,
      discountPercentage: discountPercentage,
      thumbnail: thumbnail,
      quantity: quantity ?? this.quantity,
      brand: brand
    );
  }
}