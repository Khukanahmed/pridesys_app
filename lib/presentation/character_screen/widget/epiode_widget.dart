import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pridesys_app/core/colors/app_colors.dart';

class EpisodeListView extends StatelessWidget {
  final List episodes;

  const EpisodeListView({super.key, required this.episodes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Episodes", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView.builder(
        itemCount: episodes.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.tv),
            title: Text("Episode ${index + 1}"),
            subtitle: Text(episodes[index]),
          );
        },
      ),
    );
  }
}
