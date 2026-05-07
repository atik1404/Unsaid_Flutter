import 'package:flutter/material.dart';

class ProfileSummary extends StatelessWidget {
  final String name;
  final String avatar;
  const ProfileSummary({super.key, required this.name, required this.avatar});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildAvatar(),
        const SizedBox(width: 8),
        Text(name),
      ],
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 24,
      backgroundImage: NetworkImage(avatar),
    );
  }

  Widget _buildName() {
    return Text(
      name,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}
