import 'package:intl/intl.dart';

String toIndo(String bahan) {
  late String result;
  switch (bahan) {
    case "Monday":
      result = "Senin";
      break;
    case "Tuesday":
      result = "Selasa";
      break;
    case "Wednesday":
      result = "Rabu";
      break;
    case "Thursday":
      result = "Kamis";
      break;
    case "Friday":
      result = "Jum'at";
      break;
    case "Saturday":
      result = "Sabtu";
      break;
    case "Sunday":
      result = "Minggu";
      break;
    case "January":
      result = "Januari";
      break;
    case "February":
      result = "Februari";
      break;
    case "March":
      result = "Maret";
      break;
    case "April":
      result = bahan;
      break;
    case "May":
      result = "Mei";
      break;
    case "June":
      result = "Juni";
      break;
    case "July":
      result = "Juli";
      break;
    case "August":
      result = "Agustus";
      break;
    case "September":
      result = bahan;
      break;
    case "October":
      result = "Oktober";
      break;
    case "November":
      result = bahan;
      break;
    case "December":
      result = "Desember";
      break;
    default:
      result = "error";
  }
  return result;
}

String dayToIndo(DateTime date) {
  String result;
  result = toIndo(DateFormat('EEEE').format(date));
  return result;
}

String monthToIndo(DateTime date) {
  String result;
  result = toIndo(DateFormat('MMMM').format(date));
  return result;
}
