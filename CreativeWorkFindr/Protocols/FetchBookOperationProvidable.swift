import Foundation

protocol FetchBookOperationProvidable {
  func fetchBookOperation(openLibraryId: String) -> BookProvider
}
