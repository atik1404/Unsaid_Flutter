import 'package:common/common.dart';
import 'package:designsystem/designsystem.dart';

final class MoodModel {
  final MoodType name;
  final String icon;

  const MoodModel({
    required this.name,
    required this.icon,
  });
}

final moods = [
  const MoodModel(name: MoodType.all, icon: ""),
  const MoodModel(name: MoodType.neutral, icon: AppDrawables.icNeutral),
  const MoodModel(name: MoodType.angry, icon: AppDrawables.icAngry),
  const MoodModel(name: MoodType.love, icon: AppDrawables.icLove),
  const MoodModel(name: MoodType.happy, icon: AppDrawables.icHappy),
  const MoodModel(name: MoodType.sad, icon: AppDrawables.icSad),
  const MoodModel(name: MoodType.lonely, icon: AppDrawables.icLonely),
  const MoodModel(name: MoodType.excited, icon: AppDrawables.icExcited),
  const MoodModel(name: MoodType.confused, icon: AppDrawables.icConfused),
  const MoodModel(name: MoodType.dark, icon: AppDrawables.icDark),
];
