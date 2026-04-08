import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharedpref/shared_pref_manager.dart';

@GenerateMocks([SharedPreferences])
import 'sharedpref_test.mocks.dart';

void main() {
  late MockSharedPreferences mockPrefs;
  late SharedPrefManager manager;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    manager = SharedPrefManager(mockPrefs);
  });

  const key = 'test_key';

  group('SharedPrefManager - write', () {
    test('setString delegates to SharedPreferences', () async {
      when(mockPrefs.setString(key, 'value')).thenAnswer((_) async => true);

      final result = await manager.setString(key, 'value');

      expect(result, isTrue);
      verify(mockPrefs.setString(key, 'value')).called(1);
    });

    test('setInt delegates to SharedPreferences', () async {
      when(mockPrefs.setInt(key, 42)).thenAnswer((_) async => true);

      final result = await manager.setInt(key, 42);

      expect(result, isTrue);
      verify(mockPrefs.setInt(key, 42)).called(1);
    });

    test('setDouble delegates to SharedPreferences', () async {
      when(mockPrefs.setDouble(key, 3.14)).thenAnswer((_) async => true);

      final result = await manager.setDouble(key, 3.14);

      expect(result, isTrue);
      verify(mockPrefs.setDouble(key, 3.14)).called(1);
    });

    test('setBool delegates to SharedPreferences', () async {
      when(mockPrefs.setBool(key, true)).thenAnswer((_) async => true);

      final result = await manager.setBool(key, value: true);

      expect(result, isTrue);
      verify(mockPrefs.setBool(key, true)).called(1);
    });

    test('setStringList delegates to SharedPreferences', () async {
      when(
        mockPrefs.setStringList(key, ['a', 'b']),
      ).thenAnswer((_) async => true);

      final result = await manager.setStringList(key, ['a', 'b']);

      expect(result, isTrue);
      verify(mockPrefs.setStringList(key, ['a', 'b'])).called(1);
    });
  });

  group('SharedPrefManager - read', () {
    test('getString returns stored string', () {
      when(mockPrefs.getString(key)).thenReturn('value');

      expect(manager.getString(key), 'value');
    });

    test('getString returns null when missing', () {
      when(mockPrefs.getString(key)).thenReturn(null);

      expect(manager.getString(key), isNull);
    });

    test('getInt returns stored int', () {
      when(mockPrefs.getInt(key)).thenReturn(42);

      expect(manager.getInt(key), 42);
    });

    test('getDouble returns stored double', () {
      when(mockPrefs.getDouble(key)).thenReturn(3.14);

      expect(manager.getDouble(key), 3.14);
    });

    test('getBool returns stored bool', () {
      when(mockPrefs.getBool(key)).thenReturn(true);

      expect(manager.getBool(key), isTrue);
    });

    test('getStringList returns stored list', () {
      when(mockPrefs.getStringList(key)).thenReturn(['a', 'b']);

      expect(manager.getStringList(key), ['a', 'b']);
    });
  });

  group('SharedPrefManager - existence', () {
    test('containsKey returns true when key exists', () {
      when(mockPrefs.containsKey(key)).thenReturn(true);

      expect(manager.containsKey(key), isTrue);
    });

    test('containsKey returns false when key missing', () {
      when(mockPrefs.containsKey(key)).thenReturn(false);

      expect(manager.containsKey(key), isFalse);
    });

    test('keys returns all stored keys', () {
      when(mockPrefs.getKeys()).thenReturn({key, 'other'});

      expect(manager.keys, containsAll([key, 'other']));
    });
  });

  group('SharedPrefManager - delete', () {
    test('remove deletes a key', () async {
      when(mockPrefs.remove(key)).thenAnswer((_) async => true);

      final result = await manager.remove(key);

      expect(result, isTrue);
      verify(mockPrefs.remove(key)).called(1);
    });

    test('clear wipes all entries', () async {
      when(mockPrefs.clear()).thenAnswer((_) async => true);

      final result = await manager.clear();

      expect(result, isTrue);
      verify(mockPrefs.clear()).called(1);
    });
  });
}
