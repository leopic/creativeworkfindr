import Foundation

protocol CreativeWorkListProvider: AsyncOperation {
  var result: Result<[String], CreativeWorkFindrError>! { get }
}
