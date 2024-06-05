//
//  EnterPreference.swift
//  BigDataSystem
//
//  Created by a mystic on 4/30/24.
//

import SwiftUI

struct EnterPreference: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var isShow: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                Section("기분이 좋을때 주로 시청하는 영화 장르들을 선택해주세요") {
                    positiveInput
                }
                Section("기분이 안좋을때 주로 시청하는 영화 장르들을 선택해주세요") {
                    negativeInput
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    save
                }
            }
        }
    }
    
    private let positiveCategories = [
        "Thriller", "TV Movie", "Action", "Adventure", "History", "Animation", "Mystery", "War", "Comedy",
        "Fantasy", "Horror", "Music", "Documentary", "Romance", "Family", "Crime", "Science Fiction", "Western", "Drama"
    ]
    @State private var selectedPositiveCategories: [String] = []
    @AppStorage("selectedPositiveCategoriesAppStorage") var selectedPositiveCategoriesAppStorage = Data()
    
    private let gridItemColumns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    private var positiveInput: some View {
        LazyVGrid(columns: gridItemColumns) {
            ForEach(positiveCategories, id: \.self) { item in
                RoundedRectangle(cornerRadius: 14)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(selectedPositiveCategories.contains(item) ? .black : .gray)
                    .frame(width: 100, height: 50)
                    .overlay {
                        Text(item)
                            .foregroundStyle(selectedPositiveCategories.contains(item) ? .black : .gray)
                            .font(.body)
                    }
                    .onTapGesture {
                        if selectedPositiveCategories.contains(item) {
                            if let index = selectedPositiveCategories.firstIndex(of: item) {
                                selectedPositiveCategories.remove(at: index)
                            }
                        } else {
                            selectedPositiveCategories.append(item)
                        }
                    }
            }
        }
    }
    
    private let negativeCategories = [
        "Thriller", "TV Movie", "Action", "Adventure", "History", "Animation", "Mystery", "War", "Comedy",
        "Fantasy", "Horror", "Music", "Documentary", "Romance", "Family", "Crime", "Science Fiction", "Western", "Drama"
    ]
    @State private var selectedNegativeCategories: [String] = []
    @AppStorage("selectedNegativeCategoriesAppStorage") var selectedNegativeCategoriesAppStorage = Data()
    
    private var negativeInput: some View {
        LazyVGrid(columns: gridItemColumns) {
            ForEach(negativeCategories, id: \.self) { item in
                RoundedRectangle(cornerRadius: 14)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(selectedNegativeCategories.contains(item) ? .black : .gray)
                    .frame(width: 100, height: 50)
                    .overlay {
                        Text(item)
                            .foregroundStyle(selectedNegativeCategories.contains(item) ? .black : .gray)
                            .font(.body)
                    }
                    .onTapGesture {
                        if selectedNegativeCategories.contains(item) {
                            if let index = selectedNegativeCategories.firstIndex(of: item) {
                                selectedNegativeCategories.remove(at: index)
                            }
                        } else {
                            selectedNegativeCategories.append(item)
                        }
                    }
            }
        }
    }
    
    @EnvironmentObject var recommendManager: RecommendManager
    
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
    
    private var save: some View {
        Button("Save") {
            if let positiveData = try? JSONEncoder().encode(selectedPositiveCategories),
               let negativeData = try? JSONEncoder().encode(selectedNegativeCategories) {
                selectedPositiveCategoriesAppStorage = positiveData
                selectedNegativeCategoriesAppStorage = negativeData
            }
            isShow = false
            Task {
                await recommendManager.getMovies(genres: genres)
            }
            dismiss()
        }
    }
}

#Preview {
    EnterPreference(isShow: .constant(true))
}

