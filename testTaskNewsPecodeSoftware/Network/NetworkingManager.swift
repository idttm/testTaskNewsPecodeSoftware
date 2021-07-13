
import Foundation

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
    
    case topHeadlines(country: String, apiKey: String, page: Int)
    case category(category: String, apiKey: String, page: Int)
    case sources(apyKey: String, page: Int, sources: String)
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
        case .topHeadlines(_, _, _):
            return "top-headlines"
        case .category(_, _, _):
            return "top-headlines"
        case .sources(_, _, _):
            return "top-headlines"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .topHeadlines( country: let country, apiKey: let apiKey, page: let page):
            return .requestParameters(urlParametrs: ["country": country,
                                                     "apiKey": apiKey,
                                                     "page": page,
                                                     ])
        case .category(category: let category, apiKey: let apiKey, page: let page):
            return .requestParameters(urlParametrs: ["category": category,
                                                     "apiKey": apiKey,
                                                     "page": page])
        case .sources(apyKey: let apiKey , page: let page, sources: let sources):
            return .requestParameters(urlParametrs: [ "apiKey": apiKey,
                                                      "page": page,
                                                      "sources": sources])
       
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
                    print(request.url)
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
                    print("успех")
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
        return task
    }
    let apiKey = "5d47805079624a8c9b7bd7843c9e906c"
    
    func getCountry(page: Int, country: String, completion: @escaping (Result<[Articles],Error>) -> Void) {
        let route = NewsEndPoint.topHeadlines(country: country, apiKey: apiKey, page: page)
        
        self.fetchData(route, model: News.self) { [weak self] result in
            switch result {
            case .success(let model):
                guard let totalPage = model.totalResults else { return }
                if page <= totalPage {
                    completion(.success(model.articles!))
                    print(model.totalResults)
                }
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
    func getCategory(page: Int, category: String, completion: @escaping (Result<[Articles],Error>) -> Void) {
        let route = NewsEndPoint.category(category: category, apiKey: apiKey, page: page)
        
        self.fetchData(route, model: News.self) { [weak self] result in
            switch result {
            case .success(let model):
                if page <= model.totalResults! {
                    completion(.success(model.articles!))
                    print(model.totalResults)
                }
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
    func getSources(page: Int, sources: String, completion: @escaping (Result<[Articles],Error>) -> Void) {
        let route = NewsEndPoint.sources(apyKey: apiKey, page: page, sources: sources)
        
        self.fetchData(route, model: News.self) { [weak self] result in
            switch result {
            case .success(let model):
                if page <= model.totalResults! {
                    completion(.success(model.articles!))
                    print(model.totalResults)
                }
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
    
 
    func parseJSON<T:Decodable>(type: T.Type, data: Data) throws -> T {
        let decoder = JSONDecoder()
//        print(String(data: data, encoding: .utf8))
        return try decoder.decode(type, from: data)
    }
    
}
