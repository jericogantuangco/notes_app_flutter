enum APIError {
  userNotFound,
  invalidUsernameOrPassword,
}

Map<APIError, String> colorToString = {
  APIError.userNotFound: "user_not_found",
  APIError.invalidUsernameOrPassword: "invalid_username_or_password",
};
