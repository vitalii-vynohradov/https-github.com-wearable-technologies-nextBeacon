//
//  BaseApiService.swift
//  Volt
//
//  Created by Vitalii Vynohradov on 10.06.2021.
//

/*import Foundation

class BaseApiService<R: ResponseProtocol> {
    private let endpoint: EndpointProtocol

    private let dispatchQueue: DispatchQueue

    private let restClient: RestClientProtocol

    init(endpoint: EndpointProtocol, queueLabel: String, restClient: RestClientProtocol = RestClient()) {
        self.endpoint = endpoint
        self.dispatchQueue = DispatchQueue(label: queueLabel, qos: .userInitiated)
        self.restClient = restClient
    }

    func fetch(completion: @escaping (Result<[R], NetworkError>) -> Void) {
        let decodeType = R.decodeType()
        dispatchQueue.async {
            self.restClient.GET(
                decode: decodeType,
                decoder: JSONDecoder.default,
                endpoint: self.endpoint,
                parameters: nil,
                headers: nil,
                dispatchTo: self.dispatchQueue) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let result as [R]):
                            completion(.success(result))
                        case .success(let result as R):
                            completion(.success([result]))
                        case .failure(let error):
                            Logger.error("\(error)")
                            completion(.failure(error))
                        default:
                            Logger.error("Can't decode data: \(R.self)")
                        }
                    }
            }
        }
    }

    func upload(endpoint: EndpointProtocol,
                parameters: [String: Any]?,
                completion: @escaping (Result<Void, NetworkError>) -> Void) {
                    dispatchQueue.async {
                        self.restClient.POST(
                            endpoint: endpoint,
                            parameters: parameters,
                            headers: nil,
                            dispatchTo: self.dispatchQueue) { result in
                                DispatchQueue.main.async {
                                    switch result {
                                    case .success(_):
                                        completion(.success(()))
                                    case .failure(let error):
                                        Logger.error("\(error)")
                                        completion(.failure(error))
                                    }
                                }
                        }
                    }
    }

    func delete(endpoint: EndpointProtocol,
                parameters: [String: Any]?,
                completion: @escaping (Result<Void, NetworkError>) -> Void) {
                    dispatchQueue.async {
                        self.restClient.DELETE(
                            endpoint: endpoint,
                            parameters: parameters,
                            headers: nil) { result in
                                DispatchQueue.main.async {
                                    switch result {
                                    case .success(_):
                                        completion(.success(()))
                                    case .failure(let error):
                                        Logger.error("\(error)")
                                        completion(.failure(error))
                                    }
                                }
                        }
                    }
    }
}*/
