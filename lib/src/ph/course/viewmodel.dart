import 'dart:io';

import 'package:http/http.dart';
import 'package:flutter/foundation.dart';

class MyViewModel extends ChangeNotifier {
  double _progress = 0;
  double _downloadedProgress = 0;
  get downloadProgress => _progress;
  get downloadedProgress => _downloadedProgress;

  void startDownloading(String url, Directory dir, String filename) async {
    _progress = null;
    notifyListeners();

    final request = Request('GET', Uri.parse(url));
    final StreamedResponse response = await Client().send(request);

    final contentLength = response.contentLength;
    // final contentLength = double.parse(response.headers['x-decompressed-content-length']);

    _progress = 0;
    notifyListeners();

    List<int> bytes = [];

    final file = await _getFile(filename, dir);
    response.stream.listen(
      (List<int> newBytes) {
        bytes.addAll(newBytes);
        final downloadedLength = bytes.length;
        _progress = downloadedLength / contentLength;
        _downloadedProgress = downloadedLength / contentLength;
        notifyListeners();
      },
      onDone: () async {
        _progress = 0;
        _downloadedProgress = 2;
        notifyListeners();
        print("====================");
        print(bytes);
        print("====================");
        await file.writeAsBytes(bytes);
      },
      onError: (e) {
        print(e);
      },
      cancelOnError: true,
    );
  }

  Future<File> _getFile(String filename, Directory dir) async {
    return File("${dir.path}/$filename");
  }
}
