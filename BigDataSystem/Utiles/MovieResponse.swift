//
//  MovieModel.swift
//  BigDataSystem
//
//  Created by a mystic on 4/30/24.
//

import Foundation

struct Movie: Codable, Identifiable, Hashable {
    let title: String
    let revenue: Double
    let posterPath: String
    let genres: [String]
    let voteAverage: Double
    let movieId: Int
    
    var id: Int {
        movieId
    }
    
    private enum CodingKeys: String, CodingKey {
        case title
        case revenue
        case posterPath = "poster_path"
        case genres
        case voteAverage = "vote_average"
        case movieId = "id"
    }
}

struct MovieResponse: Codable {
    let movies: [Movie]
}
