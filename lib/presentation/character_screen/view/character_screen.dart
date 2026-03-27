import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pridesys_app/core/colors/app_colors.dart';
import 'package:pridesys_app/presentation/character_screen/controller/character_controller.dart';
import 'package:pridesys_app/presentation/character_screen/view/character_details.dart';
import 'package:pridesys_app/presentation/character_screen/widget/character_shimmer.dart';

class CharacterListScreen extends StatelessWidget {
  CharacterListScreen({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rick & Morty Characters',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                /// 🔍 SEARCH BAR
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: controller.search,
                    decoration: const InputDecoration(
                      hintText: "Search character...",
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// 🎯 FILTER ROW
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: const Text("Status"),
                            value: controller.selectedStatus.value.isEmpty
                                ? null
                                : controller.selectedStatus.value,
                            items: ["Alive", "Dead", "unknown"]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) => controller.setStatus(val ?? ''),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: const Text("Species"),
                            value: controller.selectedSpecies.value.isEmpty
                                ? null
                                : controller.selectedSpecies.value,
                            items: ["Human", "Alien"]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) =>
                                controller.setSpecies(val ?? ''),
                          ),
                        ),
                      ),
                    ),

                    /// 🔄 RESET BUTTON
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: controller.resetFilters,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.characters.isEmpty) {
                return shimmerGrid();
              }
              if (controller.characters.isEmpty) {
                return const Center(
                  child: Text(
                    'No Character Found',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                );
              }
              return NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!controller.isLoading.value &&
                      scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                    controller.fetchCharacters();
                  }
                  return true;
                },
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: controller.filteredCharacters.length,
                  itemBuilder: (context, index) {
                    if (index < controller.characters.length) {
                      final character = controller.filteredCharacters[index];

                      return Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(
                                () =>
                                    CharacterDetailsView(character: character),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primaryColor.withOpacity(0.5),
                                    AppColors.primaryColor,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: character['image'],
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          Container(color: Colors.grey[300]),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      character['name'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            '${character['status']} ',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,

                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
