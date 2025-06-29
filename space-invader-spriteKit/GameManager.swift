//
//  GameManager.swift
//  space-invader-spriteKit
//
//  Created by Tornike Despotashvili on 6/29/25.
//

import SpriteKit

class GameManager {
  static func loadLevel(_ number: Int) -> SKScene {
    switch number {
    case 1: return MainScene(size: UIScreen.main.bounds.size)
    case 2: return MainScene2(size: UIScreen.main.bounds.size)
    default: return MainScene(size: UIScreen.main.bounds.size)
    }
  }
}
