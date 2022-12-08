import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class PdfApi {
  static Future<File> saveTicket(
      {required String name, required Document pdf}) async {
    final bytes = await pdf.save();
    final dir =
        await getExternalStorageDirectories(type: StorageDirectory.documents);
    final path = (dir!.length > 1) ? dir[1].path : dir[0].path;
    final file = File('$path/$name');

    await file.writeAsBytes(bytes);
    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }
}

class Utils {
  static formatPrice(double price) => "\$ ${price.toStringAsFixed(2)}";
  static formatDate(DateTime date) => "${date.day}-${date.month}-${date.year}";
}
