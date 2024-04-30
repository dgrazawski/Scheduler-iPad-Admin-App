//
//  NetworkService.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 21/04/2024.
//

import Foundation
import Combine

enum HTTPMethod: String {
    case post = "POST"
    case put = "PUT"
    case get = "GET"
    case delete = "DELETE"
}

enum Routes: String {
    case account = "/account"
    case schedule = "/schedule"
    case lecturer = "/lecturer"
    case room = "/room"
    case subject = "/subject"
    case meeting = "/meeting"
    case group = "/group"
    case allocation = "/allocation"
    case cyclic = "/cyclic"
    case nonCyclic = "/non_cyclic"
    
}

enum Endpoint: String {
    case register = "/register"
    case login = "/login"
    case changePass = "/change_pass"
    case add = ""
    case edit, delete = "/"
    case getAll = "/get_all"
}

struct APIResponse: Codable {
    let message: String
   // let code: Int
}

struct LoginData: Codable {
    let username: String
    let password: String
}

struct Token: Codable {
    let token: String
}

struct ChangePassword: Codable{
    let old_pass: String
    let new_pass: String
}

struct URLRequestBuilder {
    var baseURL: String = "127.0.0.1"
    var basePort: Int = 5000
    
    
    func createURL(route: Routes, endpoint: Endpoint, parameter: String = "") -> URL? {
        var components: URLComponents = URLComponents()
        components.scheme = "http"
        components.host = baseURL
        components.port = basePort
        components.path = route.rawValue + endpoint.rawValue + parameter
        return components.url
    }
    
    func createRequest(method: HTTPMethod, url: URL, body: Data? = nil) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImU3NTdjZGM5LWFlNDYtNGViNS1iMDk0LWUyYjM1NDhjYjQwZiJ9.wfbD3sGHiX9CIx3O88a70v3km2sFF4ZkitH4S8cD5ec", forHTTPHeaderField: "x-access-token")
        if let requestBody = body {
            request.httpBody = requestBody
        }
        return request
    }
    
    
}

class NetworkService {
    var url: URL
    var request: URLRequest
    var cancelable = Set<AnyCancellable>()
    
    init(url: URL, request: URLRequest) {
        self.url = url
        self.request = request
    }
    
    func proba() {
        URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return data
                
            }
            .decode(type: APIResponse.self, decoder: JSONDecoder())
            .sink { (completion) in
                print("completion \(completion)")
            } receiveValue: { [weak self] (response) in
                print(response.message)
            }
            .store(in: &cancelable)

    }
    
    func proba2() -> AnyPublisher<Data,Error> {
      return  URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(mappingOutput)
            .eraseToAnyPublisher()
    }
    
    func mappingOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        return output.data

    }
}
