import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:secured/secured_storage.dart';

@GenerateMocks([FlutterSecureStorage])
import 'secured_test.mocks.dart';

void main() {
  late MockFlutterSecureStorage mockStorage;
  late SecuredStorage securedStorage;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    securedStorage = SecuredStorage(storage: mockStorage);
  });

  const key = 'test_key';
  const value = 'test_value';

  group('SecuredStorage', () {
    test('write stores value', () async {
      when(
        mockStorage.write(
          key: key,
          value: value,
          aOptions: anyNamed('aOptions'),
          iOptions: anyNamed('iOptions'),
        ),
      ).thenAnswer((_) async {});

      await securedStorage.write(key: key, value: value);

      verify(
        mockStorage.write(
          key: key,
          value: value,
          aOptions: anyNamed('aOptions'),
          iOptions: anyNamed('iOptions'),
        ),
      ).called(1);
    });

    test('read returns stored value', () async {
      when(
        mockStorage.read(
          key: key,
          aOptions: anyNamed('aOptions'),
          iOptions: anyNamed('iOptions'),
        ),
      ).thenAnswer((_) async => value);

      final result = await securedStorage.read(key: key);

      expect(result, value);
    });

    test('read returns null when key does not exist', () async {
      when(
        mockStorage.read(
          key: key,
          aOptions: anyNamed('aOptions'),
          iOptions: anyNamed('iOptions'),
        ),
      ).thenAnswer((_) async => null);

      final result = await securedStorage.read(key: key);

      expect(result, isNull);
    });

    test('readAll returns all entries', () async {
      final entries = {key: value, 'other_key': 'other_value'};

      when(
        mockStorage.readAll(
          aOptions: anyNamed('aOptions'),
          iOptions: anyNamed('iOptions'),
        ),
      ).thenAnswer((_) async => entries);

      final result = await securedStorage.readAll();

      expect(result, entries);
    });

    test('containsKey returns true when key exists', () async {
      when(
        mockStorage.containsKey(
          key: key,
          aOptions: anyNamed('aOptions'),
          iOptions: anyNamed('iOptions'),
        ),
      ).thenAnswer((_) async => true);

      final result = await securedStorage.containsKey(key: key);

      expect(result, isTrue);
    });

    test('delete removes the key', () async {
      when(
        mockStorage.delete(
          key: key,
          aOptions: anyNamed('aOptions'),
          iOptions: anyNamed('iOptions'),
        ),
      ).thenAnswer((_) async {});

      await securedStorage.delete(key: key);

      verify(
        mockStorage.delete(
          key: key,
          aOptions: anyNamed('aOptions'),
          iOptions: anyNamed('iOptions'),
        ),
      ).called(1);
    });

    test('deleteAll clears all entries', () async {
      when(
        mockStorage.deleteAll(
          aOptions: anyNamed('aOptions'),
          iOptions: anyNamed('iOptions'),
        ),
      ).thenAnswer((_) async {});

      await securedStorage.deleteAll();

      verify(
        mockStorage.deleteAll(
          aOptions: anyNamed('aOptions'),
          iOptions: anyNamed('iOptions'),
        ),
      ).called(1);
    });
  });
}
