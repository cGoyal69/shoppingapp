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
    final existingProductIndex = state.items.indexWhere((p) => p.id == product.id);

    if (existingProductIndex != -1) {
      final updatedItems = List<Product>.from(state.items);
      if (updatedItems[existingProductIndex].quantity > 1) {
        updatedItems[existingProductIndex] = updatedItems[existingProductIndex].copyWith(
          quantity: updatedItems[existingProductIndex].quantity - 1,
        );
      } else {
        updatedItems.removeAt(existingProductIndex);
      }
      emit(CartState(items: updatedItems));
    }
  }

  /// **Returns the quantity of a product in the cart**
  int getProductQuantity(int productId) {
    final product = state.items.firstWhere(
      (p) => p.id == productId,
      orElse: () => Product(
        id: -1, title: '', price: 0, discountPercentage: 0, thumbnail: '', brand: '',
      ),
    );
    return product.id == -1 ? 0 : product.quantity;
  }
}

/// **Extension method for copying `Product` with a modified quantity**
extension ProductCopyWith on Product {
  Product copyWith({int? quantity}) {
    return Product(
      id: id,
      title: title,
      price: price,
      discountPercentage: discountPercentage,
      thumbnail: thumbnail,
      quantity: quantity ?? this.quantity,
      brand: brand,
    );
  }
}