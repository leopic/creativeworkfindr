import Foundation

protocol FetchMovieOperationProvidable {
  func fetchMovieOperation(imdbId: String) -> MovieProvider
}
