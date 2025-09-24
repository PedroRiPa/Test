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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.03), 
      ),
      child: Padding(
        
        padding: EdgeInsets.all(screenWidth * 0.04), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                  
                  size: screenWidth * 0.055, 
                ),
                SizedBox(width: screenWidth * 0.025), 
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
            Divider(
              height: screenHeight * 0.03, 
              thickness: 1, 
            ),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.5, 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
