const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

const _monthsFull = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

String relativeDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final d = DateTime(date.year, date.month, date.day);
  final diff = today.difference(d).inDays;

  if (diff == 0) return 'Today';
  if (diff == 1) return 'Yesterday';
  return '${_months[date.month - 1]} ${date.day}';
}

String monthYear(DateTime date) =>
    '${_monthsFull[date.month - 1]} ${date.year}';

String shortDate(DateTime date) =>
    '${_months[date.month - 1]} ${date.day}, ${date.year}';

String shortMonth(DateTime date) => _months[date.month - 1];

String currency(double amount) {
  final abs = amount.abs();
  final intPart = abs.truncate().toString();
  final dec = (abs - abs.truncate()).toStringAsFixed(2).substring(1);

  final buf = StringBuffer();
  for (int i = 0; i < intPart.length; i++) {
    if (i > 0 && (intPart.length - i) % 3 == 0) buf.write(',');
    buf.write(intPart[i]);
  }
  return '\$$buf$dec';
}
