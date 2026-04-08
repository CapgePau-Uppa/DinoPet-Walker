import 'package:dinopet_walker/controllers/dino_controller.dart';
import 'package:dinopet_walker/controllers/selection_controller.dart';
import 'package:dinopet_walker/data/dino_data.dart';
import 'package:dinopet_walker/models/life_stage.dart';
import 'package:dinopet_walker/pages/main_screen.dart';
import 'package:dinopet_walker/widgets/common/my_appbar.dart';
import 'package:dinopet_walker/widgets/common/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/dino/dino_selector_item.dart';

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
  const _SelectionBody();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SelectionController>();
    final selectedDinoType = controller.selectedDinoType;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true, 
      appBar: Myappbar(title: "Choose your dino", showBackButton: false),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(5),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.82, 
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Image.asset(
                      selectedDinoType.getAsset(LifeStage.baby, 1),
                      height: screenHeight * 0.25,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
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
                          height: screenHeight * 0.18,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
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
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: PrimaryButton(
                            label: "Valider",
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
