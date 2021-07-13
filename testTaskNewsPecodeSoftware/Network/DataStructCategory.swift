

import Foundation

// MARK: - Category
struct Category: Codable {
    let status: String
    let totalResults: Int
    let articles: [ArticleCategory]
}

// MARK: - Article
struct ArticleCategory: Codable {
    let source: SourceCategory
    let author: String?
    let title: String
    let articleDescription: String?
    let url: String
    let urlToImage: String?
    let publishedAt: Date
    let content: String?

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
}

// MARK: - Source
struct SourceCategory: Codable {
    let id: String?
    let name: String
}


