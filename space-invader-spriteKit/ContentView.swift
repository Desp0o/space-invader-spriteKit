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
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    
    updateShipPosition(location: location)
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
    spaceShip.position = CGPoint(x: size.width / 2, y: 60)
    spaceShip.size = CGSize(width: 70, height: 70)
    spaceShip.physicsBody = SKPhysicsBody(rectangleOf: spaceShip.frame.size)
    spaceShip.physicsBody?.isDynamic = true
    spaceShip.physicsBody?.affectedByGravity = false
    
    addChild(spaceShip)
  }
  
  func updateShipPosition(location: CGPoint) {
    let halfWidth = spaceShip.size.width / 2
    let minX = halfWidth + 10
    let maxX = size.width - halfWidth - 10
    let clampedX = min(max(location.x, minX), maxX)
    
    spaceShip.position = CGPoint(x: clampedX, y: spaceShip.position.y)
  }
}
