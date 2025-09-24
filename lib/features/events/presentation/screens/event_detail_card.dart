import 'package:flutter/material.dart';

class EventDetailCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const EventDetailCard({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor, size: 22),
                const SizedBox(width: 10),
                Expanded( 
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 1),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5), 
            ),
          ],
        ),
      ),
    );
  }
}