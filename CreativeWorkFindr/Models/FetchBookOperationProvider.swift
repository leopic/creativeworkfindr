import Foundation

struct FetchBookOperationProvider: FetchBookOperationProvidable {
  func fetchBookOperation(openLibraryId: String) -> BookProvider {
    FetchBookOperation(openLibraryId: openLibraryId)
  }
}
