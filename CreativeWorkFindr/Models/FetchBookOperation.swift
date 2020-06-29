import Foundation

fileprivate struct Response: Decodable {
  var book: Book

  struct DynamicKey: CodingKey {
    var stringValue: String
    var intValue: Int? = nil

    init?(intValue: Int) { return nil }

    init?(stringValue: String) {
      self.stringValue = stringValue
    }
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: DynamicKey.self)

    guard let firstKey = container.allKeys.first else {
      throw CreativeWorkFindrError.parseError
    }

    book = try container.decode(Book.self, forKey: firstKey)
  }
}

class FetchBookOperation: AsyncOperation {
  var book: Book!
  var error: CreativeWorkFindrError?

  private var openLibraryId: String!
  private var session: URLSessionProtocol!
  private let decoder = JSONDecoder()

  init(
    session: URLSessionProtocol = URLSession.shared,
    openLibraryId: String
  ) {
    self.session = session
    self.openLibraryId = openLibraryId
  }

  private func buildRequest() -> URLRequest {
    var request = URLRequest(url: BooksEndPoint.detail(openLibraryId).url)
    request.addValue("application/json", forHTTPHeaderField: "accept")
    request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "GET"

    return request
  }

  override func main() {
    let request = self.buildRequest()

    session.dataTask(with: request) { [weak self] (data, response, error) in
      guard let self = self else { return }

      guard let data = data else {
        self.error = .errorFetchingBook(id: self.openLibraryId)
        self.finish()
        return
      }

      do {
        let response = try self.decoder.decode(Response.self, from: data)
        self.book = response.book
      } catch {
        self.error = .parseError
      }

      self.finish()
    }.resume()
  }
}

extension FetchBookOperation: BookProvider {}
