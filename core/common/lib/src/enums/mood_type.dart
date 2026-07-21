enum MoodType {
  all,
  neutral,
  angry,
  love,
  sad,
  happy,
  lonely,
  excited,
  confused,
  dark,
}

extension MoodTypeX on MoodType {
  static MoodType? fromString(String value) {
    try {
      return MoodType.values.firstWhere(
        (e) => e.name.toUpperCase() == value.toUpperCase(),
      );
    } catch (e) {
      return null;
    }
  }
}
