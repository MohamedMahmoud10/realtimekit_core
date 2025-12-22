sealed class AppResponse<T> {}

class Initial<T> extends AppResponse<T> {}

class Loading<T> extends AppResponse<T> {}

class Success<T> extends AppResponse<T> {
  final T value;

  Success(this.value);
}

class Error<T> extends AppResponse<T> {
  final String cause;

  Error(this.cause);
}

sealed class AppLinkState {}

class LinkInitial extends AppLinkState {}

class RtkIdDetected extends AppLinkState {
  final String meetingId;
  RtkIdDetected(this.meetingId);
}

class RtkIdError extends AppLinkState {
  final String msg;
  RtkIdError([
    this.msg =
        'Oops, you tapped on an invalid dyte link. Use demo.dyte.io links.',
  ]);
}
