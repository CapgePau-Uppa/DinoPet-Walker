import 'package:dinopet_walker/controllers/DinoController.dart';
import 'package:dinopet_walker/controllers/SelectionController.dart';
import 'package:dinopet_walker/data/dinoData.dart';
import 'package:dinopet_walker/models/LifeStage.dart';
import 'package:dinopet_walker/pages/MainScreen.dart';
import 'package:dinopet_walker/widgets/common/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/dino/DinoSelectorItem.dart';

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SelectionController(),
      child: const _SelectionBody(),
    );
  }
}

class _SelectionBody extends StatelessWidget {
  const _SelectionBody({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SelectionController>();
    final selectedDinoType = controller.selectedDinoType;
    
    return Scaffold(
      appBar: Myappbar(title: "Choose your dino", showBackButton: false),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: Image.asset(
                selectedDinoType.getAsset(LifeStage.baby, 1),
                width: 250,
              ),
            ),
          ),

          Expanded(
            flex: 4,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: selectedDinoType.outColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  Text(
                    selectedDinoType.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004D40),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    selectedDinoType.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF004D40),
                      height: 1.4,
                    ),
                  ),
                  const Spacer(),

                  SizedBox(
                    height: 140,
                    child: Center(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: availableDinos.length,
                        itemBuilder: (context, index) {
                          return DinoSelectorItem(
                            dinoType: availableDinos[index],
                            isSelected: controller.getSelectedIndex == index,
                            onTap: () => controller.selectDino(index),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        final newDino = controller.createSelectedDinoPet();
                        final dinoController = context.read<DinoController>();
                        dinoController.initializeDinoPet(newDino);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004D40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Valider",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
