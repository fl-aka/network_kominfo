import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:network_kominfo/model/dataset.dart';
import 'package:network_kominfo/widgetsutils/toindo.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:network_kominfo/dpdf/pdf_api.dart';

class PdfInvoiceApi {
  //************************************************GENERATE TICKET***************************************************//
  static Future<File> generateTicket(DatasetPrint dataset) async {
    final pdf = pw.Document();
    final font = await rootBundle.load("assets/fonts/OpenSans.ttf");
    final ttf = pw.Font.ttf(font);
    pw.Widget title = await buildTitle(ttf);
    bool selesai = false;
    String permasalahan = "";
    String penanganan = "";
    List<dynamic>? power;
    if (dataset.getPermasalahan != "") {
      power = jsonDecode(dataset.getPermasalahan!);

      debugPrint(power.toString());
      for (int i = 0; i < power!.length; i++) {
        permasalahan += "${power[i]["Permasalahan"]}, ";
        if (power[i]["status"] == "true") {
          penanganan += "${power[i]["Penanganan"]}, ";
        }
      }
    }

    if (dataset.getTglsls != "") {
      selesai = true;
    }

    pdf.addPage(pw.Page(
        margin:
            const pw.EdgeInsets.only(top: 20, left: 40, right: 40, bottom: 20),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                title,
                pw.SizedBox(height: 0.8 * PdfPageFormat.cm),
                buildPetugasList(
                    dataset.getPetugas1!, dataset.getPetugas2!, ttf),
                pw.SizedBox(height: 0.25 * PdfPageFormat.cm),
                buildPelapor(
                    dataset.getNamaPelapor!, dataset.getInstansi!, ttf),
                pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
                buildInBox("Isi Ticket", dataset.getDeskripsi!, ttf),
                pw.SizedBox(height: 0.25 * PdfPageFormat.cm),
                buildTindakLanjut(dataset.getTindakLanjut!),
                pw.SizedBox(height: 0.25 * PdfPageFormat.cm),
                oneLine("Tanggal", dataset.getTanggal!),
                pw.SizedBox(height: 0.25 * PdfPageFormat.cm),
                buildInBox("Permasalahan", permasalahan, ttf),
                pw.SizedBox(height: 0.25 * PdfPageFormat.cm),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                    children: [
                      pw.Container(
                        width: 150,
                        child: pw.Text("Status Ticket",
                            style: const pw.TextStyle(fontSize: 11)),
                      ),
                      pw.Container(
                          width: 300,
                          child: pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.Checkbox(name: "Selesai", value: selesai),
                                pw.Padding(
                                    padding: const pw.EdgeInsets.only(left: 5),
                                    child: pw.Text("Selesai",
                                        style:
                                            const pw.TextStyle(fontSize: 11))),
                              ]))
                    ]),
                pw.SizedBox(height: 0.25 * PdfPageFormat.cm),
                oneLine("Tanggal", dataset.getTglsls!),
                pw.SizedBox(height: 0.25 * PdfPageFormat.cm),
                buildInBox("Langkah Penanganan", penanganan, ttf, tinggi: 80),
                pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 7),
                  child: pw.Text("Petugas yang menagani",
                      style: const pw.TextStyle(fontSize: 11)),
                ),
                pw.SizedBox(height: 0.125 * PdfPageFormat.cm),
                oneLine("Nama", dataset.getPetugas1!),
                pw.SizedBox(height: 0.065 * PdfPageFormat.cm),
                oneLine("Tanggal Selesai", dataset.getTglsls!),
                ttd(),
                pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 7),
                  child: pw.Text("Dinyatakan selesai oleh",
                      style: const pw.TextStyle(fontSize: 11)),
                ),
                pw.SizedBox(height: 0.125 * PdfPageFormat.cm),
                oneLine("Nama", ""),
                pw.SizedBox(height: 0.065 * PdfPageFormat.cm),
                oneLine("NIP", ""),
                pw.SizedBox(height: 0.065 * PdfPageFormat.cm),
                oneLine("Jabatan", ""),
                ttd(),
                pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
                pw.Container(width: 600, height: 1, color: PdfColors.black)
              ]);
        }));
    return PdfApi.saveTicket(
        name: 'Generate Ticket ${dataset.getKodePrint}.pdf', pdf: pdf);
  }

  static Future<pw.Widget> buildTitle(pw.Font ttf) async {
    final image = pw.MemoryImage(
        (await rootBundle.load("assets/img/l_komban.png"))
            .buffer
            .asUint8List());
    final String tahun = DateTime.now().year.toString();
    return pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Image(image, height: 30),
      pw.Spacer(),
      pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
        pw.Text("Formulir Penanganan Ticket",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Row(children: [
          pw.Text("Nomor: INF/HELPDESK/"),
          pw.SizedBox(width: 50),
          pw.Text('/$tahun')
        ]),
      ]),
    ]);
  }

  static pw.Widget buildInBox(String label, String data, pw.Font ttf,
      {double tinggi = 65}) {
    return pw
        .Row(mainAxisAlignment: pw.MainAxisAlignment.spaceAround, children: [
      pw.Container(
          padding: const pw.EdgeInsets.only(left: 7),
          width: 100,
          height: 80,
          child: pw.Text(label, style: pw.TextStyle(font: ttf, fontSize: 11))),
      pw.Wrap(children: [
        pw.Padding(
            padding: const pw.EdgeInsets.only(right: 50),
            child: pw.Text(":", style: pw.TextStyle(font: ttf, fontSize: 11))),
        pw.Container(
            padding: const pw.EdgeInsets.all(3),
            decoration: pw.BoxDecoration(border: pw.Border.all()),
            width: 320,
            height: tinggi,
            child: pw.Text(data, style: pw.TextStyle(font: ttf, fontSize: 11)))
      ]),
    ]);
  }

  static pw.Widget buildPetugasList(
      String petugas, String petugas2, pw.Font ttf) {
    return pw
        .Row(mainAxisAlignment: pw.MainAxisAlignment.spaceAround, children: [
      pw.Container(
        width: 150,
        child: pw.Text("Nama Petugas",
            style: pw.TextStyle(fontSize: 10, font: ttf)),
      ),
      pw.Container(
          width: 300,
          child: pw.Column(children: [
            pw.Row(children: [
              pw.Checkbox(value: true, name: "Petugas1"),
              pw.SizedBox(width: 5),
              pw.Text(petugas, style: pw.TextStyle(fontSize: 11, font: ttf)),
            ]),
            if (petugas2 != "") pw.SizedBox(height: 0.125 * PdfPageFormat.cm),
            if (petugas2 != "")
              pw.Row(children: [
                pw.Checkbox(value: true, name: "Petugas2"),
                pw.SizedBox(width: 5),
                pw.Text(petugas2, style: pw.TextStyle(fontSize: 11, font: ttf)),
              ]),
          ]))
    ]);
  }

  static pw.Widget buildPelapor(String pelapor, String instansi, pw.Font ttf) {
    return pw.Column(children: [
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceAround, children: [
        pw.Container(
          width: 150,
          child: pw.Text("Nama Pelapor",
              style: pw.TextStyle(fontSize: 10, font: ttf)),
        ),
        pw.Container(
          width: 300,
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(pelapor, style: pw.TextStyle(fontSize: 10, font: ttf)),
                pw.Container(height: 1, width: 200, color: PdfColors.black),
              ]),
        )
      ]),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceAround, children: [
        pw.Container(
            width: 150,
            child: pw.Text("Satuan Kerja",
                style: pw.TextStyle(fontSize: 10, font: ttf))),
        pw.Container(
            width: 300,
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(instansi,
                      style: pw.TextStyle(fontSize: 10, font: ttf)),
                  pw.Container(height: 1, width: 200, color: PdfColors.black),
                ])),
      ]),
    ]);
  }

  static pw.Widget oneLine(String label, String data) {
    return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          pw.Container(
              padding: const pw.EdgeInsets.only(left: 7),
              width: 100,
              child: pw.Text(label, style: const pw.TextStyle(fontSize: 11))),
          pw.Padding(
              padding: const pw.EdgeInsets.only(right: 50),
              child: pw.Text(":", style: const pw.TextStyle(fontSize: 11))),
          pw.Container(
            width: 300,
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text((data == "") ? "Kosong" : data,
                      style: pw.TextStyle(
                          fontSize: 11,
                          color: (data == "")
                              ? PdfColors.white
                              : PdfColors.black)),
                  pw.Container(height: 1, width: 200, color: PdfColors.black),
                ]),
          )
        ]);
  }

  static pw.Widget ttd() {
    return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          pw.Container(
              width: 85,
              child: pw.Text("Tanda Tangan",
                  style: const pw.TextStyle(fontSize: 11))),
          pw.Padding(
              padding: const pw.EdgeInsets.only(right: 35),
              child: pw.Text(":", style: const pw.TextStyle(fontSize: 11))),
          pw.Container(
            width: 300,
            height: 60,
            child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(height: 1, width: 200, color: PdfColors.black),
                ]),
          )
        ]);
  }

  static pw.Widget buildTindakLanjut(String data) {
    bool _telCbx = false, _remCbx = false, _onsCbx = false;
    List<String>? cek = [];
    int last = 0;
    for (int i = 0; i < data.length; i++) {
      if (data[i] == '|') {
        if (last != 0) last++;
        cek.add(data.substring(last, i));
        last = i;
      }
    }
    for (int i = 0; i < cek.length; i++) {
      if (cek[i] == "On Site") {
        _onsCbx = true;
      }
      if (cek[i] == "Telepon") {
        _telCbx = true;
      }
      if (cek[i] == "Remote") {
        _remCbx = true;
      }
    }
    return pw
        .Row(mainAxisAlignment: pw.MainAxisAlignment.spaceAround, children: [
      pw.Container(
        width: 150,
        child:
            pw.Text("Tindak Lanjut", style: const pw.TextStyle(fontSize: 11)),
      ),
      pw.Container(
          width: 300,
          child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                pw.Checkbox(name: "On Site", value: _onsCbx),
                pw.Text("On Site", style: const pw.TextStyle(fontSize: 11)),
                pw.Checkbox(name: "Via Telepon", value: _telCbx),
                pw.Text("Via Telepon", style: const pw.TextStyle(fontSize: 11)),
                pw.Checkbox(name: "Remote", value: _remCbx),
                pw.Text("Remote", style: const pw.TextStyle(fontSize: 11)),
              ]))
    ]);
  }

  //*************************************************END OF GENERATE TICKET***************************************************//

  static Future<File> generateLaporanSelesai(List<dynamic> dataset, String ip,
      {bool pEtugas = false}) async {
    final pdf = pw.Document();
    final font = await rootBundle.load("assets/fonts/OpenSans.ttf");
    final ttf = pw.Font.ttf(font);
    String actor = "Gangguan";
    pw.Widget header = await buildHeader(ttf);
    if (pEtugas) {
      header = await buildHeaderPor(ttf);
    }
    List<List<dynamic>> datas = [];
    if (!pEtugas) {
      for (int i = 0; i < dataset.length; i++) {
        String ePetugas = dataset[i]['petugas'];
        String petugas = dataset[i]['name'];
        if (dataset[i]['petugas_2'] != null && dataset[i]['petugas_2'] != "") {
          petugas += ', ${dataset[i]['nama_petugas_2']}';
          ePetugas += ', ${dataset[i]['petugas_2']}';
        }
        datas.add([
          i + 1,
          dataset[i]['instansi'],
          dataset[i]['nama'],
          dataset[i]['deskripsi'],
          petugas,
          ePetugas,
          Utils.formatDate(DateTime.parse(dataset[i]['tanggal'])),
          Utils.formatDate(DateTime.parse(dataset[i]['selesai']))
        ]);
      }

      if (dataset[0]['jenis'] == 'layanan') {
        actor = "Layanan";
      }
      debugPrint(dataset.toString());
    } else {
      for (int i = 0; i < dataset.length; i++) {
        datas.add([
          i + 1,
          dataset[i]['email'],
          dataset[i]['name'],
          (dataset[i]['nip'] != null && dataset[i]['nip'] != '')
              ? dataset[i]['nip']
              : "Belum Diisi",
          (dataset[i]['jabatan'] != null && dataset[i]['jabatan'] != '')
              ? dataset[i]['jabatan']
              : "Belum Diisi",
          (dataset[i]['skill'] != null && dataset[i]['skill'] != '')
              ? dataset[i]['skill']
              : "Belum Diisi",
        ]);
      }
    }
    if (pEtugas) {
      actor = "Petugas";
    }

    pdf.addPage(pw.MultiPage(
        orientation: pEtugas
            ? pw.PageOrientation.portrait
            : pw.PageOrientation.landscape,
        margin:
            const pw.EdgeInsets.only(top: 20, left: 40, right: 40, bottom: 20),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Row(children: [
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    header,
                    pw.Container(
                      margin: const pw.EdgeInsets.all(20),
                      child: pw.Text("Data $actor",
                          style: pw.TextStyle(font: ttf)),
                    ),
                    table(
                        pEtugas
                            ? ['No', 'Email', 'Nama', 'Nip', 'Jabatan', 'Skill']
                            : [
                                'No',
                                'Instansi',
                                'Pelapor',
                                actor,
                                'Petugas',
                                'Email Petugas',
                                'Tanggal Masuk',
                                'Tanggal Selesai'
                              ],
                        datas,
                        ttf),
                    footer(ttf, big: pEtugas)
                  ])
            ])
          ];
        }));
    String docName = 'Report $actor.pdf';
    if (pEtugas) {
      docName = 'Petugas.pdf';
    }

    return PdfApi.saveTicket(name: docName, pdf: pdf);
  }

  static Future<File> generateNeoLaporanSelesai(
    List<dynamic> dataset,
    String ip,
  ) async {
    debugPrint(dataset.toString());
    final pdf = pw.Document();
    final font = await rootBundle.load("assets/fonts/OpenSans.ttf");
    final ttf = pw.Font.ttf(font);
    String actor = "Pemasangan Baru";
    pw.Widget header = await buildHeader(ttf);
    List<List<dynamic>> datas = [];
    for (int i = 0; i < dataset.length; i++) {
      datas.add([
        i + 1,
        dataset[i]['instansi'],
        dataset[i]['kontak'],
        dataset[i]['deskripsi'].toString().substring(16),
        Utils.formatDate(DateTime.parse(dataset[i]['tanggal'])),
        Utils.formatDate(DateTime.parse(dataset[i]['selesai'])),
        dataset[i]['tempat'],
        dataset[i]['name'],
        dataset[i]['petugas'],
      ]);
    }

    pdf.addPage(pw.MultiPage(
        orientation: pw.PageOrientation.landscape,
        margin:
            const pw.EdgeInsets.only(top: 20, left: 40, right: 40, bottom: 20),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Row(children: [
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    header,
                    pw.Container(
                      margin: const pw.EdgeInsets.all(20),
                      child: pw.Text("Data $actor",
                          style: pw.TextStyle(font: ttf)),
                    ),
                    neoTable([
                      'No',
                      'Instansi',
                      'Kontak Instansi',
                      'Kecepatan',
                      'Tanggal Msk',
                      'Tanggal Sls',
                      'alamat',
                      'Petugas',
                      'Email Petugas',
                    ], datas, ttf),
                    footer(ttf)
                  ])
            ])
          ];
        }));
    String docName = 'Report $actor.pdf';

    return PdfApi.saveTicket(name: docName, pdf: pdf);
  }

  static Future<File> generateProgress(List<dynamic> dataset) async {
    final pdf = pw.Document();
    final font = await rootBundle.load("assets/fonts/OpenSans.ttf");
    final ttf = pw.Font.ttf(font);

    pw.Widget header = await buildHeader(ttf);

    List<List<dynamic>> datas = [];

    for (int i = 0; i < dataset.length; i++) {
      String petugas = dataset[i]['petugas'];
      if (dataset[i]['petugas_2'] != null) {
        petugas += ', ${dataset[i]['petugas_2']}';
      }
      List<String>? cek = [];
      int last = 0;
      String kegi = dataset[i]['tindakLanjut'];
      for (int j = 0; j < kegi.length; j++) {
        if (kegi[j] == '|') {
          if (last != 0) last++;
          cek.add(kegi.substring(last, j));
          last = j;
        }
      }
      String tindakLanjut = "";
      for (int j = 0; j < cek.length; j++) {
        if (tindakLanjut != "") {
          tindakLanjut += ", ";
        }
        tindakLanjut += cek[j];
      }
      datas.add([
        i + 1,
        dataset[i]['instansi'],
        dataset[i]['deskripsi'],
        Utils.formatDate(DateTime.parse(dataset[i]['tanggal'])),
        petugas,
        tindakLanjut,
        "${dataset[i]['presentase']}%",
        (dataset[i]['kendala'] != null && dataset[i]['kendala'] != "")
            ? dataset[i]['kendala']
            : "Tidak Ada",
        (dataset[i]['tanggal_deadline'] != null &&
                dataset[i]['tanggal_deadline'] != "")
            ? Utils.formatDate(DateTime.parse(dataset[i]['tanggal_deadline']))
            : "Tidak Ada"
      ]);
    }
    String actor = "Gangguan";
    if (dataset[0]['jenis'] == 'layanan') {
      actor = "Layanan";
    }
    if (dataset[0]['jenis'] == 'baru') {
      actor = "Pemasangan Baru";
    }

    pdf.addPage(pw.MultiPage(
        orientation: pw.PageOrientation.landscape,
        margin:
            const pw.EdgeInsets.only(top: 20, left: 40, right: 40, bottom: 20),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Row(children: [
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    header,
                    pw.Container(
                      margin: const pw.EdgeInsets.all(20),
                      child: pw.Text("Data Prosess $actor",
                          style: pw.TextStyle(font: ttf)),
                    ),
                    tableProg([
                      'No',
                      'Instansi',
                      actor,
                      'Tanggal Masuk',
                      'Petugas',
                      'Tindak Lanjut',
                      'Progress',
                      'Kendala',
                      'Tanggal Deadline'
                    ], datas, ttf),
                    footer(ttf)
                  ])
            ])
          ];
        }));
    return PdfApi.saveTicket(name: 'Progress $actor.pdf', pdf: pdf);
  }

  static Future<File> generateInboxAdm(List<dynamic> dataset) async {
    final pdf = pw.Document();
    final font = await rootBundle.load("assets/fonts/OpenSans.ttf");
    final ttf = pw.Font.ttf(font);

    pw.Widget header = await buildHeader(ttf);

    List<List<dynamic>> datas = [];

    for (int i = 0; i < dataset.length; i++) {
      datas.add([
        i + 1,
        dataset[i]['instansi'],
        dataset[i]['nama'],
        dataset[i]['jenis'],
        dataset[i]['deskripsi'],
        Utils.formatDate(DateTime.parse(dataset[i]['tanggal'])),
        (dataset[i]['dbcadm'] != null)
            ? Utils.formatDate(DateTime.parse(dataset[i]['dbcadm']))
            : "Belum Dibaca",
        (dataset[i]['addptg'] != null)
            ? Utils.formatDate(DateTime.parse(dataset[i]['addptg']))
            : "Belum Dikirim",
      ]);
    }

    pdf.addPage(pw.MultiPage(
        orientation: pw.PageOrientation.landscape,
        margin:
            const pw.EdgeInsets.only(top: 20, left: 40, right: 40, bottom: 20),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    header,
                    pw.Container(
                      margin: const pw.EdgeInsets.all(20),
                      child: pw.Text("Data Inbox Admin",
                          style: pw.TextStyle(font: ttf)),
                    ),
                    tableInx([
                      'No',
                      'Instansi',
                      'Nama Pengirim',
                      'jenis',
                      'Isi',
                      'Tanggal Masuk',
                      'Tanggal Dibaca',
                      'Dikirm Ke Petugas'
                    ], datas, ttf),
                    footer(ttf)
                  ])
            ])
          ];
        }));
    return PdfApi.saveTicket(name: 'Inbox Admin.pdf', pdf: pdf);
  }

  static Future<File> generateInboxAllPet(List<dynamic> dataset) async {
    final pdf = pw.Document();
    final font = await rootBundle.load("assets/fonts/OpenSans.ttf");
    final ttf = pw.Font.ttf(font);
    pw.Widget header = await buildHeader(ttf);

    List<List<dynamic>> datas = [];

    for (int i = 0; i < dataset.length; i++) {
      datas.add([
        i + 1,
        dataset[i]['instansi'],
        dataset[i]['nama'],
        dataset[i]['kontak_instansi'],
        Utils.formatDate(DateTime.parse(dataset[i]['tanggal'])),
        dataset[i]['jenis'],
        dataset[i]['deskripsi'],
        (dataset[i]['addptg'] != null)
            ? Utils.formatDate(DateTime.parse(dataset[i]['addptg']))
            : "Belum Dikirim",
        (dataset[i]['dbcptg'] != null)
            ? Utils.formatDate(DateTime.parse(dataset[i]['dbcptg']))
            : "Belum Dibaca",
        (dataset[i]['addtndk'] != null)
            ? Utils.formatDate(DateTime.parse(dataset[i]['addtndk']))
            : "Belum Diprosess",
      ]);
    }

    pdf.addPage(pw.MultiPage(
        orientation: pw.PageOrientation.landscape,
        margin:
            const pw.EdgeInsets.only(top: 20, left: 40, right: 40, bottom: 20),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    header,
                    pw.Container(
                      margin: const pw.EdgeInsets.all(20),
                      child: pw.Text("Data Inbox Semua Petugas",
                          style: pw.TextStyle(font: ttf)),
                    ),
                    tableInx([
                      'No',
                      'Instansi',
                      'Nama Pelapor',
                      'Kontak Pelapor',
                      'Tanggal',
                      'jenis',
                      'Isi',
                      'Tanggal Masuk',
                      'Tanggal Dibaca',
                      'Tanggal Diprosess',
                    ], datas, ttf),
                    footer(ttf)
                  ]),
            ])
          ];
        }));
    return PdfApi.saveTicket(name: 'Inbox Admin.pdf', pdf: pdf);
  }

  static Future<File> generateKalender(List dataset) async {
    final pdf = pw.Document();
    final font = await rootBundle.load("assets/fonts/OpenSans.ttf");
    final ttf = pw.Font.ttf(font);
    pw.Widget header = await buildHeaderPor(ttf);
    List<List<dynamic>> datas = [];
    for (int i = 0; i < dataset.length; i++) {
      datas.add([
        i + 1,
        dataset[i]['1'],
        dataset[i]['0'],
        dataset[i]['5'],
        dataset[i]['6'],
        dataset[i]['7'],
        dataset[i]['2'],
        dataset[i]['3'],
        dataset[i]['4'],
        int.parse(dataset[i]['5'].toString()) +
            int.parse(dataset[i]['6'].toString()) +
            int.parse(dataset[i]['7'].toString()) +
            int.parse(dataset[i]['2'].toString()) +
            int.parse(dataset[i]['3'].toString()) +
            int.parse(dataset[i]['4'].toString())
      ]);
    }

    pdf.addPage(pw.MultiPage(
        orientation: pw.PageOrientation.portrait,
        margin:
            const pw.EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    header,
                    pw.Container(
                      margin: const pw.EdgeInsets.all(20),
                      child: pw.Text("Data Bulanan",
                          style: pw.TextStyle(font: ttf)),
                    ),
                    tableNull([
                      'No',
                      'Tahun',
                      'Bulan',
                      'Sls Baru',
                      'Sls Lyn',
                      'Sls Gng',
                      'Baru Prg',
                      'Lyn Prg',
                      'Gng Prg',
                      'Total Data',
                    ], datas, ttf),
                    pw.Row(children: [
                      pw.Text(
                          "*Keterangan : sls=selesai, prg=progress, baru=pemasangan baru, lyn=layanan, gng=ganguan",
                          style: const pw.TextStyle(fontSize: 10)),
                      pw.SizedBox(width: 100)
                    ]),
                    footer(ttf, big: true)
                  ]),
            ])
          ];
        }));
    return PdfApi.saveTicket(name: 'Inbox Admin.pdf', pdf: pdf);
  }

  static Future<File> generateOpsinInsta(List dataset, String jenis) async {
    final pdf = pw.Document();
    final font = await rootBundle.load("assets/fonts/OpenSans.ttf");
    final ttf = pw.Font.ttf(font);
    pw.Widget header = await buildHeaderPor(ttf);
    List<List<dynamic>> datas = [];
    if (jenis != 'instansi') {
      for (int i = 0; i < dataset.length; i++) {
        datas.add([i + 1, dataset[i]['1'], dataset[i]['2'], dataset[i]['3']]);
      }
    } else {
      for (int i = 0; i < dataset.length; i++) {
        datas.add([i + 1, dataset[i]['1'], dataset[i]['3'], dataset[i]['2']]);
      }
    }
    List<String> hear = [];
    if (jenis != 'instansi') {
      hear.addAll(["No", "Isi Opsi", "Jenis", "Total diajukan"]);
    } else {
      hear.addAll(["No", "Nama Instansi", "Kontak", "Alamat"]);
    }
    String actor = "Opsi Gangguan";
    if (jenis == "layanan") actor = "Opsi Layanan";
    if (jenis == "instansi") actor = "Instansi";

    pdf.addPage(pw.MultiPage(
        orientation: pw.PageOrientation.portrait,
        margin:
            const pw.EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    header,
                    pw.Container(
                      margin: const pw.EdgeInsets.all(20),
                      child: pw.Text("Data $actor",
                          style: pw.TextStyle(font: ttf)),
                    ),
                    (jenis == 'instansi')
                        ? tableNullCP(hear, datas, ttf)
                        : tableNull(hear, datas, ttf),
                    footer(ttf, big: true)
                  ]),
            ])
          ];
        }));
    return PdfApi.saveTicket(name: 'Inbox Admin.pdf', pdf: pdf);
  }

  static pw.Widget neoTable(
      List<dynamic> headers, List<List<dynamic>> data, pw.Font ttf) {
    return pw.Table.fromTextArray(
      tableWidth: pw.TableWidth.min,
      headers: headers,
      data: data,
      border: pw.TableBorder.all(),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      columnWidths: {
        1: const pw.FixedColumnWidth(100),
        2: const pw.FixedColumnWidth(100),
        3: const pw.FixedColumnWidth(70),
        6: const pw.FixedColumnWidth(100),
      },
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.center,
        3: pw.Alignment.centerLeft,
        4: pw.Alignment.center,
        5: pw.Alignment.center,
        6: pw.Alignment.center,
        7: pw.Alignment.center,
        8: pw.Alignment.center,
        9: pw.Alignment.center,
      },
    );
  }

  static pw.Widget tableInx(
      List<dynamic> headers, List<List<dynamic>> data, pw.Font ttf) {
    return pw.Table.fromTextArray(
      tableWidth: pw.TableWidth.min,
      headers: headers,
      data: data,
      border: pw.TableBorder.all(),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      columnWidths: {
        1: const pw.FixedColumnWidth(75),
        2: const pw.FixedColumnWidth(75),
        3: const pw.FixedColumnWidth(75),
        6: const pw.FixedColumnWidth(100),
      },
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.center,
        4: pw.Alignment.center,
        5: pw.Alignment.center,
        6: pw.Alignment.center,
        7: pw.Alignment.center,
        8: pw.Alignment.center,
        9: pw.Alignment.center,
      },
    );
  }

  static pw.Widget tableNull(
      List<dynamic> headers, List<List<dynamic>> data, pw.Font ttf) {
    return pw.Table.fromTextArray(
      tableWidth: pw.TableWidth.min,
      headers: headers,
      data: data,
      border: pw.TableBorder.all(),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      columnWidths: {
        1: const pw.FixedColumnWidth(75),
      },
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.center,
        4: pw.Alignment.center,
        5: pw.Alignment.center,
        6: pw.Alignment.center,
        7: pw.Alignment.center,
        8: pw.Alignment.center,
        9: pw.Alignment.center,
      },
    );
  }

  static pw.Widget tableNullCP(
      List<dynamic> headers, List<List<dynamic>> data, pw.Font ttf) {
    return pw.Table.fromTextArray(
      tableWidth: pw.TableWidth.min,
      headers: headers,
      data: data,
      border: pw.TableBorder.all(),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      columnWidths: {
        1: const pw.FixedColumnWidth(100),
        3: const pw.FixedColumnWidth(200),
      },
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
        4: pw.Alignment.center,
      },
    );
  }

  static pw.Widget tablePro(
      List<dynamic> headers, List<List<dynamic>> data, pw.Font ttf) {
    return pw.Table.fromTextArray(
      tableWidth: pw.TableWidth.min,
      headers: headers,
      data: data,
      border: pw.TableBorder.all(),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      columnWidths: {
        1: const pw.FixedColumnWidth(75),
        2: const pw.FixedColumnWidth(75),
        5: const pw.FixedColumnWidth(60),
      },
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.center,
        4: pw.Alignment.center,
        5: pw.Alignment.center,
        6: pw.Alignment.center,
        7: pw.Alignment.center,
        8: pw.Alignment.center,
      },
    );
  }

  static pw.Widget table(
      List<dynamic> headers, List<List<dynamic>> data, pw.Font ttf) {
    return pw.Table.fromTextArray(
      tableWidth: pw.TableWidth.min,
      headers: headers,
      data: data,
      border: pw.TableBorder.all(),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      columnWidths: {
        1: const pw.FixedColumnWidth(100),
        3: const pw.FixedColumnWidth(100),
        5: const pw.FixedColumnWidth(130),
      },
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.center,
        3: pw.Alignment.centerLeft,
        4: pw.Alignment.center,
        5: pw.Alignment.center,
        6: pw.Alignment.center,
        7: pw.Alignment.center,
      },
    );
  }

  static pw.Widget tableProg(
      List<dynamic> headers, List<List<dynamic>> data, pw.Font ttf) {
    return pw.Table.fromTextArray(
      tableWidth: pw.TableWidth.min,
      headers: headers,
      data: data,
      border: pw.TableBorder.all(),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttf),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      columnWidths: {
        1: const pw.FixedColumnWidth(100),
        2: const pw.FixedColumnWidth(100),
        3: const pw.FixedColumnWidth(100),
        4: const pw.FixedColumnWidth(100),
        5: const pw.FixedColumnWidth(130),
        8: const pw.FixedColumnWidth(80),
      },
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.center,
        3: pw.Alignment.centerLeft,
        4: pw.Alignment.center,
        5: pw.Alignment.center,
        6: pw.Alignment.center,
        7: pw.Alignment.center,
        8: pw.Alignment.center,
      },
    );
  }

  static Future<pw.Widget> buildHeader(pw.Font ttf) async {
    final logoKominfo = pw.MemoryImage(
        (await rootBundle.load("assets/img/l_kominfo.png"))
            .buffer
            .asUint8List());
    final logoBjb = pw.MemoryImage(
        (await rootBundle.load("assets/img/l_bjb.png")).buffer.asUint8List());
    return pw.Column(children: [
      pw.Container(
          child: pw.Row(children: [
        pw.Image(logoKominfo, height: 60),
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 20, right: 20),
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  "DINAS KOMUNIKASI, INFORMATIKA, STATISTIK DAN PERSANDIAN BANJARBARU",
                  style: pw.TextStyle(fontSize: 16, font: ttf),
                ),
                pw.Text(
                    "Loktabat Utara, Banjarbaru Utara, Kota Banjarbaru, Kalimantan Selatan 70714",
                    style: pw.TextStyle(fontSize: 12, font: ttf))
              ]),
        ),
        pw.Image(logoBjb, height: 60),
      ])),
      pw.SizedBox(height: 10),
      pw.Container(color: PdfColors.black, height: 2, width: 700)
    ]);
  }

  static Future<pw.Widget> buildHeaderPor(pw.Font ttf) async {
    final logoKominfo = pw.MemoryImage(
        (await rootBundle.load("assets/img/l_kominfo.png"))
            .buffer
            .asUint8List());
    final logoBjb = pw.MemoryImage(
        (await rootBundle.load("assets/img/l_bjb.png")).buffer.asUint8List());
    return pw.Column(children: [
      pw.Container(
          child: pw.Row(children: [
        pw.Image(logoKominfo, height: 60),
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 20, right: 20),
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  "DINAS KOMUNIKASI, INFORMATIKA, STATISTIK",
                  style: pw.TextStyle(fontSize: 16, font: ttf),
                ),
                pw.Text(
                  "DAN PERSANDIAN BANJARBARU",
                  style: pw.TextStyle(fontSize: 16, font: ttf),
                ),
                pw.SizedBox(height: 5),
                pw.Text("Loktabat Utara, Banjarbaru Utara, Kota Banjarbaru,",
                    style: pw.TextStyle(fontSize: 12, font: ttf)),
                pw.Text("Kalimantan Selatan 70714",
                    style: pw.TextStyle(fontSize: 12, font: ttf))
              ]),
        ),
        pw.Image(logoBjb, height: 60),
      ])),
      pw.SizedBox(height: 5),
      pw.Container(color: PdfColors.black, height: 2, width: 500)
    ]);
  }

  static pw.Widget footer(pw.Font ttf, {big = false}) {
    String text = "Banjarbaru, ";
    text +=
        "${DateTime.now().day} ${monthToIndo(DateTime.now())} ${DateTime.now().year}";
    return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
      pw.Container(width: big ? 270 : 470),
      pw.Container(
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
            pw.SizedBox(height: 20),
            pw.Text(text),
            pw.Text("Mengetahui Kepala Bidang Informatika"),
            pw.Text("Khairurrijaal, S STP"),
            pw.Text("NIP 19811010 200012 1 003"),
          ]))
    ]);
  }
}
