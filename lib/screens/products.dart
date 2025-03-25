import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/products_cubit.dart';
import '../blocs/cart_cubic.dart';
import '../models/product_model.dart';

class ProductsPage extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  ProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsCubit = context.read<ProductsCubit>();
    final cartCubit = context.read<CartCubit>();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        productsCubit.loadProducts();
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Catalogue',
          style: TextStyle(
            color: Colors.black, 
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.pink[600], size: 28),
                onPressed: () => Navigator.pushNamed(context, '/cart'),
              ),
              Positioned(
                right: 5,
                top: 5,
                child: BlocBuilder<CartCubit, CartState>(
                  builder: (context, cartState) {
                    return cartState.items.isNotEmpty
                        ? Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.pink[400],
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${cartState.items.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state.products.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.pink),
            );
          }
          return GridView.builder(
            controller: _scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6, // Reduced to prevent overflow
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            padding: const EdgeInsets.all(8),
            itemCount: state.hasReachedMax
                ? state.products.length
                : state.products.length + 1,
            itemBuilder: (context, index) {
              if (index >= state.products.length) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.pink),
                );
              }

              final product = state.products[index];

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Image Section
                          AspectRatio(
                            aspectRatio: 1.5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                product.thumbnail,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.pink,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          
                          // Product Title
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              product.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          
                          // Brand
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              product.brand,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          
                          // Price Section
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '₹${product.finalPrice.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        if (product.discountPercentage > 0)
                                          Text(
                                            '₹${product.price.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              decoration: TextDecoration.lineThrough,
                                              fontSize: 10,
                                            ),
                                          ),
                                      ],
                                    ),
                                    if (product.discountPercentage > 0)
                                      Text(
                                        '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          // Cart Action
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: BlocBuilder<CartCubit, CartState>(
                              builder: (context, cartState) {
                                final productQuantity = cartCubit.getProductQuantity(product.id);

                                return productQuantity > 0
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            constraints: const BoxConstraints(maxWidth: 24, maxHeight: 24),
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(Icons.remove_circle, color: Colors.pink, size: 20),
                                            onPressed: () {
                                              cartCubit.removeFromCart(product);
                                            },
                                          ),
                                          Text(
                                            '$productQuantity',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          IconButton(
                                            constraints: const BoxConstraints(maxWidth: 24, maxHeight: 24),
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(Icons.add_circle, color: Colors.pink, size: 20),
                                            onPressed: () {
                                              cartCubit.addToCart(product);
                                            },
                                          ),
                                        ],
                                      )
                                    : SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            cartCubit.addToCart(product);
                                            _showCustomSnackBar(context, product);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.pink[400],
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8,
                                            ),
                                          ),
                                          child: const Text(
                                            'Add to Cart',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Custom SnackBar method remains the same
  void _showCustomSnackBar(BuildContext context, Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.shopping_cart, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${product.title} added to cart',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              child: const Text(
                'View Cart',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.pink[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
      ),
    );
  }
}