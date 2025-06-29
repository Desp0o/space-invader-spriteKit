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
    let scene = GameManager.loadLevel(2)
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


final class MainScene2: BaseLevelScene {
  var bossHealth = 100
  let boss = SKSpriteNode(imageNamed: "boss")
  override func didMove(to view: SKView) {
    super.didMove(to: view)
    
    setupBG(bgName: "darkPurple")
    setupBoss()
    setupSpaceShip()
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    let isBulletBoss =
    (contact.bodyA.categoryBitMask == PhysicsCategory.bullet && contact.bodyB.categoryBitMask == PhysicsCategory.boss) ||
    (contact.bodyA.categoryBitMask == PhysicsCategory.boss && contact.bodyB.categoryBitMask == PhysicsCategory.bullet)
    
    if isBulletBoss {
      bossHealth -= 5
      
      if contact.bodyA.categoryBitMask == PhysicsCategory.bullet {
        contact.bodyA.node?.removeFromParent()
      } else if contact.bodyB.categoryBitMask == PhysicsCategory.bullet {
        contact.bodyB.node?.removeFromParent()
      }
      
      let flashAction = SKAction.sequence([
        SKAction.fadeAlpha(to: 0.2, duration: 0.05),
        SKAction.fadeAlpha(to: 1.0, duration: 0.05)
      ])
      boss.run(flashAction)
      
      if bossHealth <= 0 {
        boss.removeFromParent()
      }
    }
    
    let isBossBulletCollided =
    (contact.bodyA.categoryBitMask == PhysicsCategory.bossBullet && contact.bodyB.categoryBitMask == PhysicsCategory.ship) ||
    (contact.bodyA.categoryBitMask == PhysicsCategory.ship && contact.bodyB.categoryBitMask == PhysicsCategory.bossBullet)
    
    if isBossBulletCollided {
      contact.bodyA.node?.removeFromParent()
      contact.bodyB.node?.removeFromParent()
      destroyedShip(location: spaceShip.position)
      gameOver()
      
      scene?.isPaused = true
    }
  }
  
  func setupBoss() {
    boss.position = CGPoint(x: size.width / 2, y: size.height - 120)
    boss.size = CGSize(width: 100, height: 100)
    if let texture = boss.texture {
      boss.physicsBody = SKPhysicsBody(texture: texture, size: boss.size)
    } else {
      boss.physicsBody = SKPhysicsBody(circleOfRadius: 50)
    }
    
    boss.physicsBody?.isDynamic = false
    boss.physicsBody?.affectedByGravity = false
    boss.physicsBody?.usesPreciseCollisionDetection = true
    boss.physicsBody?.categoryBitMask = PhysicsCategory.boss
    boss.physicsBody?.contactTestBitMask = PhysicsCategory.bullet
    
    bossMovement()
    startBossShooting()
    addChild(boss)
  }
  
  func bossMovement() {
    let moveRight = SKAction.move(to: CGPoint(x: size.width - 50, y: size.height - 120), duration: 2)
    
    let moveLeft = SKAction.move(to: CGPoint(x: 50, y: size.height - 120), duration: 2)
    
    let sequence = SKAction.sequence([moveRight, moveLeft])
    let repeatForever = SKAction.repeatForever(sequence)
    
    boss.run(repeatForever)
  }
  
  func bossBullets() {
    let bulletOne = SKSpriteNode(imageNamed: "bollsBullet")
    bulletOne.position = CGPoint(x: boss.position.x, y: boss.position.y - 70)
    
    if let texture = bulletOne.texture {
      bulletOne.physicsBody = SKPhysicsBody(texture: texture, size: bulletOne.frame.size)
    }
    
    bulletOne.physicsBody?.isDynamic = false
    bulletOne.physicsBody?.affectedByGravity = false
    bulletOne.physicsBody?.usesPreciseCollisionDetection = true
    bulletOne.physicsBody?.categoryBitMask = PhysicsCategory.bossBullet
    bulletOne.physicsBody?.contactTestBitMask = PhysicsCategory.ship
    
    let shoot = SKAction.move(by: CGVector(dx: 0, dy: -800), duration: 2)
    let remove = SKAction.removeFromParent()
    let sequence = SKAction.sequence([shoot, remove])
    bulletOne.run(sequence)
    
    addChild(bulletOne)
  }
  
  func startBossShooting() {
    let shoot = SKAction.run { [weak self] in
      self?.bossBullets()
    }
    let wait = SKAction.wait(forDuration: 1.5)
    let sequence = SKAction.sequence([shoot, wait])
    let repeatShoot = SKAction.repeatForever(sequence)
    
    boss.run(repeatShoot)
  }
}
