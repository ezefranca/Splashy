//
//  SpriteType.swift
//  Splashy
//
//  Created by Pedro Carrasco on 23/01/18.
//  Copyright © 2018 Pedro Carrasco. All rights reserved.
//

import SpriteKit

enum SpriteType: String {
    case splashy = "character-main"
    case enemy = "character-enemy"
    case ground = "ground"
    case background = "background"
}

extension SpriteType {
    var node: SKSpriteNode {
        return SKSpriteNode(imageNamed: self.rawValue)
    }

    var zPosition: CGFloat {
        switch self {
        case .splashy:
            return 3
        case .enemy:
            return 2
        case .ground:
            return 4
        case .background:
            return 1
        }
    }

    var scale: CGFloat {
        switch self {
        case .splashy:
            return 0.4
        case .enemy:
            return 0.6
        case .ground:
            return 1.1
        case .background:
            return 1.3
        }
    }

    var physicsId: UInt32 {
        switch self {
        case .splashy:
            return 0x1 << 1
        case .enemy:
            return 0x1 << 2
        case .ground:
            return 0x1 << 3
        case .background:
            return 0x1 << 4 
        }
    }

    func position(in frame: CGRect, with sprite: SKSpriteNode) -> CGPoint {
        switch self {
        case .splashy:
            return CGPoint(x: frame.width/2 - sprite.frame.width, y: frame.height/2)
        case .enemy:
            return CGPoint(x: frame.width, y: frame.height/2)
        case .ground:
            return CGPoint(x: frame.width/2, y: 0 + sprite.frame.height/2)
        case .background:
            return CGPoint(x: frame.width/2, y: frame.height/2)
        }
    }
}