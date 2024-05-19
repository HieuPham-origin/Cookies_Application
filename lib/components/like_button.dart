import 'package:flutter/material.dart';

class LikeButtonCustom extends StatelessWidget {
  final bool isLiked;
  final Function()? onTap;
  const LikeButtonCustom({
    super.key,
    required this.isLiked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.red : Colors.grey,
      ),
    );
  }
}
