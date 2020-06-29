import Foundation

enum CreativeWorkFindrError: Error {
  case errorFetchingBook(id: String)
  case errorFetchingBookList
  case errorFetchingMovie(id: String)
  case errorFetchingMovieList
  case invalidSearchTerm(term: String)
  case generalFailure
  case parseError

  var description: String {
    switch self {
    case .errorFetchingBook(let id):
      return "Error fetching book: \(id)"
    case .errorFetchingBookList:
      return "Error fetching books"
    case .errorFetchingMovie(let id):
      return "Error fetching movie: \(id)"
    case .errorFetchingMovieList:
      return "Error fetching movies"
    case .invalidSearchTerm(let term):
      return "Invalid search term: '\(term)'"
    case .parseError:
      return "Parse error"
    case .generalFailure:
      return "Error feching books and movies"
    }
  }
}

extension CreativeWorkFindrError: Equatable {}
