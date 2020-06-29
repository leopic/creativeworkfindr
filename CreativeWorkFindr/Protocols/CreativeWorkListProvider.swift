import Foundation

protocol CreativeWorkListProvider: Operation {
  var results: [String] { get }
  var error: CreativeWorkFindrError? { get }
}
