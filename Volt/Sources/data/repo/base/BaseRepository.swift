//
//  BaseRepository.swift
//  Volt
//
//  Created by Vitalii Vynohradov on 10.06.2021.
//
import CoreData
import Foundation

protocol BaseRepositoryProtocol {
//    func load(with id: Int32?, forceFetch force: Bool)
//    func post(endpoint: EndpointProtocol, parameters: [String: Any]?)
//    func delete(endpoint: EndpointProtocol, parameters: [String: Any]?)
//    func clear()

    func loadLocal(with id: Int32?)
    func postLocal(parameters: [String: Any])
    func deleteLocal(id: Int32)
    func clear()
}

extension BaseRepositoryProtocol {
//    func load(with id: Int32? = nil, forceFetch force: Bool = false) {
//        return load(with: id, forceFetch: force)
//    }

    func loadLocal(with id: Int32? = nil) {
        return loadLocal(with: id)
    }
}

class BaseRepository<E: EntityFetchProtocol/*, R: ResponseProtocol*/>: ObservableObject {
    @Published var isLoading = false
    @Published var data = [E]()
    @Published var error: RepositoryError?
    @Published var isErrorOccur = false

    private var dataService: BaseDataService<E/*, R*/>
//    private var apiService: BaseApiService<R>

    init(dataService: BaseDataService<E/*, R*/>/*, apiService: BaseApiService<R>*/) {
        self.dataService = dataService
//        self.apiService = apiService
    }
}

// MARK: - implementation
extension BaseRepository: BaseRepositoryProtocol {
//    func load(with id: Int32?, forceFetch force: Bool) {
//        self.isLoading = true
//        guard force == false else {
//            fetchAndLoad(id: id)
//            return
//        }
//
//        self.dataService.load(id: id) { result in
//            switch result {
//            case .failure(let error):
//                self.publishResult(.failure(.dbError(error)))
//            case .success(let data):
//                switch data.isEmpty {
//                case true:
//                    self.fetchAndLoad(id: id)
//                case false:
//                    self.publishResult(.success(data))
//                }
//            }
//        }
//    }
//
//    func post(endpoint: EndpointProtocol, parameters: [String: Any]?) {
//        self.isLoading = true
//        self.apiService.upload(endpoint: endpoint, parameters: parameters) { result in
//            switch result {
//            case .success():
//                self.load(forceFetch: true)
//            case .failure(let error):
//                self.publishResult(.failure(.networkError(error)))
//            }
//        }
//    }
//
//    func delete(endpoint: EndpointProtocol, parameters: [String: Any]?) {
//        self.isLoading = true
//        self.apiService.delete(endpoint: endpoint, parameters: parameters) { result in
//            switch result {
//            case .success():
//                self.load(forceFetch: true)
//            case .failure(let error):
//                self.publishResult(.failure(.networkError(error)))
//            }
//        }
//    }

    func loadLocal(with id: Int32?) {
        isLoading = true
        loadSaved(id: id)
    }

    func postLocal(parameters: [String: Any]) {
        isLoading = true

        switch dataService.isDataExistsWithId(parameters["id"] as? Int32) {
        case true:
            publishResult(.failure(.dbError(.badRequest)))
        default:
            dataService.addItem(parameters: parameters)
            loadSaved()
        }
    }

    func deleteLocal(id: Int32) {
        isLoading = true
        dataService.deleteItem(id: id)
        loadSaved()
    }

    func clear() {
        dataService.clear()
        publishResult(.success([E]()))
    }
}

// MARK: - private
private extension BaseRepository {
    func loadSaved(id: Int32? = nil) {
        dataService.load(id: id) { result in
            switch result {
            case .failure(let error):
                self.publishResult(.failure(.dbError(error)))
            case .success(let data):
                self.publishResult(.success(data))
            }
        }
    }

    func publishResult(_ result: Result<[E], RepositoryError>) {
        DispatchQueue.main.async {
            switch result {
            case .success(let data):
                self.error = nil
                self.data = data
                self.isErrorOccur = false
            case .failure(let error):
                self.error = error
                self.isErrorOccur = true
            }
            self.isLoading = false
        }
    }
}
