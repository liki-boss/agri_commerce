import 'package:agri_commerce/services/firebase_services.dart';
import 'package:agri_commerce/widgets/old_custom_action_bar.dart';
import 'package:agri_commerce/widgets/old_product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  final firebase_services _firebaseServices = firebase_services();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _firebaseServices.productsRef
                .where('category', isEqualTo: 'Fruits')
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }

              // Collection Data ready to display
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                // Display the data inside a list view
                return ListView(
                  padding: EdgeInsets.only(
                    top: 108.0,
                    bottom: 12.0,
                  ),
                  children: snapshot.data!.docs.map((document) {
                    return ProductCard(
                      title: document.get('sub-category'),
                      imageUrl: document.get('images')[0],
                      price: "\₹${document.get('price')}",
                      productId: document.id,
                    );
                  }).toList(),
                );
              }

              // Loading State
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
          CustomActionBar(
            title: "Fruits",
            hasBackArrrow: false,
          ),
        ],
      ),
    );
  }
}