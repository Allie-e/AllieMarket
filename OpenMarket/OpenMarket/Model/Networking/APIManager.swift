import Foundation

class APIManager: APIManageable {
    let successRange = 200..<300
    
    func createRequest(_ url: URL, _ httpMethod: HTTPMethod) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.description

        return request
    }
    
    func requestHealthChecker(completionHandler: @escaping (Result<Data, URLSessionError>) -> Void) {
        guard let url = URLManager.healthChecker.url else {
            completionHandler(.failure(.urlIsNil))
            return
        }
        
        let request = createRequest(url, .get)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionHandler(.failure(.requestFail))
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode,
               !self.successRange.contains(statusCode) {
                completionHandler(.failure(.statusCodeError(statusCode)))
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
        
        let request = createRequest(url, .get)
        performDataTask(with: request, completionHandler)
    }
    
    func requestProductList(pageNumber: Int, itemsPerPage: Int, completionHandler: @escaping (Result<ProductList, Error>) -> Void) {
        guard let url = URLManager.productList(pageNumber, itemsPerPage).url else {
            completionHandler(.failure(URLSessionError.urlIsNil))
            return
        }
        
        let request = createRequest(url, .get)
        performDataTask(with: request, completionHandler)
    }
    
    func registerProduct(information: NewProductInformation, image: [NewProductImage], completionHandler: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URLManager.productRegister.url else {
            completionHandler(.failure(URLSessionError.requestFail))
            return
        }
        
        let boundary = generateBoundaryString()
        guard let encodedData = Parser.encodeToString(from: information) else { return }
        let params = ["params": encodedData]
        
        var requset = createRequest(url, .post)
        requset.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        requset.addValue("f726f2f8-7214-11ec-abfa-89ebf1f2fdc1", forHTTPHeaderField: "identifier")
        requset.httpBody = createBody(parameters: params, boundary: boundary, images: image)
        dataTask(with: requset, completionHandler)
    }
}

// MARK: - Create Request Body
extension APIManager {
    func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    func createBody(parameters: [String: String], boundary: String, images: [NewProductImage]?) -> Data {
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.append(boundaryPrefix.data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        if let images = images {
            for image in images {
                body.append(boundaryPrefix.data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"images[]\"; filename=\"\(image.fileName)\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/\(image.type)\r\n\r\n".data(using: .utf8)!)
                body.append(image.data)
                body.append("\r\n".data(using: .utf8)!)
            }
        }
        
        body.append(boundaryPrefix.data(using: .utf8)!)
        
        return body
    }
}

extension APIManager {
    @discardableResult
    func performDataTask<Element: Decodable>(with request: URLRequest, _ completionHandler: @escaping (Result<Element, Error>) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionHandler(.failure(URLSessionError.requestFail))
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode,
               !self.successRange.contains(statusCode) {
                completionHandler(.failure(URLSessionError.statusCodeError(statusCode)))
            }
            
            guard let data = data else {
                completionHandler(.failure(URLSessionError.invalidData))
                return
            }
            
            guard let parsedData = Parser.decode(from: data, type: Element.self) else {
                completionHandler(.failure(ParserError.decodeFail))
                return
            }
            completionHandler(.success(parsedData))
        }
        task.resume()
        
        return task
    }
    
    func dataTask(with request: URLRequest, _ completionHandler: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionHandler(.failure(URLSessionError.requestFail))
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode,
               !self.successRange.contains(statusCode) {
                completionHandler(.failure(URLSessionError.statusCodeError(statusCode)))
            }
            
            guard let data = data else {
                completionHandler(.failure(URLSessionError.invalidData))
                return
            }
            completionHandler(.success(data))
        }
        task.resume()
    }
}
