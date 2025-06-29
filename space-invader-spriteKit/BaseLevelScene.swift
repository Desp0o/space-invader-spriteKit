//
//  BaseLevelScene.swift
//  space-invader-spriteKit
//
//  Created by Tornike Despotashvili on 6/29/25.
//

import SpriteKit

struct PhysicsCategory {
  static let meteor: UInt32 = 1
  static let enemy: UInt32 = 2
  static let bullet: UInt32 = 4
  static let ship: UInt32 = 8
  static let boss : UInt32 = 16
  static let bossBullet: UInt32 = 32
}

class BaseLevelScene: SKScene, SKPhysicsContactDelegate {
  let spaceShip = SKSpriteNode(imageNamed: "spaceShip")
  
  let scoreLabel = SKLabelNode()
  var score = 0
  
  override func didMove(to view: SKView) {
    self.physicsWorld.contactDelegate = self
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    
    updateShipPosition(location: location)
    
    setupRedBullet()
  }
  
  func setupHUD() {
    scoreLabel.text = "Score: \(score)"
    scoreLabel.fontColor = .yellow
    scoreLabel.fontSize = 16
    scoreLabel.fontName = "Helvetica-bold"
    scoreLabel.position = CGPoint(x: size.width - 50, y: size.height - 60)
    
    addChild(scoreLabel)
  }
  
  func setupBG(bgName: String) {
    let background = SKSpriteNode(imageNamed: bgName)
    background.size = CGSize(width: size.width, height: size.height)
    background.position = CGPoint(x: size.width / 2, y: size.height / 2)
    background.zPosition = -1
    
    addChild(background)
  }
  
  func setupSpaceShip() {
    spaceShip.name = "spaceShip"
    spaceShip.position = CGPoint(x: size.width / 2, y: 60)
    spaceShip.size = CGSize(width: 60, height: 60)
    if let texture = spaceShip.texture {
      spaceShip.physicsBody = SKPhysicsBody(texture: texture, size: spaceShip.frame.size)
    } else {
      spaceShip.physicsBody = SKPhysicsBody(rectangleOf: spaceShip.frame.size)
    }
    spaceShip.physicsBody?.isDynamic = true
    spaceShip.physicsBody?.affectedByGravity = false
    spaceShip.physicsBody?.usesPreciseCollisionDetection = true
    spaceShip.physicsBody?.categoryBitMask = PhysicsCategory.ship
    spaceShip.physicsBody?.contactTestBitMask = PhysicsCategory.meteor
    
    addChild(spaceShip)
  }
  
  func updateShipPosition(location: CGPoint) {
    let halfWidth = spaceShip.size.width / 2
    let minX = halfWidth + 10
    let maxX = size.width - halfWidth - 10
    let clampedX = min(max(location.x, minX), maxX)
    
    let move = SKAction.move(to: CGPoint(x: clampedX, y: spaceShip.position.y), duration: 0.3)
    
    spaceShip.run(move)
  }
  
  func destroyedShip(location: CGPoint) {
    let destroyedShip = SKSpriteNode(imageNamed: "damagedShip")
    destroyedShip.position = location
    
    let move = SKAction.move(by: CGVector(dx: 0, dy: -200), duration: 2)
    destroyedShip.run(move)
    
    addChild(destroyedShip)
  }
  
  func setupRedBullet() {
    let redBullet = SKSpriteNode(imageNamed: "laserRed01")
    redBullet.position = CGPoint(x: spaceShip.position.x, y: spaceShip.position.y + 60)
    redBullet.physicsBody = SKPhysicsBody(rectangleOf: redBullet.frame.size)
    redBullet.physicsBody?.isDynamic = true
    redBullet.physicsBody?.affectedByGravity = false
    
    redBullet.physicsBody?.usesPreciseCollisionDetection = true
    redBullet.physicsBody?.categoryBitMask = PhysicsCategory.bullet
    redBullet.physicsBody?.contactTestBitMask = PhysicsCategory.enemy | PhysicsCategory.meteor
    
    let move = SKAction.move(by: CGVector(dx: 0, dy: 800), duration: 1)
    let remove = SKAction.removeFromParent()
    
    let sequence = SKAction.sequence([move, remove])
    
    redBullet.run(sequence)
    
    addChild(redBullet)
  }
  
  func generateMeteors() {
    let meteorsArray: [String] = [
      "meteorBrown_big1",
      "meteorBrown_big2",
      "meteorBrown_small1",
      "meteorBrown_small2",
      "meteorBrown_tiny1",
      "meteorGrey_big1",
      "meteorGrey_big2",
      "meteorGrey_med2",
      "meteorGrey_tiny1",
      "meteorGrey_small1"
    ]
    
    guard let randomMeteor = meteorsArray.randomElement() else { return }
    
    let meteor = SKSpriteNode(imageNamed: randomMeteor)
    
    let halfWidth = meteor.size.width / 2
    let minX = halfWidth + 10
    let maxX = size.width - halfWidth - 10
    let randomX = CGFloat.random(in: minX...maxX)
    
    meteor.position = CGPoint(x: randomX, y: size.height)
    meteor.physicsBody = SKPhysicsBody(rectangleOf: meteor.frame.size)
    meteor.physicsBody?.isDynamic = true
    meteor.physicsBody?.affectedByGravity = false
    
    meteor.physicsBody?.usesPreciseCollisionDetection = true
    meteor.physicsBody?.categoryBitMask = PhysicsCategory.meteor
    meteor.physicsBody?.contactTestBitMask = PhysicsCategory.bullet | PhysicsCategory.ship
    
    let move = SKAction.move(by: CGVector(dx: 0, dy: -800), duration: 3)
    let remove = SKAction.removeFromParent()
    let sequence = SKAction.sequence([move, remove])
    
    meteor.run(sequence)
    addChild(meteor)
  }
  
  func spawnMeteors() {
    let spawn = SKAction.run { [weak self] in
      self?.generateMeteors()
    }
    
    let wait = SKAction.wait(forDuration: 3)
    let sequence = SKAction.sequence([spawn, wait])
    let repeatForever = SKAction.repeatForever(sequence)
    
    run(repeatForever, withKey: "meteorSpawn")
  }
  
  func gameOver() {
    removeAllActions()
    view?.isPaused = true
    
    let gameOverLabel = SKLabelNode()
    gameOverLabel.text = "Game Over"
    gameOverLabel.fontColor = .red
    gameOverLabel.fontName = "Helvetica-bold"
    gameOverLabel.fontSize = 40
    
    gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
    
    addChild(gameOverLabel)
  }
}
