//
//  MovieRecommender.swift
//  BigDataSystem
//
//  Created by a mystic on 4/30/24.
//

import SwiftUI

struct MovieRecommender: View {
    @State private var showDescription = false
    
    @AppStorage("userPreference") var userPreferenceIsNeed = true
    @EnvironmentObject var recommendManager: RecommendManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                background
                VStack {
                    Spacer()
                    dropBox()
                    Spacer()
                }
            }
            .navigationTitle("BigDataSystem")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .sheet(isPresented: $userPreferenceIsNeed, content: {
                EnterPreference(isShow: $userPreferenceIsNeed)
            })
        }
    }
    
    private var background: some View {
        ZStack(alignment: .bottom) {
            Color.gray.opacity(0.4)
            Rain()
            emojiSlider
        }
        .padding(.bottom)
    }
    
    @State private var showMovies = false
    
    private func dropBox() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .foregroundStyle(.ultraThinMaterial)
                .frame(width: 250, height: 250)
            VStack(spacing: 30) {
                Image(systemName: "face.smiling")
                    .imageScale(.large)
                    .font(.largeTitle)
                Text("Drop your emotion")
            }
            .foregroundStyle(.white.opacity(0.8))
        }
        .overlay {
            if recommendManager.isFetching {
                ProgressView()
                    .scaleEffect(2)
                    .tint(.white)
            }
        }
        .dropDestination(for: String.self) { items, location in
            drop(items)
        }
        .navigationDestination(isPresented: $showMovies) {
            RecommendedMovies()
        }
    }
    
    private func drop(_ items: [String]) -> Bool {
        if let item = items.first {
            Task {
                recommendManager.isFetching = true
                let emotion = calcEmotion(item)
                recommendManager.setCurrentEmotion(to: emotion)
                let startTime = CFAbsoluteTimeGetCurrent()
                await recommendManager.getMovies(genres: genres)
                let endTime = CFAbsoluteTimeGetCurrent()
                print(endTime-startTime)
                recommendManager.isFetching = false
                showMovies = true
            }
        }
        return true
    }
    
    private func calcEmotion(_ emotion: String) -> Int {
        if ["😀", "😄"].contains(emotion) {
            return 1
        } else if emotion == "😐" {
            return 0
        } else {
            return -1
        }
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
    
    private let randomGenres = [
        "Thriller", "TV Movie", "Action", "Adventure", "History", "Animation", "Mystery", "War", "Comedy",
        "Fantasy", "Horror", "Music", "Documentary", "Romance", "Family", "Crime", "Science Fiction", "Western", "Drama"
    ]
    
    private var genres: String {
        var str = ""
        if recommendManager.currentEmotion == 1 {
            for genre in selectedPositiveCategories {
                str += genre + ","
            }
        } else if recommendManager.currentEmotion == -1 {
            for genre in selectedNegativeCategories {
                str += genre + ","
            }
        } else if recommendManager.currentEmotion == 0 {
            if let genre = randomGenres.randomElement() {
                str += genre + ","
            }
        }
        str.removeLast()
        return str
    }
    
    private let emojis = ["😀", "😄", "😐", "😢", "😭", "😠", "😡"]
    
    private var emojiSlider: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .font(.system(size: 30))
                        .draggable(emoji)
                }
            }
            .padding()
        }
        .background(.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    MovieRecommender()
        .environmentObject(RecommendManager())
}
