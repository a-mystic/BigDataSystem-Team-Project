//
//  RecommendedMovies.swift
//  BigDataSystem
//
//  Created by a mystic on 4/30/24.
//

import SwiftUI
import AnimationKit

struct RecommendedMovies: View {
    @EnvironmentObject var recommendManager: RecommendManager
    @State private var showCongrate = true
    @State private var hate = true
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollViewReader { scroll in
                    ScrollView {
                        LottieView(jsonName: "bear", loopMode: .repeat(3))
                            .frame(width: 170, height: 170)
                        if !recommendManager.isFetching {
                            recommendedMovieList(in: geometry.size)
                        } else {
                            ZStack {
                                Color.clear
                                    .frame(width: geometry.size.width)
                                ProgressView()
                                    .scaleEffect(2)
                                    .tint(.gray)
                            }
                        }
                    }
                    .onChange(of: hate) { _ in
                        scroll.scrollTo(0, anchor: .top)
                    }
                }
                if hate {
                    hateButton(in: geometry)
                }
            }
            .overlay {
//                if showCongrate {
//                    LottieView(jsonName: "congratulations", loopMode: .repeat(2))
//                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showCongrate = false
                    }
                }
            }
        }
    }
    
    struct animationConfig: AnimatableStyle {
      var opacity: AnimationValue<CGFloat> = .init(from: 0, to: 1)
      var offsetX: AnimationValue<CGFloat> = .init(from: 0, to: 0)
      var offsetY: AnimationValue<CGFloat> = .init(from: 50, to: 0)
      var rotation: AnimationValue<Double> = .init(from: 0, to: 0)
      var scale: AnimationValue<Double> = .init(from: 1.1, to: 1)
      var blur: AnimationValue<Double> = .init(from: 0, to: 0)
      var delay: Double = 0.05
      var animation: Animation = .bouncy(duration: 1)
      var maxAnimationCount: Int = 20
    }
    
    private func recommendedMovieList(in size: CGSize) -> some View {
        AnimatedForEach(recommendManager.recommendedMovies, preset: animationConfig()) { movie in
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/original/\(movie.posterPath)")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } placeholder: {
                    RoundedRectangle(cornerRadius: 12)
                        .padding()
                        .foregroundStyle(.gray.opacity(0.5))
                        .frame(width: 200, height: 200)
                }
                VStack(alignment: .leading) {
                    Text("제목: \(movie.title)")
                    Text("장르: \(makeGenreToText(movie.genres))")
                    Text("평점: \(String(format: "%.2f",movie.voteAverage))")
                }
                .padding()
                .background(Color.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 12))
            }
            .padding()
            .frame(width: size.width * 0.9)
            .background(Color.random.opacity(0.3), in: RoundedRectangle(cornerRadius: 12))
            .padding()
        }
    }
    
    private func makeGenreToText(_ genres: [String]) -> String {
        var text = ""
        for genre in genres {
            text += genre + ","
        }
        text.removeLast()
        return text
    }
    
    @AppStorage("selectedPositiveCategoriesAppStorage") var selectedPositiveCategoriesAppStorage = Data()
    @AppStorage("selectedNegativeCategoriesAppStorage") var selectedNegativeCategoriesAppStorage = Data()
    
    private var selectedPositiveCategories: [String] {
        if let data = try? JSONDecoder().decode([String].self, from: selectedPositiveCategoriesAppStorage) {
            return data
        }
        return []
    }
    
    private var selectedNegativeCategories: [String] {
        if let data = try? JSONDecoder().decode([String].self, from: selectedNegativeCategoriesAppStorage) {
            return data
        }
        return []
    }
    
    private var genres: String {
        var str = ""
        if recommendManager.currentEmotion == 1 {
            for genre in selectedPositiveCategories {
                str += genre + ","
            }
        } else {
            for genre in selectedNegativeCategories {
                str += genre + ","
            }
        }
        str.removeLast()
        return str
    }
    
    private func hateButton(in geometry: GeometryProxy) -> some View {
        Button {
            Task {
                hate = false
                recommendManager.isFetching = true
                await recommendManager.getMovies(genres: genres)
                recommendManager.isFetching = false
            }
        } label: {
            Text("마음에 안들어요")
                .padding(.vertical, 9)
                .frame(maxWidth: geometry.size.width * 0.8)
        }
        .padding(.vertical, 9)
        .foregroundStyle(.white)
        .background(.red.opacity(0.7), in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    let manager = RecommendManager()
    manager.setTestMovies()
    return RecommendedMovies()
        .environmentObject(manager)
}
