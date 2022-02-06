//
//  Beer.swift
//  Brewery
//
//  Created by LeeHsss on 2022/02/06.
//

import Foundation

struct Beer: Decodable {
    let id: Int?
    let name: String?
    let tagline: String?
    let description: String?
    let image_url: String?
    let food_pairing: [String]?
    let brewers_tips: String?
    
    //MARK: Trick
    var taglineString: String {
        let tags = tagline?.components(separatedBy: ". ")
        let hashTags = tags?.map {
            "#" + $0
        }
        
        return hashTags?.joined(separator: " ") ?? ""
    }
}
