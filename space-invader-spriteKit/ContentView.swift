//
//  ContentView.swift
//  space-invader-spriteKit
//
//  Created by Despo on 28.06.25.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
  let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var scene: SKScene {
      let scene = MainScene()
      scene.size.width = width
      scene.size.height = height
      scene.scaleMode = .fill
      
      return scene
    }
  
  var body: some View {
    SpriteView(scene: scene)
      .ignoresSafeArea()
  }
}

#Preview {
  ContentView()
}


final class MainScene: SKScene {
  let spaceShip = SKSpriteNode(imageNamed: "spaceShip")
  
  override func didMove(to view: SKView) {
    self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    
    setupBG()
    setupSpaceShip()
  }
  
  func setupBG() {
    let background = SKSpriteNode(imageNamed: "mainBackground")
    background.size = CGSize(width: size.width, height: size.height)
    background.position = CGPoint(x: size.width / 2, y: size.height / 2)
    background.zPosition = -1
    
    addChild(background)
  }
  
  func setupSpaceShip() {
    spaceShip.name = "spaceShip"
    spaceShip.position = CGPoint(x: size.width / 2, y: 50)
    spaceShip.size = CGSize(width: 70, height: 70)
    spaceShip.physicsBody = SKPhysicsBody(rectangleOf: spaceShip.frame.size)
    spaceShip.physicsBody?.isDynamic = true
    spaceShip.physicsBody?.affectedByGravity = false
    
    addChild(spaceShip)
  }
}
