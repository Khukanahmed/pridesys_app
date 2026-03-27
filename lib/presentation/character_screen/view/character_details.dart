import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pridesys_app/core/colors/app_colors.dart';
import 'package:pridesys_app/presentation/character_screen/controller/character_controller.dart';
import 'package:pridesys_app/presentation/character_screen/view/character_edit.dart';
import 'package:pridesys_app/presentation/character_screen/widget/epiode_widget.dart';

class CharacterDetailsView extends StatelessWidget {
  final Map character;
  final HomeController controller = Get.find();

  CharacterDetailsView({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Get.back(),
        ),
        title: Obx(() {
          final updatedCharacter = controller.getCharacter(character);
          return Text(
            updatedCharacter['name'] ?? '',
            style: const TextStyle(color: Colors.white),
          );
        }),
        actions: [
          Obx(() {
            final updatedCharacter = controller.getCharacter(character);
            final isFav = controller.isFavorite(updatedCharacter['id']);

            return Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    Get.bottomSheet(
                      CharacterEditSheet(character: character),
                      isScrollControlled: true,
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : Colors.white,
                  ),
                  onPressed: () {
                    controller.toggleFavorite(updatedCharacter['id']);
                  },
                ),
              ],
            );
          }),
        ],
      ),

      /// 🔥 BODY REACTIVE
      body: SafeArea(
        child: Obx(() {
          final updatedCharacter = controller.getCharacter(character);

          return SingleChildScrollView(
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: updatedCharacter['image'] ?? '',
                  height: 320,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xff111827),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// NAME
                      Center(
                        child: Text(
                          updatedCharacter['name'] ?? '',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      /// STATUS
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: updatedCharacter['status'] == 'Alive'
                                    ? Colors.green
                                    : Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              updatedCharacter['status'] ?? '',
                              style: TextStyle(
                                color: updatedCharacter['status'] == 'Alive'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// INFO
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xff1f2937),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: [
                            infoRow("Species", updatedCharacter['species']),
                            infoRow(
                              "Type",
                              updatedCharacter['type'] == ""
                                  ? "Unknown"
                                  : updatedCharacter['type'],
                            ),
                            infoRow("Gender", updatedCharacter['gender']),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// ORIGIN
                      sectionTitle("ORIGIN"),
                      clickableTile(
                        updatedCharacter['origin']?['name'] ?? 'Unknown',
                      ),

                      const SizedBox(height: 20),

                      /// LOCATION
                      sectionTitle("LAST KNOWN LOCATION"),
                      clickableTile(
                        updatedCharacter['location']?['name'] ?? 'Unknown',
                      ),

                      const SizedBox(height: 20),

                      /// EPISODES
                      sectionTitle("EPISODES"),
                      clickableTile(
                        "${updatedCharacter['episode']?.length ?? 0} Episodes",
                        onTap: () {
                          Get.to(
                            () => EpisodeListView(
                              episodes: updatedCharacter['episode'],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 12,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget infoRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          Flexible(
            child: Text(
              value.toString(),
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget clickableTile(String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xff1f2937),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.public, color: Colors.green, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(title, style: const TextStyle(color: Colors.white)),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.white54,
            ),
          ],
        ),
      ),
    );
  }
}
