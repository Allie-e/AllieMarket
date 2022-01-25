import Foundation

class APIManager: APIManageable {
    let successRange = 200..<300
    
    func createRequest(_ url: URL, _ httpMethod: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        
        return request
    }
    
    func requestHealthChecker(completionHandler: @escaping (Result<Data, URLSessionError>) -> Void) {
        guard let url = URLManager.healthChecker.url else {
            completionHandler(.failure(.urlIsNil))
            return
        }
        
        let request = createRequest(url, HTTPMethod.get)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionHandler(.failure(.requestFail))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, self.successRange.contains(statusCode) else {
                completionHandler(.failure(.statusCodeError))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.invalidData))
                return
            }
            
            completionHandler(.success(data))
        }
        task.resume()
    }
    
    func requestProductInformation(productID: Int, completionHandler: @escaping (Result<ProductInformation, Error>) -> Void) {
        guard let url = URLManager.productInformation(productID).url else {
            completionHandler(.failure(URLSessionError.urlIsNil))
            return
        }
        
        let request = createRequest(url, HTTPMethod.get)
        performDataTask(with: request, completionHandler)
    }
    
    func requestProductList(pageNumber: Int, itemsPerPage: Int, completionHandler: @escaping (Result<ProductList, Error>) -> Void) {
        guard let url = URLManager.productList(pageNumber, itemsPerPage).url else {
            completionHandler(.failure(URLSessionError.urlIsNil))
            return
        }
        
        let request = createRequest(url, HTTPMethod.get)
        performDataTask(with: request, completionHandler)
    }
}



//class Toni: APIManageable {
//    var shouldFail: Bool = false
//
//    func requestProductList(pageNumber: Int, itemsPerPage: Int, completionHandler: @escaping (Result<ProductList, Error>) -> Void) {
//        if shouldFail {
//
//        } else {
//
//        }
//    }
//
//
//}

extension APIManager {
    func performDataTask<Element: Decodable>(with request: URLRequest, _ completionHandler: @escaping (Result<Element, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionHandler(.failure(URLSessionError.requestFail))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, self.successRange.contains(statusCode) else {
                completionHandler(.failure(URLSessionError.statusCodeError))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(URLSessionError.invalidData))
                return
            }
            
            guard let parsedData = Parser<Element>.decode(from: data) else {
                completionHandler(.failure(ParserError.decodeFail))
                return
            }
            completionHandler(.success(parsedData))
        }
        task.resume()
    }
}
