//
//  SpritePool.swift
//  MyGame
//
//  Created by Raphael Stäbler on 04.06.14.
//  Copyright (c) 2014 Raphael Stäbler. All rights reserved.
//

//import Foundation
import SpriteKit

class Sprite {
    enum Status {
        case FREE, BUSY
    }
    
    var node: SKSpriteNode
    var status: Status
    
    init(node: SKSpriteNode) {
        self.node = node
        status = .FREE
    }
}

class SpritePool {
    var poolSize: Int
    var pool: Array<Sprite>
    var currentIndex = 0
    
    init(size: Int, imageName: String, scale: CGFloat?) {
        self.poolSize = size
        self.pool     = Sprite[]()
        
        for i in 0..self.poolSize {
            let sprite = Sprite(node:SKSpriteNode(imageNamed: imageName))
            if let s = scale {
                sprite.node.xScale = s
                sprite.node.yScale = s
            }
            self.pool += sprite
        }
    }
    
    var next: Sprite? {
        for i in 0..self.poolSize {
            self.currentIndex++
            if self.currentIndex > self.poolSize - 1 {
                self.currentIndex = 0
            }
            var sprite = self.pool[self.currentIndex]
            if (sprite.status == .FREE) {
                sprite.status = .BUSY
                return sprite
            }
        }
        return nil
    }
    
    func addToScene(scene: SKScene) {
        for sprite in self.pool {
            scene.addChild(sprite.node)
        }
    }
}