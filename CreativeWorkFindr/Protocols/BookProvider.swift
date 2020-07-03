import Foundation

protocol BookProvider: AsyncOperation {
  var result: Result<Book, CreativeWorkFindrError>! { get }
}
