part of '../../main.dart';

class TemplateData {
  const TemplateData({
    required this.title,
    required this.category,
    required this.rating,
    required this.creator,
    required this.duration,
    required this.price,
    required this.color,
    required this.secondaryColor,
    required this.overlayText,
  });

  final String title;
  final String category;
  final String rating;
  final String creator;
  final String duration;
  final String price;
  final Color color;
  final Color secondaryColor;
  final String overlayText;
}

class CollectionData {
  const CollectionData({
    required this.title,
    required this.count,
    required this.color,
    required this.accent,
    required this.icon,
  });

  final String title;
  final String count;
  final Color color;
  final Color accent;
  final IconData icon;
}

class LikedTemplatesManager {
  static final ValueNotifier<List<TemplateData>> likedTemplatesNotifier =
      ValueNotifier<List<TemplateData>>([]);

  static bool isLiked(TemplateData template) {
    return likedTemplatesNotifier.value.any((t) => t.title == template.title);
  }

  static void toggleLike(TemplateData template) {
    final list = List<TemplateData>.from(likedTemplatesNotifier.value);
    final index = list.indexWhere((t) => t.title == template.title);
    if (index >= 0) {
      list.removeAt(index);
    } else {
      list.add(template);
    }
    likedTemplatesNotifier.value = list;
  }
}
