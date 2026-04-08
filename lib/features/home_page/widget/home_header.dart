import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final int notifCount;

  const HomeHeader({Key? key, required this.userName, required this.notifCount}) : super(key: key);

  String _getAvatarLetter(String fullName) {
    if (fullName.trim().isEmpty) return "?";
    List<String> words = fullName.trim().split(" ");
    String lastName = words.last; // Lấy từ cuối cùng (tên chính)
    return lastName.isNotEmpty ? lastName[0].toUpperCase() : "?";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 40),
      decoration: const BoxDecoration(
        color: Color(0xFF1C51E6),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 24,
            child: Text(
              _getAvatarLetter(userName), 
              style: const TextStyle(
                color: Color(0xFF1C51E6),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Xin chào,", style: TextStyle(color: Colors.white70, fontSize: 14)),
                Text(userName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                child: const Icon(Icons.notifications_none, color: Colors.white),
              ),
              if (notifCount > 0)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: Text('$notifCount', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                )
            ],
          )
        ],
      ),
    );
  }
}