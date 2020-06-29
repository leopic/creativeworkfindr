import Foundation

protocol BookProvider: AsyncOperation {
  var book: Book! { get }
  var error: CreativeWorkFindrError? { get }
}
