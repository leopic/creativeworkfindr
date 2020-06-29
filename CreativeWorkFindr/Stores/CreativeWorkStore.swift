import Foundation

final class CreativeWorkStore {
  private let operationQueue = OperationQueue()

  private var bookListProvider: CreativeWorkListProvider!
  private var bookProvider: BookProvider!
  
  private var movieListProvider: CreativeWorkListProvider!
  private var movieProvider: MovieProvider!

  private var verifyErrors: CreativeWorkFindrError? {
    if bookListProvider.error != nil && movieListProvider.error != nil {
      return .generalFailure
    }

    return nil
  }

  convenience init(
    bookListProvider: CreativeWorkListProvider,
    bookProvider: BookProvider,
    movieListProvider: CreativeWorkListProvider,
    movieProvider: MovieProvider
  ) {
    self.init()
    self.bookListProvider = bookListProvider
    self.bookProvider = bookProvider
    self.movieListProvider = movieListProvider
    self.movieProvider = movieProvider
  }

  typealias Works = (books: [Book], movies: [Movie])
  func find(byTerm: String) -> Result<Works, CreativeWorkFindrError> {
    guard Self.validateSearch(term: byTerm) else {
      return .failure(.invalidSearchTerm(term: byTerm))
    }

    self.movieListProvider = self.movieListProvider ?? FetchMovieListOperation(searchTerm: byTerm)

    self.bookListProvider = self.bookListProvider ?? FetchBookListOperation(searchTerm: byTerm)

    operationQueue.addOperations([bookListProvider!, movieListProvider!], waitUntilFinished: true)

    if let error = verifyErrors {
      return .failure(error)
    }

    let fetchBookOperations = bookListProvider!.results.map {
      self.bookProvider ?? FetchBookOperation(openLibraryId: $0)
    }

    let fetchMovieOperations = movieListProvider!.results.map {
      self.movieProvider ?? FetchMovieOperation(imdbId: $0)
    }

    operationQueue.addOperations(fetchBookOperations + fetchMovieOperations, waitUntilFinished: true)

    let books = fetchBookOperations.filter { $0.error == nil }.map { $0.book }.compactMap { $0 }
    let movies = fetchMovieOperations.filter { $0.error == nil }.map { $0.movie }.compactMap { $0 }

    self.movieListProvider = nil
    self.bookListProvider = nil

    return .success((books: books, movies: movies))
  }

  class func validateSearch(term: String) -> Bool {
    return term.trimmingCharacters(in: .whitespaces) != ""
  }
}
