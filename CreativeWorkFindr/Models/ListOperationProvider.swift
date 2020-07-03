import Foundation

struct ListOperationProvider: ListOperationProvidable {
  func fetchMovieListOperation(searchTerm: String) -> CreativeWorkListProvider {
    FetchMovieListOperation(searchTerm: searchTerm)
  }
  func fetchBookListOperation(searchTerm: String) -> CreativeWorkListProvider {
    FetchBookListOperation(searchTerm: searchTerm)
  }
}
