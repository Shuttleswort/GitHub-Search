//
//  Repository.swift
//  Search
//
//  Created by Vladimir Abdrakhmanov on 5/23/18.
//  Copyright © 2018 Vladimir Abdrakhmanov. All rights reserved.
//

import Foundation

struct RepositoryResult: Decodable {
    let items: [Repository]

    enum CodingKeys: String, CodingKey { case items }

}

struct Repository: Decodable {
    let id: Int
    let name: String
    let url: String
    let stars: Int
    let description: String?

    enum CodingKeys: String, CodingKey {
        case url = "html_url"
        case stars = "stargazers_count"
        case id, name, description
    }
}


extension Repository: Equatable {

    static func == (lhs: Repository, rhs: Repository) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.url == rhs.url &&
            lhs.stars == rhs.stars &&
            lhs.description == rhs.description
    }


}
