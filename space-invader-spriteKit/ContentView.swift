//
//  ContentView.swift
//  space-invader-spriteKit
//
//  Created by Despo on 28.06.25.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
  let scene: SKScene = MainScene()
  
  var body: some View {
    SpriteView(scene: scene)
      .ignoresSafeArea()
  }
}

#Preview {
  ContentView()
}


final class MainScene: SKScene {
  override func didMove(to view: SKView) {
    self.scaleMode = .fill
    setupBG()
  }
  
  func setupBG() {
    let background = SKSpriteNode(imageNamed: "mainBackground")
    background.size = CGSize(width: size.width, height: size.height)
    background.position = CGPoint(x: size.width / 2, y: size.height / 2)
    background.zPosition = -1
    
    addChild(background)
  }
}
