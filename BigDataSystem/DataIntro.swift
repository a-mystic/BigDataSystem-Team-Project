//
//  DataIntro.swift
//  BigDataSystem
//
//  Created by a mystic on 5/13/24.
//

import SwiftUI

struct DataIntro: View {
    private let images = [
        "연도별 개봉영화수", "장르비율", "평점과 수익의 상관관계",
        "가장많이 지원하는언어상위20개", "장르별 평균평점", "영화를가장많이제작한나라상위15개",
        "200분을기준으로나눈런타임박스플롯", "영화를가장많이제작한회사상위10개", "손익분기점넘긴영화비율"
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                ForEach(images, id: \.self) { image in
                    Section(image) {
                        ZoomableImage(imageName: image)
                    }
                }
            }
            .navigationTitle("데이터셋 알아보기")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct ZoomableImage: View {
    let imageName: String
    @State private var zoomScale: CGFloat = 1.0
    @State private var previousScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var previousOffset: CGSize = .zero

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .scaleEffect(zoomScale)
            .offset(x: offset.width, y: offset.height)
            .gesture(
                SimultaneousGesture(
                    MagnificationGesture()
                        .onChanged { value in
                            let delta = value / self.previousScale
                            self.previousScale = value
                            self.zoomScale *= delta
                        }
                        .onEnded { value in
                            self.previousScale = 1.0
                        },
                    DragGesture()
                        .onChanged { value in
                            self.offset = CGSize(
                                width: self.previousOffset.width + value.translation.width,
                                height: self.previousOffset.height + value.translation.height
                            )
                        }
                        .onEnded { value in
                            self.previousOffset = self.offset
                        }
                )
            )
    }
}

#Preview {
    DataIntro()
}
