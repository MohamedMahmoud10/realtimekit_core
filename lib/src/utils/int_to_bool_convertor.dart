bool convertIntegerToBoolean(int val) => val == 0 ? false : true;

bool decodeBool(dynamic val) =>
    val.runtimeType == int ? convertIntegerToBoolean(val as int) : val;
