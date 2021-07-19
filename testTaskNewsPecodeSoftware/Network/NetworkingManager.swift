import Foundation

//    let apiKey = "5d47805079624a8c9b7bd7843c9e906c"
//    let apiKey = "b04ea92468c94c0498c9bb8d5d26eefa"
    let apiKey = "7c16a3ff91cf48fd8a28cd37030f0045"

enum NetworkError: Error {
    case somothingWentWrong
    case noData
    case parsingFailed
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
}

typealias Parameters = [String: Any]

enum HTTPTask {
    case request
    case requestParameters(urlParametrs: Parameters?)
}

enum NewsEndPoint: EndPointType {
    
    case countryAndCategory(country: String?, category: String?, sources: String?,  apiKey: String, page: Int)
    case allSources(apiKey: String)
}

extension NewsEndPoint {
    
    var environmentBaseURL: String { "https://newsapi.org/v2/" }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else {
            fatalError("failed to configure base URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .countryAndCategory(_, _, _, _, _):
            return "top-headlines"
        case .allSources(_):
            return "top-headlines/sources"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .countryAndCategory(let country, let category, let sources, let apiKey, let page):
            var params: [String: Any] = [:]
            if let country = country {
                params["country"] = country
            }
            if let sources = sources {
                params["sources"] = sources
            }
            if let category = category {
                params["category"] = category
            }
            params["apiKey"] = apiKey
            params["page"] = page
            return .requestParameters(urlParametrs: params)
        
        case .allSources(apiKey: let apiKey):
            return .requestParameters(urlParametrs: ["apiKey": apiKey])
        }
    }
}

class NetworkingManager {
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForResource = 30
        config.timeoutIntervalForRequest = 30
        let session = URLSession(configuration: config)
        return session
    }()
    
    func makeRequest(from route: EndPointType) -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path), cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 30.0)
        request.httpMethod = route.httpMethod.rawValue
        
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(urlParametrs: let urlParametrs):
                guard let url = request.url else { fatalError("NO URL") }
                if var urlComponts = URLComponents(url: url, resolvingAgainstBaseURL: false), let params = urlParametrs, !params.isEmpty {
                    urlComponts.queryItems = [URLQueryItem]()
                    for (key, value) in params {
                        let queryItem = URLQueryItem(name: key, value: "\(value)")
                        urlComponts.queryItems?.append(queryItem)
                    }
                    request.url = urlComponts.url
                }
                if request.value(forHTTPHeaderField: "Content-Type") == nil {
                    
                    request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
                }
            }
        }
        return request
    }
    
    @discardableResult
    func fetchData<T: Decodable>(_ route: EndPointType, model: T.Type, completion: @escaping (Result<T, Error>)  -> Void) -> URLSessionTask? {
        let request = makeRequest(from: route)
        let task = session.dataTask(with: request) { [unowned self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                do {
                    let test = try self.parseJSON(type: model.self, data: data)
                    completion(.success(test))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
        return task
    }

    func getCountry(page: Int, country: String?, category: String?, sources: String?, completion: @escaping (Result<[Article],Error>) -> Void) {
        let route = NewsEndPoint.countryAndCategory(country: country, category: category, sources: sources, apiKey: apiKey, page: page)
        
        self.fetchData(route, model: News.self) { result in
            switch result {
            case .success(let model):
                completion(.success(model.articles))
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
    
    func getAllSources(completion: @escaping (Result<[InfoSource],Error>) -> Void) {
    
        let route = NewsEndPoint.allSources(apiKey: apiKey)
        
        self.fetchData(route, model: AllSourse.self) { [weak self] result  in
            switch result {
            case .success(let model):
                completion(.success(model.sources))
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
        
    }
    
    func parseJSON<T:Decodable>(type: T.Type, data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }
    
}

