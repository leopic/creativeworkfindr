import Foundation

enum MoviesEndPoint {
  case search(String)
  case detail(String)

  private static var urlComponents: URLComponents {
    var baseURL = URLComponents()
    baseURL.scheme = "https"
    baseURL.host = "omdbapi.com"
    let apiKey = URLQueryItem(name: "apikey", value: "67520c83")
    baseURL.queryItems = [apiKey]
    return baseURL
  }

  var url: URL {
    switch self {
    case .search(let term):
      var baseURL = Self.urlComponents
      baseURL.path = "/"
      baseURL.queryItems?.append(URLQueryItem(name: "s", value: term))
      return baseURL.url!
    case .detail(let imdbID):
      var baseURL = Self.urlComponents
      baseURL.path = "/"
      baseURL.queryItems?.append(URLQueryItem(name: "i", value: imdbID))
      baseURL.queryItems?.append(URLQueryItem(name: "plot", value: "full"))
      return baseURL.url!
    }
  }
}
