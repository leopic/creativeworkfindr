import Foundation

final class MockURLSession: URLSessionProtocol {
  var nextDataTask = MockURLSessionDataTask()
  var nextError: CreativeWorkFindrError?
  var nextData: Data?

  private var lastURL: URL?

  func successHttpURLResponse(request: URLRequest) -> URLResponse {
    HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
  }

  func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
    completionHandler(nextData, successHttpURLResponse(request: request), nextError)
    return nextDataTask
  }

  init(nextError: CreativeWorkFindrError? = nil, nextData: Data? = nil) {
    self.nextError = nextError
    self.nextData = nextData
  }
}

final class MockURLSessionDataTask: URLSessionDataTaskProtocol {
  private var resumeWasCalled = false

  func resume() {
    resumeWasCalled = true
  }
}
