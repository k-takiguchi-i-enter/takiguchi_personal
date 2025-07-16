function handler(event) {
  var request = event.request;
  var headers = request.headers;

  var authString = "Basic ${auth_string}";

  if (
    typeof headers.authorization === "undefined" ||
    !authString.includes(headers.authorization.value)
  ) {
    return {
      statusCode: 401,
      statusDescription: "Unauthorized",
      headers: { "www-authenticate": { value: "Basic" } }
    };
  }

  return request;
}