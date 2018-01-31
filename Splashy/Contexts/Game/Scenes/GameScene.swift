//
//  GameScene.swift
//  Splashy
//
//  Created by Pedro Carrasco on 23/01/18.
//  Copyright © 2018 Pedro Carrasco. All rights reserved.
//

import SpriteKit

protocol GameSceneDelegate: class {
	func gameSceneDidEnd(_ gameScene: GameScene)
}

class GameScene: SKScene {

	// MARK: - SPRITES
	var ground = SKSpriteNode()
	var splashy: Splashy!
	var enemiesNodes = SKNode()
	var background = SKSpriteNode()

	// MARK: - PROPERTIES
	var moveRemoveAction = SKAction()
	var viewModel: GameViewModel!

	weak var sceneDelegate: GameSceneDelegate?

	// MARK: - LIFECYCLE
	override func didMove(to view: SKView) {
		setup()
	}

	override func update(_ currentTime: TimeInterval) {
		animateBackground()
	}

	// MARK: - SETUP
	func restart() {
		removeAllChildren()
		removeAllActions()
		scene?.speed = 1
		viewModel.restart()

		setup()
	}

	private func setup() {
		physicsWorld.contactDelegate = self
		setupBackground()
		setupGround()
		setupSplashy()
	}

	private func setupSplashy() {
		splashy = Splashy(in: frame)
		addChild(splashy.node)
	}

	private func setupEnemies() {
		enemiesNodes = SKNode()

		enemiesNodes.addChild(SpriteFactory.sprite(of: .ruby, in: frame))
		enemiesNodes.addChild(setupEnemy(with: EnemyConstants.lowerY))
		enemiesNodes.addChild(setupEnemy(with: EnemyConstants.upperY))
		
		enemiesNodes.zPosition = SpriteType.enemy.zPosition

		let randomVariation = CGFloat.randomBetween(
			min: EnemyConstants.bottomVariation,
			and: EnemyConstants.topVariation
		)
		enemiesNodes.position.y = enemiesNodes.position.y + randomVariation

		enemiesNodes.run(moveRemoveAction)
		addChild(enemiesNodes)
	}

	private func setupEnemy(with variation: CGFloat) -> SKSpriteNode {
		let enemy = SpriteFactory.sprite(of: .enemy, in: frame)
		enemy.position.y = enemy.position.y + variation

		return enemy
	}

	private func setupBackground() {
		for i in 0...1 {
			let background = SpriteFactory.sprite(of: .background, in: frame)
			background.position = CGPoint(x: CGFloat(i) *  background.size.width, y: 0)
			addChild(background)
		}
	}

	private func setupGround() {
		ground = SpriteFactory.sprite(of: .ground, in: frame)
		addChild(ground)
	}

	// MARK: - FUNCTIONS
	private func createEnemies() {
		let spawnAction = SKAction.run { [weak self] in
			self?.setupEnemies()
		}

		let spawnRateAction = SKAction.wait(forDuration: EnemyConstants.spawnRate)
		let spawnWithRateAction = SKAction.sequence([spawnAction, spawnRateAction])
		run(SKAction.repeatForever(spawnWithRateAction))

		let distance = CGFloat(frame.width + enemiesNodes.frame.width + EnemyConstants.widthExtra)
		let moveEnemies = SKAction.moveBy(
			x: -distance,
			y: 0,
			duration: TimeInterval(EnemyConstants.movementRate * distance)
		)
		let removeEnemies = SKAction.removeFromParent()

		moveRemoveAction = SKAction.sequence([moveEnemies, removeEnemies])
	}

	private func animateBackground() {
		if viewModel.shouldAnimate() {
			enumerateChildNodes(
				withName: SpriteType.background.rawValue,
				using: { [weak self ] node, _ in
					guard let background = node as? SKSpriteNode else { return }
					background.position = CGPoint(
						x: background.position.x - BackgroundConstants.velocity,
						y: background.position.y
					)

					self?.attemptToReset(background)
				}
			)
		}
	}

	private func attemptToReset(_ background: SKSpriteNode) {
		if background.position.x <= -background.size.width {
			background.position = CGPoint(
				x: background.position.x + (background.size.width * 2),
				y: background.position.y
			)
		}
	}

	// MARK: - INTERACTION
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if !viewModel.hasStarted {
			splashy.node.physicsBody?.affectedByGravity = true
			viewModel.hasStarted = true
			createEnemies()
			splashy.jumpAction()
		} else if !viewModel.isDead {
			splashy.jumpAction()
		}
	}
}

extension GameScene: SKPhysicsContactDelegate {
	func didBegin(_ contact: SKPhysicsContact) {
		body(contact.bodyA, didCollideWith: contact.bodyB)
	}

	private func body(_ a: SKPhysicsBody, didCollideWith b : SKPhysicsBody) {
		if CollisionHelper.collisionOf(a, and: b, isBetween: .splashy, and: .ruby) {
			viewModel.didPickRuby()

			if a.isKind(of: .ruby) {
				a.node?.removeFromParent()
			} else {
				b.node?.removeFromParent()
			}
		}

		if CollisionHelper.collisionOf(a, and: b, isBetween: .splashy, and: .enemy) ||
			CollisionHelper.collisionOf(a, and: b, isBetween: .splashy, and: .ground) {
			viewModel.splashyCollided()
			scene?.speed = 0
			removeAllActions()
			sceneDelegate?.gameSceneDidEnd(self)
		}
	}
}
