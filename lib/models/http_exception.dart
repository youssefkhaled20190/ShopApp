class HttpException {
  String msg;
  HttpException(this.msg);
  @override
  String toString() {
    return msg;
  }
}
