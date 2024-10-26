int getEpochFromDateTime(DateTime dateTime) =>
    dateTime.millisecondsSinceEpoch ~/ 1000;
