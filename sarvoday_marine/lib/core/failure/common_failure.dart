abstract class CommonFailure {}

class ServerFailure extends CommonFailure {
  String? message;
  String? status;

  ServerFailure({this.message, this.status});
}

class InternetFailure extends CommonFailure {
  String? failureMsg;

  InternetFailure({this.failureMsg});
}

class AuthFailure extends CommonFailure {
  String? authFailureMsg;

  AuthFailure({this.authFailureMsg});
}

class ErrorFailure extends CommonFailure {
  String errorMsg;

  ErrorFailure(this.errorMsg);
}
