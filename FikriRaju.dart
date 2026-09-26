class Karyawan {
  String nip;
  String nama;
  String divisi;
  double gajiPokok;

  Karyawan({
    required this.nip,
    required this.nama,
    required this.divisi,
    required this.gajiPokok,
  });

  // Tunjangan berdasarkan divisi
  double get tunjangan {
    switch (divisi.toLowerCase()) {
      case 'manajer':
        return 2000000;
      case 'supervisor':
        return 1200000;
      case 'developer':
        return 800000;
      default:
        return 500000;
    }
  }

  // BPJS: 3% dari Gaji Pokok
  double get bpjs => gajiPokok * 0.03;

  // PPh berdasarkan bracket/pajak progresif sederhana
  double get pph {
    if (gajiPokok > 10000000) {
      return gajiPokok * 0.15;
    } else if (gajiPokok > 5000000) {
      return gajiPokok * 0.10;
    } else {
      return gajiPokok * 0.05;
    }
  }

  // Perhitungan Gaji Bersih = Pokok + Tunjangan - BPJS - PPh
  double get gajiBersih => gajiPokok + tunjangan - bpjs - pph;
}

class SistemPenggajian {
  List<Karyawan> daftarKaryawan = [];

  // Fungsi tambah data karyawan dengan Exception Handling (Validasi Gaji Null & NIP Duplikat)
  void tambahKaryawan(
    String nip,
    String nama,
    String divisi,
    double? gajiPokok,
  ) {
    // 1. Exception handling jika gaji null/invalid
    if (gajiPokok == null || gajiPokok <= 0) {
      throw Exception(
        'Gaji pokok tidak valid/null untuk karyawan NIP $nip ($nama)',
      );
    }

    // 2. Exception handling jika NIP duplikat
    bool isDuplicate = daftarKaryawan.any((k) => k.nip == nip);
    if (isDuplicate) {
      throw Exception('NIP duplikat terdeteksi: $nip ($nama)');
    }

    daftarKaryawan.add(
      Karyawan(nip: nip, nama: nama, divisi: divisi, gajiPokok: gajiPokok),
    );
  }

  // Fungsi cariKaryawan(nip) menggunakan Null Safety (mengembalikan Karyawan? atau null)
  Karyawan? cariKaryawan(String nip) {
    try {
      return daftarKaryawan.firstWhere((k) => k.nip == nip);
    } catch (e) {
      return null; // Mengembalikan null jika NIP tidak ditemukan
    }
  }

  // Menampilkan laporan payroll lengkap
  void tampilkanLaporan() {
    if (daftarKaryawan.isEmpty) {
      print('Tidak ada data karyawan.');
      return;
    }

    print(
      '\n========================================================================================',
    );
    print(
      '                                 LAPORAN GAJI KARYAWAN                                 ',
    );
    print(
      '========================================================================================',
    );
    print(
      '${'NIP'.padRight(8)} | ${'Nama'.padRight(12)} | ${'Divisi'.padRight(12)} | ${'Pokok'.padRight(10)} | ${'Tunjangan'.padRight(10)} | ${'BPJS(3%)'.padRight(9)} | ${'PPh'.padRight(9)} | ${'Gaji Bersih'.padRight(11)}',
    );
    print(
      '----------------------------------------------------------------------------------------',
    );

    double totalPayroll = 0;
    Karyawan karyawanTertinggi = daftarKaryawan.first;
    Karyawan karyawanTerendah = daftarKaryawan.first;

    for (var k in daftarKaryawan) {
      double gb = k.gajiBersih;
      totalPayroll += gb;

      if (gb > karyawanTertinggi.gajiBersih) karyawanTertinggi = k;
      if (gb < karyawanTerendah.gajiBersih) karyawanTerendah = k;

      print(
        '${k.nip.padRight(8)} | ${k.nama.padRight(12)} | ${k.divisi.padRight(12)} | ${k.gajiPokok.toStringAsFixed(0).padRight(10)} | ${k.tunjangan.toStringAsFixed(0).padRight(10)} | ${k.bpjs.toStringAsFixed(0).padRight(9)} | ${k.pph.toStringAsFixed(0).padRight(9)} | ${gb.toStringAsFixed(0).padRight(11)}',
      );
    }

    double rataRata = totalPayroll / daftarKaryawan.length;

    print(
      '========================================================================================',
    );
    print(
      '                                   RINGKASAN LAPORAN                                   ',
    );
    print(
      '========================================================================================',
    );
    print('Total Payroll      : Rp ${totalPayroll.toStringAsFixed(0)}');
    print('Rata-rata Gaji     : Rp ${rataRata.toStringAsFixed(2)}');
    print(
      'Gaji Tertinggi     : Rp ${karyawanTertinggi.gajiBersih.toStringAsFixed(0)} (${karyawanTertinggi.nama} - ${karyawanTertinggi.nip})',
    );
    print(
      'Gaji Terendah      : Rp ${karyawanTerendah.gajiBersih.toStringAsFixed(0)} (${karyawanTerendah.nama} - ${karyawanTerendah.nip})',
    );
    print(
      '========================================================================================\n',
    );
  }
}

void main() {
  SistemPenggajian sistem = SistemPenggajian();

  print('>>> MEMASUKKAN DATA KARYAWAN <<<');

  // Input Data Minimal 10 Karyawan (Termasuk Demo Exception Handling)
  List<Map<String, dynamic>> rawData = [
    {'nip': 'K001', 'nama': 'Budi', 'divisi': 'Manajer', 'gaji': 12000000.0},
    {'nip': 'K002', 'nama': 'Siti', 'divisi': 'Supervisor', 'gaji': 8000000.0},
    {'nip': 'K003', 'nama': 'Andi', 'divisi': 'Developer', 'gaji': 6500000.0},
    {'nip': 'K004', 'nama': 'Dewi', 'divisi': 'Developer', 'gaji': 6000000.0},
    {'nip': 'K005', 'nama': 'Rian', 'divisi': 'Staff', 'gaji': 4500000.0},
    {'nip': 'K006', 'nama': 'Fikri', 'divisi': 'Developer', 'gaji': 7000000.0},
    {'nip': 'K007', 'nama': 'Maya', 'divisi': 'Staff', 'gaji': 4200000.0},
    {'nip': 'K008', 'nama': 'Eko', 'divisi': 'Supervisor', 'gaji': 8500000.0},
    {'nip': 'K009', 'nama': 'Nita', 'divisi': 'Staff', 'gaji': 4000000.0},
    {'nip': 'K010', 'nama': 'Rizal', 'divisi': 'Developer', 'gaji': 6200000.0},

    // Testing Exception Handling:
    {
      'nip': 'K011',
      'nama': 'Test Null',
      'divisi': 'Staff',
      'gaji': null,
    }, // Gaji null
    {
      'nip': 'K001',
      'nama': 'Test Dup',
      'divisi': 'Staff',
      'gaji': 5000000.0,
    }, // NIP Duplikat
  ];

  for (var data in rawData) {
    try {
      sistem.tambahKaryawan(
        data['nip'],
        data['nama'],
        data['divisi'],
        data['gaji'],
      );
      print(' Berhasil menambah: ${data['nama']} (${data['nip']})');
    } catch (e) {
      print(' [ERROR HANDLED]: $e');
    }
  }

  // Tampilkan Laporan Payroll
  sistem.tampilkanLaporan();

  // Demo Fungsi cariKaryawan dengan Null Safety
  print('>>> UJI FUNGSI CARI KARYAWAN (NULL SAFETY) <<<');

  String searchNip1 = 'K006';
  Karyawan? hasil1 = sistem.cariKaryawan(searchNip1);
  if (hasil1 != null) {
    print(
      'Pencarian NIP $searchNip1: Ditemukan -> ${hasil1.nama} (${hasil1.divisi}), Gaji Bersih: Rp ${hasil1.gajiBersih.toStringAsFixed(0)}',
    );
  } else {
    print('Pencarian NIP $searchNip1: Data tidak ditemukan (null)');
  }

  String searchNip2 = 'K999';
  Karyawan? hasil2 = sistem.cariKaryawan(searchNip2);
  if (hasil2 != null) {
    print('Pencarian NIP $searchNip2: Ditemukan -> ${hasil2.nama}');
  } else {
    print('Pencarian NIP $searchNip2: Data tidak ditemukan (null)');
  }
}
