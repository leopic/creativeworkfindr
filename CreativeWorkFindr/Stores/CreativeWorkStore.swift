import Foundation

final class CreativeWorkStore {
  private let operationQueue = OperationQueue()

  private let listOperationProvider: ListOperationProvidable
  private let fetchMovieOperationProvider: FetchMovieOperationProvidable
  private let fetchBookOperationProvider: FetchBookOperationProvidable

  init(
    listOperationProvider: ListOperationProvidable = ListOperationProvider(),
    fetchMovieOperationProvider: FetchMovieOperationProvidable = FetchMovieOperationProvider(),
    fetchBookOperationProvider: FetchBookOperationProvidable = FetchBookOperationProvider()
  ) {
    self.listOperationProvider = listOperationProvider
    self.fetchMovieOperationProvider = fetchMovieOperationProvider
    self.fetchBookOperationProvider = fetchBookOperationProvider
  }

  typealias Works = (books: [Book], movies: [Movie])
  func find(byTerm: String) -> Result<Works, CreativeWorkFindrError> {
    let trimmedTerm = byTerm.trimmingCharacters(in: .whitespaces)

    guard Self.validateSearch(term: trimmedTerm) else {
      return .failure(.invalidSearchTerm(term: trimmedTerm))
    }

    let fetchMovieList = listOperationProvider.fetchMovieListOperation(searchTerm: trimmedTerm)
    let fetchBookList = listOperationProvider.fetchBookListOperation(searchTerm: trimmedTerm)

    operationQueue.addOperations([fetchBookList, fetchMovieList], waitUntilFinished: true)

    guard let fetchBookListResult = fetchBookList.result,
          let fetchMovieListResult = fetchMovieList.result else {
      return .failure(.generalFailure)
    }

    var fetchBookOperations = [BookProvider]()
    var fetchMovieOperations = [MovieProvider]()
    switch (fetchBookListResult, fetchMovieListResult) {
    case (.failure, .failure):
      return .failure(.generalFailure)
    case(.success(let bookList), .success(let movieList)):
      fetchBookOperations = bookList.compactMap { fetchBookOperationProvider.fetchBookOperation(openLibraryId: $0) }
      fetchMovieOperations = movieList.compactMap { fetchMovieOperationProvider.fetchMovieOperation(imdbId: $0) }
    case (.success(let bookList), _):
      fetchBookOperations = bookList.compactMap { fetchBookOperationProvider.fetchBookOperation(openLibraryId: $0) }
    case (_, .success(let movieList)):
      fetchMovieOperations = movieList.compactMap { fetchMovieOperationProvider.fetchMovieOperation(imdbId: $0) }
    }

    operationQueue.addOperations(fetchBookOperations + fetchMovieOperations, waitUntilFinished: true)

    let books = fetchBookOperations.compactMap { try? $0.result.get() }
    let movies = fetchMovieOperations.compactMap { try? $0.result.get() }

    return .success((books: books, movies: movies))
  }

  class func validateSearch(term: String) -> Bool {
    return term != ""
  }
}
