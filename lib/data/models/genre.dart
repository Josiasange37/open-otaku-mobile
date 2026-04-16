/// Available anime genres.
abstract final class Genre {
  static const String action = 'Action';
  static const String adventure = 'Adventure';
  static const String comedy = 'Comedy';
  static const String drama = 'Drama';
  static const String fantasy = 'Fantasy';
  static const String horror = 'Horror';
  static const String mystery = 'Mystery';
  static const String romance = 'Romance';
  static const String sciFi = 'Sci-Fi';
  static const String sliceOfLife = 'Slice of Life';
  static const String sports = 'Sports';
  static const String supernatural = 'Supernatural';
  static const String thriller = 'Thriller';
  static const String isekai = 'Isekai';
  static const String shounen = 'Shounen';
  static const String seinen = 'Seinen';
  static const String mecha = 'Mecha';
  static const String music = 'Music';

  static const List<String> all = [
    action, adventure, comedy, drama, fantasy, horror,
    mystery, romance, sciFi, sliceOfLife, sports,
    supernatural, thriller, isekai, shounen, seinen,
    mecha, music,
  ];
}
