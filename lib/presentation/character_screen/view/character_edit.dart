import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pridesys_app/presentation/character_screen/controller/character_controller.dart';

class CharacterEditSheet extends StatelessWidget {
  final Map character;
  final HomeController controller = Get.find();

  CharacterEditSheet({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final updatedCharacter = controller.getCharacter(character);

    final nameCtrl = TextEditingController(text: updatedCharacter['name']);
    final statusCtrl = TextEditingController(text: updatedCharacter['status']);
    final speciesCtrl = TextEditingController(
      text: updatedCharacter['species'],
    );
    final typeCtrl = TextEditingController(text: updatedCharacter['type']);
    final genderCtrl = TextEditingController(text: updatedCharacter['gender']);
    final originCtrl = TextEditingController(
      text: updatedCharacter['origin']?['name'],
    );
    final locationCtrl = TextEditingController(
      text: updatedCharacter['location']?['name'],
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xff111827),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "Edit Character",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),

            const SizedBox(height: 16),

            buildField("Name", nameCtrl),
            buildField("Status", statusCtrl),
            buildField("Species", speciesCtrl),
            buildField("Type", typeCtrl),
            buildField("Gender", genderCtrl),
            buildField("Origin", originCtrl),
            buildField("Location", locationCtrl),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                controller.saveEdit(character['id'], {
                  "name": nameCtrl.text,
                  "status": statusCtrl.text,
                  "species": speciesCtrl.text,
                  "type": typeCtrl.text,
                  "gender": genderCtrl.text,

                  // 🔥 nested fix
                  "origin": {"name": originCtrl.text},
                  "location": {"name": locationCtrl.text},
                });

                Get.back();
              },
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildField(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: title,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: const Color(0xff1f2937),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
