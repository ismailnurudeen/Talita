import 'package:hive/hive.dart';
import 'movie.dart';

// part 'bookmark.g.dart';
@HiveType()
class Bookmark {
  @HiveField(0)
  String date;
  @HiveField(1)
  Movie item;
}
