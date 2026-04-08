import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String studentId;
  final bool isLoading;

  const ProfileHeader({
    Key? key,
    required this.name,
    required this.studentId,
    this.isLoading = false,
  }) : super(key: key);

  String _getAvatarLetter(String fullName) {
    if (fullName.trim().isEmpty) return "?";
    List<String> words = fullName.trim().split(" ");
    String lastName = words.last;
    return lastName.isNotEmpty ? lastName[0].toUpperCase() : "?";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 40),
      decoration: const BoxDecoration(
        color: Color(0xFF1C51E6),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
            ),
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(isLoading ? 0.3 : 0.2),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white70)
                  : Text(
                      _getAvatarLetter(name),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          if (isLoading)
            Container(
              width: 120,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            )
          else
            Text(
              name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          const SizedBox(height: 4),
          if (isLoading)
            Container(
              width: 80,
              height: 14,
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            )
          else
            Text(
              "MSSV: $studentId",
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}