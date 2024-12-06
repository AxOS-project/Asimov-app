import 'dart:io';

import 'package:innosetup/innosetup.dart';
import 'package:version/version.dart';

void main() {
  InnoSetup(
    app: InnoSetupApp(
      name: 'asimov',
      version: Version.parse('0.1.0'),
      publisher: 'Ardox',
      urls: InnoSetupAppUrls(
        homeUrl: Uri.parse('https://github.com/axos-project/asimov-app'),
      ),
    ),
    files: InnoSetupFiles(
      executable: File('build/windows/x64/runner/Release/Asimov.exe'),
      location: Directory('build/windows/x64/runner/Release/'),
    ),
    name: const InnoSetupName('asimov-setup'),
    location: InnoSetupInstallerDirectory(
      Directory('build/windows'),
    ),
    icon: InnoSetupIcon(
      File('assets/icon/logo.ico'),
    ),
  ).make();
}
