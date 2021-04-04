import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth_provider.dart';
import 'package:shop/providers/cart_provider.dart';
import 'package:shop/providers/orders_provider.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/screens/auth_screen.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/screens/orders_screen.dart';
import 'package:shop/screens/product_detail_screen.dart';
import 'package:shop/screens/products_screen.dart';
import 'package:shop/screens/splash_screen.dart';
import 'package:shop/screens/user_products_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
            create: (context) => ProductsProvider(),
            update: (ctx, auth, previous) {
              previous.userId = auth.userId;
              previous.authToken = auth.token;
              return previous;
            }),
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
            update: (context, auth, previous) => OrdersProvider(auth.token, auth.userId, previous == null ? [] : previous.orders)),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, child) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(primarySwatch: Colors.purple, accentColor: Colors.deepOrange, fontFamily: 'Lato'),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, authResult) => authResult.connectionState == ConnectionState.waiting ? SplashScreen() : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
