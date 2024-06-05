//
//  BigDataSystemApp.swift
//  BigDataSystem
//
//  Created by a mystic on 4/30/24.
//

import SwiftUI

@main
struct BigDataSystemApp: App {
    @StateObject private var manager = RecommendManager()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                MovieRecommender()
                    .tabItem {
                        Label("영화추천", systemImage: "popcorn.fill")
                    }
                DataIntro()
                    .tabItem {
                        Label("영화데이터 소개", systemImage: "doc.fill")
                    }
            }
            .environmentObject(manager)
        }
    }
}
