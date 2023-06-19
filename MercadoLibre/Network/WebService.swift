//
//  WebService.swift
//  MercadoLibre
//
//  Created by Jose Angel Ramirez Garza on 16/06/23.
//

import Foundation

class WebService {
    
    private var urlString: String
    private var urlSession: URLSession
    
    init(urlString: String, urlSession: URLSession = .shared) {
        self.urlString = urlString
        self.urlSession = urlSession
    }
    
    func search(with text: String, completionHandler: @escaping(MLSearchResults?, MLErrors?) -> Void) {
        if URL(string: urlString) == nil {
            completionHandler(nil, MLErrors.invalidRequestURLStringError)
            return
        }

        var urlComponents = URLComponents(string: urlString)
        
        var queryItems: [URLQueryItem] = urlComponents?.queryItems ?? []
        
        queryItems.append(URLQueryItem(name: "q", value: text))
        urlComponents?.queryItems = queryItems

        guard let url = urlComponents?.url else {
            completionHandler(nil, MLErrors.invalidRequestURLStringError)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = WebService.timeoutRequest
        //print(request)
        
        let dataTask = urlSession.dataTask(with: request) { (data, response, error) in
            if let data = data, let jsonResponseModel = try? JSONDecoder().decode(MLSearchResults.self, from: data) {
                completionHandler(jsonResponseModel, nil)
            } else {
                if error == nil {
                    completionHandler(nil, MLErrors.responseModelParsingError)
                } else {
                    completionHandler(nil, MLErrors.couldNotConnectToServer)
                }
            }
        }
        
        dataTask.resume()
    }
    
    func getProduct(with id: String, completionHandler: @escaping([MLItem]?, MLErrors?) -> Void) {
        if URL(string: urlString) == nil {
            completionHandler(nil, MLErrors.invalidRequestURLStringError)
            return
        }

        var urlComponents = URLComponents(string: urlString)
        
        var queryItems: [URLQueryItem] = urlComponents?.queryItems ?? []
        
        queryItems.append(URLQueryItem(name: "ids", value: id))
        urlComponents?.queryItems = queryItems

        guard let url = urlComponents?.url else {
            completionHandler(nil, MLErrors.invalidRequestURLStringError)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = WebService.timeoutRequest
        //print(request)
        
        let dataTask = urlSession.dataTask(with: request) { (data, response, error) in
            if let data = data, let jsonResponseModel = try? JSONDecoder().decode([MLItem].self, from: data) {
                completionHandler(jsonResponseModel, nil)
            } else {
                if error == nil {
                    completionHandler(nil, MLErrors.responseModelParsingError)
                } else {
                    completionHandler(nil, MLErrors.couldNotConnectToServer)
                }
            }
        }
        
        dataTask.resume()
    }
}

private extension WebService {
    static let timeoutRequest = 10.0
}
