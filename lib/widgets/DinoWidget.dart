import 'package:dinopet_walker/models/DinoStage.dart';
import 'package:flutter/material.dart';

class DinoWidget extends StatefulWidget {
  final int userLevel;
  const DinoWidget({Key? key, required this.userLevel}) : super(key: key);

  @override
  State<DinoWidget> createState() => _DinoWidgetState();
}

class _DinoWidgetState extends State<DinoWidget> {
  late DinoStage _currentStage;

  @override
  void initState() {
    super.initState();
    _currentStage = DinoStage.getDinoStageFromLevel(widget.userLevel);
  }

  @override
  void didUpdateWidget(DinoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userLevel != widget.userLevel) {
      final newStage = DinoStage.getDinoStageFromLevel(widget.userLevel);
      if (newStage != _currentStage) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showEvolutionDialog(newStage);
        });
      }
    }
  }

  void _showEvolutionDialog(DinoStage newStage) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Evolution !",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Ton dino va évoluer en',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              Text(
                newStage.label,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() => _currentStage = newStage);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text('Voir', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          height: _currentStage.height,
          child: AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            child: Image.asset(
              _currentStage.imagePath,
              key: ValueKey<int>(_currentStage.id),
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _currentStage.label,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}
