class DatasetPrint {
  String? _petugas1;
  String? _petugas2;
  String? _namaPelapor;
  String? _deskripsi;
  String? _instansi;
  String? _tindakLanjut;
  String? _permasalahan;
  String? _tglsls;
  String? _tanggal;
  String? _langkahPenanganan;
  String? _kodePrint;

  String? get getPetugas1 {
    if (_petugas1 != null) {
      return _petugas1;
    }
    return "";
  }

  String? get getPetugas2 {
    if (_petugas2 != null) {
      return _petugas2;
    }
    return "";
  }

  String? get getNamaPelapor {
    if (_namaPelapor != null) {
      return _namaPelapor;
    }
    return "";
  }

  String? get getDeskripsi {
    if (_deskripsi != null) {
      return _deskripsi;
    }
    return "";
  }

  String? get getInstansi {
    if (_instansi != null) {
      return _instansi;
    }
    return "";
  }

  String? get getTindakLanjut {
    if (_tindakLanjut != null) {
      return _tindakLanjut;
    }
    return "";
  }

  String? get getTglsls {
    if (_tglsls != null) {
      return _tglsls;
    }
    return "";
  }

  String? get getTanggal {
    if (_tanggal != null) {
      return _tanggal;
    }
    return "";
  }

  String? get getPermasalahan {
    if (_permasalahan != null) {
      return _permasalahan;
    }
    return "";
  }

  String? get getLangkahPenanganan {
    if (_langkahPenanganan != null) {
      return _langkahPenanganan;
    }
    return "";
  }

  String? get getKodePrint {
    if (_kodePrint != null) {
      return _kodePrint;
    }
    return "";
  }

  DatasetPrint(
      {String? petugas1,
      String? tindakLanjut,
      String? tanggal,
      String? tglsls,
      String? petugas2,
      String? permasalahan,
      String? namaPelapor,
      String? langkahPenanganan,
      String? instansi,
      String? deskripsi,
      String? kodePrint}) {
    _petugas1 = petugas1;
    _tindakLanjut = tindakLanjut;
    _tanggal = tanggal;
    _tglsls = tglsls;
    _petugas2 = petugas2;
    _permasalahan = permasalahan;
    _namaPelapor = namaPelapor;
    _langkahPenanganan = langkahPenanganan;
    _instansi = instansi;
    _deskripsi = deskripsi;
    _kodePrint = kodePrint;
  }
}
