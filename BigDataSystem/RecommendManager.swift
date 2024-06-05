//
//  RecommendManager.swift
//  BigDataSystem
//
//  Created by a mystic on 4/30/24.
//

import SwiftUI

@MainActor
class RecommendManager: ObservableObject {
    @Published private(set) var currentEmotion = 0
    @Published private(set) var recommendedMovies = [Movie]()
    @Published var isFetching = false
    
    var recommendedMovieList = Set<Int>()
    @AppStorage("recommendedMovieListAppStorage") var recommendedMovieListAppStorage = Data()
    
    func setCurrentEmotion(to value: Int) {
        currentEmotion = value
    }
    
    func getMovies(genres: String) async {
        loadMovieList()
        var movieList = ""
        for movie in recommendedMovieList {
            movieList += String(movie) + ","
        }
        if let last = movieList.last, last == "," {
            movieList.removeLast()
        }
        let url = "http://127.0.0.1:8000/" + "?genres=\(genres)&recommendedMovieList=\(movieList)"
        guard let encodingUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodingUrl) else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let responseData = try JSONDecoder().decode(MovieResponse.self, from: data)
            recommendedMovies = responseData.movies
            for movie in recommendedMovies {
                recommendedMovieList.insert(movie.movieId)
            }
            saveMovieList()
            isFetching = false
        } catch {
            print(error)
        }
    }
    
    private func saveMovieList() {
        while recommendedMovieList.count > 500 {
            recommendedMovieList.removeFirst()
        }
        if let movieData = try? JSONEncoder().encode(recommendedMovieList) {
            recommendedMovieListAppStorage = movieData
        }
    }
    
    private func loadMovieList() {
        if let movieData = try? JSONDecoder().decode(Set<Int>.self, from: recommendedMovieListAppStorage) {
            recommendedMovieList = movieData
        }
    }
    
    func setTestMovies() {
        recommendedMovies.append(Movie(title: "Iron Man", revenue: 8712123974, posterPath: "https://m.media-amazon.com/images/I/61tVHAlfrwL._AC_UF894,1000_QL80_.jpg", genres: ["Action", "SF", "Science Fiction"], voteAverage: 9.44, movieId: 470))
        recommendedMovies.append(Movie(title: "Iron Man2", revenue: 812931237, posterPath: "https://m.media-amazon.com/images/M/MV5BZGVkNDAyM2EtYzYxYy00ZWUxLTgwMjgtY2VmODE5OTk3N2M5XkEyXkFqcGdeQXVyNTgzMDMzMTg@._V1_.jpg", genres: ["Action", "SF", "Science Fiction"], voteAverage: 9.1, movieId: 471))
        recommendedMovies.append(Movie(title: "Iron Man3", revenue: 9172316723, posterPath: "https://i.ebayimg.com/images/g/9GAAAOSwaJli~NsU/s-l1200.webp", genres: ["Action", "SF", "Science Fiction"], voteAverage: 9.2, movieId: 472))
    }
}
