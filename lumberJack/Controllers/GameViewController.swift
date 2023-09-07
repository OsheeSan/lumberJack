//
//  GameViewController.swift
//  lumberJack
//
//  Created by admin on 31.08.2023.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, SKSceneDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let skView = self.view as! SKView
        skView.ignoresSiblingOrder = true
        var scene: SKScene!
        scene = GameScene()
        scene.scaleMode = .aspectFit
        scene.delegate = self
        scene.view?.showsFPS = true
        scene.view?.showsNodeCount = true
        skView.presentScene(scene)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
