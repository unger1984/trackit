/// API Source
abstract class ApiSource {
  // GET request to API.
  // [uri] - additional url string to [baseUrl].
  // [queryParameters] - additional query parameters to request.
  Future<T?> get<T>(String uri,
      {Map<String, dynamic>? queryParameters, Map<String, dynamic>? headers});

  // POST request to API.
  // [uri] - additional url string to [baseUrl].
  // [data] - data for post body.
  // [queryParameters] - additional query parameters to request.
  Future<T?> post<T>(String uri,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers});

  // PUT request to API.
  // [uri] - additional url string to [baseUrl].
  // [data] - data for put body.
  // [queryParameters] - additional query parameters to request.
  Future<T?> patch<T>(String uri,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers});

  Future<T?> delete<T>(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });
}
