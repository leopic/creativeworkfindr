import Foundation

struct FetchMovieOperationProvider: FetchMovieOperationProvidable {
  func fetchMovieOperation(imdbId: String) -> MovieProvider {
    FetchMovieOperation(imdbId: imdbId)
  }
}
