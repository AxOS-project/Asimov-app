import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';

import '../../core/rust/bridge.dart';
import '../widget/discover_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool refreshing = false;

  Future<void> refresh() async {
    setState(() {
      refreshing = true;
    });
    await announce();
    await Future.delayed(const Duration(seconds: 4));
    setState(() {
      refreshing = false;
    });
  }

  List<File> selectedFiles = [];
  int selectedFileSize = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              SizedBox(
                height: kToolbarHeight,
                child: Row(
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(allowMultiple: true);

                          if (result != null) {
                            setState(() {
                              selectedFiles = result.paths
                                  .map((path) => File(path!))
                                  .toList();
                              for (var element in selectedFiles) {
                                selectedFileSize += element.lengthSync();
                              }
                            });
                          } else {
                            // User canceled the picker
                          }
                        },
                        child: const Text("Send File")),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          String? selectedDirectory =
                              await FilePicker.platform.getDirectoryPath();

                          if (selectedDirectory == null) {
                            // User canceled the picker
                          }
                        },
                        child: const Text("Send Folder")),
                  ],
                ),
              ),
              SizedBox(
                height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Document: ${selectedFiles.length} Size: ${filesize(selectedFileSize)}'),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        for (final file in selectedFiles)
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  borderRadius: BorderRadius.circular(12)),
                              height: 40,
                              width: 40,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.file_present),
                                  Text(
                                    file.path.split('/').last,
                                    style: const TextStyle(fontSize: 8),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.info_outline),
                            label: const Text("Details")),
                        const SizedBox(
                          width: 8,
                        ),
                        FilledButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.add),
                          label: const Text("Add"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    const Text(
                      "Discover",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    IconButton(
                        style: const ButtonStyle(
                          iconSize: WidgetStatePropertyAll(20),
                          padding: WidgetStatePropertyAll(EdgeInsets.all(8)),
                          minimumSize: WidgetStatePropertyAll(Size(16, 16)),
                          maximumSize: WidgetStatePropertyAll(Size(36, 36)),
                        ),
                        onPressed: () {
                          refresh();
                        },
                        icon: const Icon(
                          Icons.sync,
                        ))
                  ],
                ),
              ),
              if (refreshing)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: LinearProgressIndicator(),
                ),
              const Expanded(child: DiscoverWidget()),
            ],
          ),
        ),
      ),
    );
  }
}
