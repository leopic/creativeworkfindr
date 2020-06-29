import Foundation

protocol MovieProvider: AsyncOperation {
  var movie: Movie! { get }
  var error: CreativeWorkFindrError? { get }
}
