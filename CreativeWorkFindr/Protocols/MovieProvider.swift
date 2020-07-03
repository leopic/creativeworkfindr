import Foundation

protocol MovieProvider: AsyncOperation {
  var result: Result<Movie, CreativeWorkFindrError>! { get }
}
