import Foundation

class APIManager {
    let apiHost = "https://market-training.yagom-academy.kr/"
    var healthChecker: String?
    var product: ProductInformation?
    var productList: ProductList?
    var semaphore = DispatchSemaphore(value: 0)
    let successRange = 200..<300
    
    func requestHealthChecker() {
        let url = apiHost + "healthChecker"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.httpMethod = HTTPMethod.get
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return print(URLSessionError.requestFail.errorDescription)
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  self.successRange.contains(statusCode) else {
                      return print(URLSessionError.statusCodeError.errorDescription)
            }
            
            guard let data = data else {
                print(URLSessionError.invalidData.errorDescription)
                self.semaphore.signal()
                
                return
            }
            
            self.healthChecker = String(data: data, encoding: .utf8)!
            self.semaphore.signal()
        }
        
        task.resume()
        self.semaphore.wait()
    }
    
    func requestProductInformation(productID: Int) {
        let url = apiHost + "/api/products/" + "\(productID)"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.httpMethod = HTTPMethod.get
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return print(URLSessionError.requestFail.errorDescription)
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  self.successRange.contains(statusCode) else {
                      return print(URLSessionError.statusCodeError.errorDescription)
            }
            
            guard let data = data else {
                print(URLSessionError.invalidData.errorDescription)
                self.semaphore.signal()
                
                return
            }
            
            do {
                self.product = try Parser.decode(from: data)
            } catch {
                print(error)
            }
            
            self.semaphore.signal()
        }
        
        task.resume()
        self.semaphore.wait()
    }
    
    func requestProductList() {
        let url = apiHost + "/api/products?page-no=1&items-per-page=10"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.httpMethod = HTTPMethod.get
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return print(URLSessionError.requestFail.errorDescription)
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  self.successRange.contains(statusCode) else {
                      return print(URLSessionError.statusCodeError.errorDescription)
            }
            
            guard let data = data else {
                print(URLSessionError.invalidData.errorDescription)
                self.semaphore.signal()
                
                return
            }
            
            do {
                self.productList = try Parser.decode(from: data)
            } catch {
                print(error)
            }
            
            self.semaphore.signal()
        }
        
        task.resume()
        self.semaphore.wait()
    }
}
