import Foundation

struct BookIdentifiers: Codable {
  private var openLibraryIds: [String]?
  var id: String? {
    openLibraryIds?.first
  }

  enum CodingKeys: String, CodingKey {
    case openLibraryIds = "edition_key"
  }
}

fileprivate struct Response: Codable {
  var ids: [BookIdentifiers]

  enum CodingKeys: String, CodingKey {
    case ids = "docs"
  }
}

class FetchBookListOperation: AsyncOperation {
  var results = [String]()
  var error: CreativeWorkFindrError?

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
    guard !searchTerm.isEmpty else {
      return .failure(.invalidSearchTerm(term: searchTerm))
    }

    var request = URLRequest(url: BooksEndPoint.search(searchTerm).url)
    request.addValue("application/json", forHTTPHeaderField: "accept")
    request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "GET"

    return .success(request)
  }

  override func main() {
    let requestAttempt = self.buildRequest()

    switch requestAttempt {
    case .failure(let error):
      self.error = error
      finish()
    case .success(let request):
      session.dataTask(with: request) { [weak self] (data, response, error) in
        guard let self = self else { return }

        guard let data = data else {
          self.error = .errorFetchingBookList
          self.finish()
          return
        }

        do {
          let response = try self.decoder.decode(Response.self, from: data)
          let valid = response.ids.filter { $0.id != nil }.compactMap { $0 }
          self.results = Array(valid.prefix(self.maxResults)).map { $0.id! }
        } catch {
          self.error = .parseError
        }

        self.finish()
      }.resume()
    }
  }
}

extension FetchBookListOperation: CreativeWorkListProvider {}
