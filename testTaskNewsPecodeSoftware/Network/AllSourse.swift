


import Foundation

// MARK: - Sourse
struct AllSourse: Codable {
    let status: String
    let sources: [InfoSource]
}

// MARK: - Source
struct InfoSource: Codable {
    let id, name, sourceDescription: String
    let url: String
    let category: Category
    let language, country: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case sourceDescription = "description"
        case url, category, language, country
    }
}

enum Category: String, Codable {
    case business = "business"
    case entertainment = "entertainment"
    case general = "general"
    case health = "health"
    case science = "science"
    case sports = "sports"
    case technology = "technology"
}

