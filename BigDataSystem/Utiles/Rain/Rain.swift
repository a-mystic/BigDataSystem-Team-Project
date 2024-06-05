//
//  Rain.swift
//  CountingSheep
//
//  Created by a mystic on 2023/08/26.
//

import SwiftUI
import SpriteKit

struct Rain: View {
    var body: some View {
        GeometryReader { geometry in
            let insideWidth = geometry.size.width
            let insideHeight = geometry.size.height
            ZStack(alignment: .bottom) {
                Color.gray
                SpriteView(scene: rainfall(), options: [.allowsTransparency])
                    .padding(.horizontal)
                RoundedRectangle(cornerRadius: 14)
                    .foregroundColor(.clear)
                    .scaleEffect(0.9)
                    .frame(width: insideWidth * 0.6 , height: 544)
                    .overlay(SpriteView(scene: rainfalllanding(), options: [.allowsTransparency]))
                Rectangle()
                    .foregroundColor(.white)
                    .scaleEffect(1)
                    .frame(width: insideWidth , height: 100)
                elements(width: insideWidth, height: insideHeight)
            }
            .ignoresSafeArea(.all)
        }
    }
    
    @ViewBuilder
    func elements(width: CGFloat, height: CGFloat) -> some View {
        Text("🌪️")
            .scaleEffect(3)     // replace magic number to relative number
            .frame(width: width, height: height)
            .offset(x: -width / 3, y: height / 3)
        Text("☂️")
            .scaleEffect(3)     // replace magic number to relative number
            .frame(width: width, height: height)
            .offset(x: width / 3, y: height / 3)
        Text("🌧️")
            .scaleEffect(3)     // replace magic number to relative number
            .frame(width: width, height: height)
            .offset(x: -width / 3, y: -height / 3.5)
        Text("☁️")
            .scaleEffect(3)     // replace magic number to relative number
            .frame(width: width, height: height)
            .offset(x: -width / 6.5, y: -height / 3.5)
        Text("🌧️")
            .scaleEffect(3)     // replace magic number to relative number
            .frame(width: width, height: height)
            .offset(x: width / 6, y: -height / 3.5)
        Text("🌧️")
            .scaleEffect(3)     // replace magic number to relative number
            .frame(width: width, height: height)
            .offset(x: width / 4, y: -height / 3.5)
    }
}


class rainfall: SKScene {
    override func sceneDidLoad() {
        size = UIScreen.main.bounds.size
        scaleMode = .resizeFill
        anchorPoint = CGPoint(x: 0.5, y: 1)
        backgroundColor = .clear
        let node = SKEmitterNode(fileNamed: "rainfall.sks")!
        addChild(node)
        node.particlePositionRange.dx = UIScreen.main.bounds.width
    }
}

class rainfalllanding : SKScene {
    override func sceneDidLoad() {
        size = UIScreen.main.bounds.size
        scaleMode = .resizeFill
        anchorPoint = CGPoint(x: 0.5, y: 1)
        backgroundColor = .clear
        let node = SKEmitterNode(fileNamed: "rainfalllanding.sks")!
        addChild(node)
        node.particlePositionRange.dx = UIScreen.main.bounds.width - 30
    }
}

struct Rain_Previews: PreviewProvider {
    static var previews: some View {
        Rain()
    }
}
