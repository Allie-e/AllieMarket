import UIKit

enum Parser {
    static func decode<Element: Decodable>(from data: Data, type: Element.Type) -> Element? {
        var products: Element?
        
        do {
            products = try JSONDecoder().decode(Element.self, from: data)
        } catch {
            print("error message : \(error.localizedDescription)")
        }

        return products
    }
    
    static func encode<Element: Encodable>(from data: Element) -> Data? {
        var products: Data?
        
        do {
            products = try JSONEncoder().encode(data)
        } catch {
            print("error message : \(error.localizedDescription)")
        }

        return products
    }
    
    static func encodeToString<Element: Encodable>(from data: Element) -> String? {
        var string: String?
        
        do {
            let encodedData = try JSONEncoder().encode(data)
            string = String(data: encodedData, encoding: .utf8)
        } catch {
            print("error message : \(error.localizedDescription)")
        }
        
        return string
    }
}

