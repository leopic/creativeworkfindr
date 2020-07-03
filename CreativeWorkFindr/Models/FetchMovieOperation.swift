import Foundation

fileprivate typealias Response = Movie

class FetchMovieOperation: AsyncOperation {
  var result: Result<Movie, CreativeWorkFindrError>!

  private var imdbId: String!
  private var session: URLSessionProtocol!
  private let decoder = JSONDecoder()

  init(
    session: URLSessionProtocol = URLSession.shared,
    imdbId: String
  ) {
    self.session = session
    self.imdbId = imdbId
  }

  private func buildRequest() -> URLRequest {
    var request = URLRequest(url: MoviesEndPoint.detail(imdbId).url)
    request.addValue("application/json", forHTTPHeaderField: "accept")
    request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "GET"

    return request
  }

  override func main() {
    session.dataTask(with: buildRequest()) { [weak self] (data, response, error) in
      guard let self = self else { return }

      guard let data = data else {
        self.result = .failure(.errorFetchingMovie(id: self.imdbId))
        self.finish()
        return
      }

      do {
        let response = try self.decoder.decode(Response.self, from: data)
        self.result = .success(response)
      } catch {
        self.result = .failure(.parseError)
      }

      self.finish()
    }.resume()
  }
}

extension FetchMovieOperation: MovieProvider {}
