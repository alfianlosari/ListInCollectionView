//
//  Character.swift
//  CharactersGrid
//
//  Created by Alfian Losari on 9/22/20.
//

import Foundation

struct Character: Codable, Hashable, Identifiable {
    var id: String {
        name
    }
    
    let name: String
    let imageName: String
    let category: String
    let job: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case imageName
        case category
        case job
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(category)
        hasher.combine(job)
    }    
}
