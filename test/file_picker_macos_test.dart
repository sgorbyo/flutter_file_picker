@TestOn('mac-os')
library;

import 'package:file_picker/src/file_picker.dart';
import 'package:file_picker/src/file_picker_macos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('forwards dialog purpose verbatim to open, directory and save panels',
      () async {
    final picker = FilePickerMacOS();
    final calls = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(picker.methodChannel, (call) async {
      calls.add(call);
      return null;
    });
    const title = 'Recover documents — "backup"\n(.igenbackup)';
    try {
      expect(await picker.pickFiles(dialogTitle: title), isNull);
      expect(await picker.getDirectoryPath(dialogTitle: title), isNull);
      expect(await picker.saveFile(dialogTitle: title), isNull);
      expect(calls.map((call) => call.method),
          ['pickFiles', 'getDirectoryPath', 'saveFile']);
      for (final call in calls) {
        expect(call.arguments['dialogTitle'], title);
      }
    } finally {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(picker.methodChannel, null);
    }
  });
  group('fileTypeToFileFilter()', () {
    test('should return the file filter', () {
      final picker = FilePickerMacOS();

      expect(
        picker.fileTypeToFileFilter(FileType.any, null),
        equals([]),
      );

      expect(
        picker.fileTypeToFileFilter(FileType.audio, null),
        equals(["aac", "midi", "mp3", "ogg", "wav"]),
      );

      expect(
        picker.fileTypeToFileFilter(FileType.image, null),
        equals(["bmp", "gif", "jpeg", "jpg", "png", "webp"]),
      );

      expect(
        picker.fileTypeToFileFilter(FileType.media, null),
        equals(
          [
            "avi",
            "flv",
            "m4v",
            "mkv",
            "mov",
            "mp4",
            "mpeg",
            "webm",
            "wmv",
            "bmp",
            "gif",
            "jpeg",
            "jpg",
            "png"
          ],
        ),
      );

      expect(
        picker.fileTypeToFileFilter(FileType.video, null),
        equals(
          ["avi", "flv", "mkv", "mov", "mp4", "m4v", "mpeg", "webm", "wmv"],
        ),
      );
    });

    test(
        'should return the file filter when given a list of custom file extensions',
        () {
      final picker = FilePickerMacOS();

      expect(
        picker.fileTypeToFileFilter(FileType.custom, ['dart']),
        equals(["dart"]),
      );

      expect(
        picker.fileTypeToFileFilter(FileType.custom, ['dart', 'html']),
        equals(["dart", "html"]),
      );
    });
  });

  group('escapeDialogTitle()', () {
    test('should escape backslashes in the title of the dialog', () {
      final picker = FilePickerMacOS();

      final escapedTitle = picker.escapeDialogTitle(
        'Please select files that contain a \\:',
      );

      expect(
        escapedTitle,
        equals(
          'Please select files that contain a \\\\:',
        ),
      );
    });

    test('should escape line breaks in the title of the dialog', () {
      final picker = FilePickerMacOS();

      final escapedTitle = picker.escapeDialogTitle(
        'Please continue reading\nafter the line break:',
      );

      expect(
        escapedTitle,
        equals(
          'Please continue reading\\\nafter the line break:',
        ),
      );
    });

    test('should escape double quotes in the title of the dialog', () {
      final picker = FilePickerMacOS();

      final escapedTitle = picker.escapeDialogTitle(
        'Please select a "quoted" file:',
      );

      expect(escapedTitle, equals('Please select a \\"quoted\\" file:'));
    });
  });

  group('escapeInitialDirectory()', () {
    late FilePickerMacOS picker;

    setUp(() {
      picker = FilePickerMacOS();
    });

    test('should return null when input is null', () {
      expect(picker.escapeInitialDirectory(null), isNull);
    });

    test('should remove ~/ from the beginning of the path', () {
      expect(
        picker.escapeInitialDirectory('~/Documents'),
        equals('Documents'),
      );
    });

    test('should remove single ~ from the beginning of the path', () {
      expect(
        picker.escapeInitialDirectory('~Documents'),
        equals('Documents'),
      );
    });

    test('should not modify path without tilde', () {
      expect(
        picker.escapeInitialDirectory('/Users/Documents'),
        equals('/Users/Documents'),
      );
    });

    test('should handle empty string', () {
      expect(
        picker.escapeInitialDirectory(''),
        equals(''),
      );
    });
  });
}
