//
//  MainScene.swift
//  space-invader-spriteKit
//
//  Created by Tornike Despotashvili on 6/29/25.
//

import SpriteKit

final class MainScene: BaseLevelScene {
  
  override func didMove(to view: SKView) {
    super.didMove(to: view)
    
    setupBG(bgName: "mainBackground")
    setupHUD()
    setupSpaceShip()
    spawnMeteors()
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    let bodyA = contact.bodyA
    let bodyB = contact.bodyB
    
    let isBulletMeteor =
    (bodyA.categoryBitMask == PhysicsCategory.bullet && bodyB.categoryBitMask == PhysicsCategory.meteor) ||
    (bodyA.categoryBitMask == PhysicsCategory.meteor && bodyB.categoryBitMask == PhysicsCategory.bullet)
    
    if isBulletMeteor {
      score += 1
      scoreLabel.text = "Score: \(score)"
      bodyA.node?.removeFromParent()
      bodyB.node?.removeFromParent()
      
      if score == 10 {
        let nextLevel = GameManager.loadLevel(2)
        view?.presentScene(nextLevel, transition: .crossFade(withDuration: 1))
      }
      
      return
    }
    
    let isShipMeteor =
    (bodyA.categoryBitMask == PhysicsCategory.ship && bodyB.categoryBitMask == PhysicsCategory.meteor) ||
    (bodyA.categoryBitMask == PhysicsCategory.meteor && bodyB.categoryBitMask == PhysicsCategory.ship)
    
    if isShipMeteor {
      let location = bodyA.categoryBitMask == PhysicsCategory.ship ? bodyA.node?.position : bodyB.node?.position
      bodyA.node?.removeFromParent()
      bodyB.node?.removeFromParent()
      guard let location else { return }
      destroyedShip(location: location)
      gameOver()
      return
    }
  }
}
