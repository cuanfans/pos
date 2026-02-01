class ApiResult<T> {
  final T? data;
  final String? message;
  final bool isSuccess;

  ApiResult.success(this.data) : isSuccess = true, message = null;
  ApiResult.failure(this.message) : isSuccess = false, data = null;
}
