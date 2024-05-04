//
//  NetworkService.swift
//  SchedulerAdminApp
//
//  Created by Dawid Grazawski on 21/04/2024.
//

import Foundation
import Combine
import SwiftData

func formatDateForAPI(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'" // ISO 8601 format
    formatter.timeZone = TimeZone(secondsFromGMT: 0) // Coordinated Universal Time
    return formatter.string(from: date)
}

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
    case editDelete = "/"
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
//        request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImU3NTdjZGM5LWFlNDYtNGViNS1iMDk0LWUyYjM1NDhjYjQwZiJ9.wfbD3sGHiX9CIx3O88a70v3km2sFF4ZkitH4S8cD5ec", forHTTPHeaderField: "x-access-token")
        if let requestBody = body {
            request.httpBody = requestBody
        }
        return request
    }
    
    
}

class NetworkService: ObservableObject {
//    var url: URL
//    var request: URLRequest
    var cancellables = Set<AnyCancellable>()
    @Published var showAlert: Bool = false
    @Published var message: String? = nil
    @Published var statusCode: Int? = nil
    @Published var rooms: [RoomModel] = []
    @Published var subjects: [SubjectModel] = []
    @Published var lecturers: [LecturerModel] = []
    @Published var meetings: [MeetingModel] = []
    @Published var schedules: [ScheduleModel] = []
    @Published var groups: [GroupModel] = []
    var decoder: JSONDecoder {
        var decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    deinit {
        cancellables.removeAll()
    }
    
//    init(url: URL, request: URLRequest) {
//        self.url = url
//        self.request = request
//    }
    
    func getRooms(request: URLRequest, completion: @escaping () -> Void) {
        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap { output -> (data: Data, statusCode: Int) in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                return (data: output.data, statusCode: httpResponse.statusCode)
            }
            .mapError { error -> Error in
                return error as Error
            }
            .flatMap { output -> AnyPublisher<([RoomModel], Int), Error> in
                Just(output.data)
                    .decode(type: [RoomModel].self, decoder: JSONDecoder())
                    .mapError { error in
                        return error
                    }
                    .map { decodedData -> ([RoomModel], Int) in
                        (decodedData, output.statusCode)
                    }
                    .eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Success")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.message = error.localizedDescription
                }
            }, receiveValue: { [weak self] decodedData, statusCode in
                print("received \(decodedData.count) rooms")
                self?.rooms = decodedData
                print("saved in network: \(self?.rooms.count) rooms")
                self?.statusCode = statusCode
                completion()
            })
            .store(in: &cancellables)
    }
    
    func getSubjects(request: URLRequest, completion: @escaping () -> Void) {
        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap { output -> (data: Data, statusCode: Int) in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                return (data: output.data, statusCode: httpResponse.statusCode)
            }
            .mapError { error -> Error in
                return error as Error
            }
            .flatMap { output -> AnyPublisher<([SubjectModel], Int), Error> in
                Just(output.data)
                    .decode(type: [SubjectModel].self, decoder: JSONDecoder())
                    .mapError { error in
                        return error
                    }
                    .map { decodedData -> ([SubjectModel], Int) in
                        (decodedData, output.statusCode)
                    }
                    .eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Success")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.message = error.localizedDescription
                }
            }, receiveValue: { [weak self] decodedData, statusCode in
                print("received \(decodedData.count) subjects")
                self?.subjects = decodedData
                print("saved in network: \(self?.subjects.count) subjects")
                self?.statusCode = statusCode
                completion()
            })
            .store(in: &cancellables)
    }
    
    func getLecturers(request: URLRequest, completion: @escaping () -> Void) {
        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap { output -> (data: Data, statusCode: Int) in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                return (data: output.data, statusCode: httpResponse.statusCode)
            }
            .mapError { error -> Error in
                return error as Error
            }
            .flatMap { output -> AnyPublisher<([LecturerModel], Int), Error> in
                Just(output.data)
                    .decode(type: [LecturerModel].self, decoder: JSONDecoder())
                    .mapError { error in
                        return error
                    }
                    .map { decodedData -> ([LecturerModel], Int) in
                        (decodedData, output.statusCode)
                    }
                    .eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Success")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.message = error.localizedDescription
                }
            }, receiveValue: { [weak self] decodedData, statusCode in
                print("received \(decodedData.count) lecturers")
                self?.lecturers = decodedData
                print("saved in network: \(self?.lecturers.count) lecturers")
                self?.statusCode = statusCode
                completion()
            })
            .store(in: &cancellables)
    }
    
    func getMeetings(request: URLRequest, completion: @escaping () -> Void) {
        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap { output -> (data: Data, statusCode: Int) in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                return (data: output.data, statusCode: httpResponse.statusCode)
            }
            .mapError { error -> Error in
                return error as Error
            }
            .flatMap { output -> AnyPublisher<([MeetingModel], Int), Error> in
                Just(output.data)
                    .decode(type: [MeetingModel].self, decoder: self.decoder)
                    .mapError { error in
                        return error
                    }
                    .map { decodedData -> ([MeetingModel], Int) in
                        (decodedData, output.statusCode)
                    }
                    .eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Success")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.message = error.localizedDescription
                }
            }, receiveValue: { [weak self] decodedData, statusCode in
                print("received \(decodedData.count) meetings")
                self?.meetings = decodedData
                print("saved in network: \(self?.meetings.count) meetings")
                self?.statusCode = statusCode
                completion()
            })
            .store(in: &cancellables)
    }
    
    func getSchedules(request: URLRequest, completion: @escaping () -> Void) {
        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap { output -> (data: Data, statusCode: Int) in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                return (data: output.data, statusCode: httpResponse.statusCode)
            }
            .mapError { error -> Error in
                return error as Error
            }
            .flatMap { output -> AnyPublisher<([ScheduleModel], Int), Error> in
                Just(output.data)
                    .decode(type: [ScheduleModel].self, decoder: JSONDecoder())
                    .mapError { error in
                        return error
                    }
                    .map { decodedData -> ([ScheduleModel], Int) in
                        (decodedData, output.statusCode)
                    }
                    .eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Success")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.message = error.localizedDescription
                }
            }, receiveValue: { [weak self] decodedData, statusCode in
                print("received \(decodedData.count) schedules")
                self?.schedules = decodedData
                print("saved in network: \(self?.schedules.count) schedules")
                self?.statusCode = statusCode
                completion()
            })
            .store(in: &cancellables)
    }
    
    func getGroups(request: URLRequest, completion: @escaping () -> Void) {
        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap { output -> (data: Data, statusCode: Int) in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                return (data: output.data, statusCode: httpResponse.statusCode)
            }
            .mapError { error -> Error in
                return error as Error
            }
            .flatMap { output -> AnyPublisher<([GroupModel], Int), Error> in
                Just(output.data)
                    .decode(type: [GroupModel].self, decoder: JSONDecoder())
                    .mapError { error in
                        return error
                    }
                    .map { decodedData -> ([GroupModel], Int) in
                        (decodedData, output.statusCode)
                    }
                    .eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Success")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.message = error.localizedDescription
                }
            }, receiveValue: { [weak self] decodedData, statusCode in
                print("received \(decodedData.count) groups")
                self?.groups = decodedData
                print("saved in network: \(self?.groups.count) groups")
                self?.statusCode = statusCode
                completion()
            })
            .store(in: &cancellables)
    }
    
    func sendDataGetResponseWithCodeOnly(request: URLRequest) {
        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap { output -> (data: Data, statusCode: Int) in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                return (data: output.data, statusCode: httpResponse.statusCode)
            }
            .mapError { error -> Error in
                return error as Error
            }
            .flatMap { output -> AnyPublisher<(APIResponse, Int), Error> in
                Just(output.data)
                    .decode(type: APIResponse.self, decoder: JSONDecoder())
                    .mapError { error in
                        return error
                    }
                    .map { decodedData -> (APIResponse, Int) in
                        (decodedData, output.statusCode)
                    }
                    .eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Success")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.message = error.localizedDescription
                }
            }, receiveValue: { [weak self] decodedData, statusCode in
                //                print("received \(statusCode)")
                self?.message = decodedData.message
                self?.statusCode = statusCode
                self?.showAlert = true
            })
            .store(in: &cancellables)
    }
    
    func proba(request: URLRequest) {
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
            .store(in: &cancellables)

    }
    
    func proba2(request: URLRequest) -> AnyPublisher<Data,Error> {
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
