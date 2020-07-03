import Foundation

fileprivate struct Response: Codable {
  var movies: [Movie]?
  var response: String
  var error: String?

  enum CodingKeys: String, CodingKey {
    case movies = "Search"
    case response = "Response"
    case error = "Error"
  }
}

class FetchMovieListOperation: AsyncOperation {
  var result: Result<[String], CreativeWorkFindrError>! {
    didSet {
      finish()
    }
  }

  private var maxResults: Int
  private var searchTerm: String!
  private var session: URLSessionProtocol!
  private let decoder = JSONDecoder()

  init(
    session: URLSessionProtocol = URLSession.shared,
    searchTerm: String,
    maxResults: Int = 10
  ) {
    self.session = session
    self.searchTerm = searchTerm
    self.maxResults = maxResults
  }

  private func buildRequest() -> Result<URLRequest, CreativeWorkFindrError> {
    guard !searchTerm.isEmpty,
      searchTerm != "" else {
      return .failure(.invalidSearchTerm(term: searchTerm))
    }

    var request = URLRequest(url: MoviesEndPoint.search(searchTerm).url)
    request.addValue("application/json", forHTTPHeaderField: "accept")
    request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "GET"

    return .success(request)
  }

  override func main() {
    switch buildRequest() {
    case .failure(let error):
      self.result = .failure(error)
    case .success(let request):
      session.dataTask(with: request) { [weak self] (data, response, error) in
        guard let self = self else { return }

        guard let data = data else {
          self.result = .failure(.errorFetchingMovieList)
          return
        }

        do {
          let response = try self.decoder.decode(Response.self, from: data)

          if let error = response.error {
            switch error {
            case "Movie not found!":
              self.result = .success([])
            default:
              self.result = .failure(.errorFetchingMovieList)
            }

            self.finish()
          }

          let results = response.movies?
            .filter({ $0.thumbnailURL != nil })
            .compactMap({ $0 })
            .map({ $0.imdbId }) ?? [String]()

          self.result = .success(Array(results.prefix(self.maxResults)))
        } catch {
          self.result = .failure(.parseError)
        }
      }.resume()
    }
  }
}

extension FetchMovieListOperation: CreativeWorkListProvider {}
