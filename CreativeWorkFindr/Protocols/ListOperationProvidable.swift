import Foundation

// Used to add an extra level of indirection to wrap concrete Operations
protocol ListOperationProvidable {
  func fetchMovieListOperation(searchTerm: String) -> CreativeWorkListProvider
  func fetchBookListOperation(searchTerm: String) -> CreativeWorkListProvider
}
