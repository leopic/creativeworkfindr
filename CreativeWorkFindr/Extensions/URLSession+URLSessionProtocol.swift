import Foundation

extension URLSession: URLSessionProtocol {
  func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
    dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
  }
}
