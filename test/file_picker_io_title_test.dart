import 'package:file_picker/src/file_picker_io.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('IO forwards purpose and clears it for untitled requests', () async {
    const channel = MethodChannel(
        'miguelruivo.flutter.plugins.filepicker', JSONMethodCodec());
    final calls = <MethodCall>[];
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return null;
    });
    try {
      final picker = FilePickerIO();
      await picker.pickFiles(dialogTitle: 'Choose backup (.igenbackup)');
      await picker.pickFiles(
          dialogTitle: 'Choose recovery kit (.igenrecovery)');
      await picker.pickFiles();
      await picker.getDirectoryPath(dialogTitle: 'Choose destination');
      expect(calls.map((c) => c.arguments['dialogTitle']), [
        'Choose backup (.igenbackup)',
        'Choose recovery kit (.igenrecovery)',
        null,
        'Choose destination'
      ]);
    } finally {
      messenger.setMockMethodCallHandler(channel, null);
    }
  });
}
