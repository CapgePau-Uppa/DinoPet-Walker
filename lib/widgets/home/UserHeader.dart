import 'package:flutter/material.dart';

class UserHeader extends StatelessWidget {
  final String username;
  final int userLevel;
  final int streak;

  const UserHeader({
    super.key,
    required this.username,
    required this.userLevel,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_buildLeftContainer(), _buildRightContainer()],
      ),
    );
  }

  Widget _buildLeftContainer() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black.withOpacity(0.05)),
          ),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(
                    255,
                    138,
                    248,
                    164,
                  ).withOpacity(0.8),
                  blurRadius: 5,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Image.asset("assets/images/dino_vert_bebe.png"),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          username,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF007984),
          ),
        ),
      ],
    );
  }

  Widget _buildRightContainer() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFEDFFEA),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(
                  255,
                  138,
                  248,
                  164,
                ).withOpacity(0.8),
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.black.withOpacity(0.05)),
          ),
          child: Text(
            'Niveau $userLevel',
            style: TextStyle(
              color: const Color(0xFF007984),
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(width: 15),
        Container(
          width: 55,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFEDFFEA),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(
                  255,
                  138,
                  248,
                  164,
                ).withOpacity(0.8),
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.black.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              Text(
                '$streak',
                style: const TextStyle(
                  color: Color(0xFF007984),
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 4),
              Image.asset("assets/icons/fire.png", height: 18),
            ],
          ),
        ),
      ],
    );
  }
}
