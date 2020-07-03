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
      self.result = .failure(error)
    case .success(let request):
      session.dataTask(with: request) { [weak self] (data, response, error) in
        guard let self = self else { return }

        guard let data = data else {
          self.result = .failure(.errorFetchingBookList)
          return
        }

        do {
          let response = try self.decoder.decode(Response.self, from: data)
          let valid = response.ids.filter { $0.id != nil }.compactMap { $0 }
          self.result = .success(Array(valid.prefix(self.maxResults)).map { $0.id! })
        } catch {
          self.result = .failure(.parseError)
        }
      }.resume()
    }
  }
}

extension FetchBookListOperation: CreativeWorkListProvider {}
