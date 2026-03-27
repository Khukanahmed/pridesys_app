import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pridesys_app/presentation/character_screen/controller/character_controller.dart';

class FavoritesView extends StatelessWidget {
  final HomeController controller = Get.find();

  FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: Obx(() {
        final favoriteCharacters = controller.characters
            .where((c) => controller.favorites.contains(c['id']))
            .toList();

        if (favoriteCharacters.isEmpty) {
          return const Center(child: Text("No favorites yet ❤️"));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: favoriteCharacters.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final character = favoriteCharacters[index];

            return GestureDetector(
              onTap: () {
                // Navigate to details if needed
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xff1f2937),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    /// IMAGE
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: character['image'],
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    /// INFO
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Text(
                            character['name'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 6),

                          /// REMOVE FAVORITE BUTTON
                          IconButton(
                            icon: const Icon(Icons.favorite, color: Colors.red),
                            onPressed: () {
                              controller.toggleFavorite(character['id']);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
