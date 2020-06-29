import Foundation

enum BooksEndPoint {
  case search(String)
  case detail(String)

  var url: URL {
    switch self {
    case .search(let term):
      var baseURL = baseURLComponents
      baseURL.path = "/search.json"
      baseURL.queryItems?.append(URLQueryItem(name: "q", value: term))
      return baseURL.url!
    case .detail(let openLibraryId):
      var baseURL = baseURLComponents
      baseURL.path = "/api/books"
      baseURL.queryItems?.append(URLQueryItem(name: "bibkeys", value: "OLID:\(openLibraryId)"))
      baseURL.queryItems?.append(URLQueryItem(name: "format", value: "json"))
      baseURL.queryItems?.append(URLQueryItem(name: "jscmd", value: "data"))
      return baseURL.url!
    }
  }

  private var baseURLComponents: URLComponents {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "openlibrary.org"
    urlComponents.queryItems = []
    return urlComponents
  }
}
