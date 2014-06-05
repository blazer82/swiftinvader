//
//  GameScene.swift
//  MyGame
//
//  Created by Raphael Stäbler on 03.06.14.
//  Copyright (c) 2014 Raphael Stäbler. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let ship = SKSpriteNode(imageNamed:"Spaceship")
    let rocketPool: SpritePool
    let alienPool: SpritePool
    
    var rocketAction: SKAction?
    var alienAction: SKAction?
    
    var lastRocketTime: CDouble = 0.0
    var lastAlienTime: CDouble = 0.0
    
    init(coder: NSCoder) {
        self.rocketPool = SpritePool(size:20, imageName:"rocket", scale:0.2)
        self.alienPool  = SpritePool(size:20, imageName:"alienship", scale:0.5)
        
        super.init(coder: coder)
        
        self.rocketPool.each { sprite in
            self.addChild(sprite.node)
        }
        
        self.alienPool.each { sprite in
            self.addChild(sprite.node)
        }
        
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.ship.xScale = 0.5
        self.ship.yScale = 0.5
        self.ship.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMinY(self.frame) + self.ship.size.height);
        self.addChild(self.ship)
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            self.ship.position.x = location.x;
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            self.ship.position.x = location.x;
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        // shoot rockets
        if self.lastRocketTime < currentTime - 0.1 {
            if var rocket = self.rocketPool.next {
                var x = self.ship.position.x
            
                if self.rocketPool.currentIndex % 2 == 0 {
                    x -= 50
                }
                else {
                    x += 50
                }
            
                rocket.node.position = CGPoint(x:x, y:self.ship.position.y)
                
                if !self.rocketAction {
                    self.rocketAction = SKAction.moveToY(CGRectGetMaxY(self.frame) + rocket.node.size.height, duration: 0.8)
                }
            
                rocket.node.runAction(self.rocketAction!, completion:{rocket.status = .FREE})
            
                self.lastRocketTime = currentTime
            }
        }
        
        // spawn aliens
        if self.lastAlienTime < currentTime - 1 {
            if var alien = self.alienPool.next {
                let x: CGFloat = Float(arc4random()) % CGRectGetMaxX(self.frame)
                
                alien.node.position = CGPoint(x:x, y:CGRectGetMaxY(self.frame) - alien.node.size.height)
                
                if !self.alienAction {
                    self.alienAction = SKAction.moveToY(CGRectGetMinY(self.frame), duration: 4.0)
                }
                
                alien.node.runAction(self.alienAction!, completion:{alien.status = .FREE})
                
                self.lastAlienTime = currentTime
            }
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact!) {
        
    }
}
