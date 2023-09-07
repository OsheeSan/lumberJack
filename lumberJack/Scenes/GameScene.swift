//
//  GameScene.swift
//  lumberJack
//
//  Created by admin on 31.08.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var cutSoundAction: SKAction!
    private var recordSoundAction: SKAction!
    private var oughSoundAction: SKAction!
    
    var homeButton: SKSpriteNode!
    
    var leftButton: SKSpriteNode!
    var rightButton: SKSpriteNode!
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "\(score)"
            if score % 20 == 0 {
                level += 1
            }
        }
    }
    var scoreLabel: SKLabelNode!
    var level = 1 {
        didSet {
            millisecondsToAdd -= 0.02
        }
    }
    
    var timerNode: SKSpriteNode!
    var timer: Timer?
    var secondsRemaining: Double = 10 {
        didSet {
            timerNode.size = CGSize(width: size.width/2 * secondsRemaining/10, height: 20)
            if (6...10).contains(secondsRemaining) {
                timerNode.color = .green
            } else if (4..<6).contains(secondsRemaining) {
                timerNode.color = .yellow
            } else if (0..<4).contains(secondsRemaining) {
                timerNode.color = .red
            }
        }
    }
    var millisecondsToAdd: Double = 0.4
    
    var gameState: GameState = .notPlaying
    var tree: SKSpriteNode!
    var jack: SKSpriteNode!
    var jackPosition: JackPosition = .right
    var jackAction: JackAction = .none
    var jackSize: CGFloat!
    
    var branches: [SKSpriteNode] = []
    
    var isNone = true
    
    enum JackPosition: String {
        case left = "Left"
        case right = "Right"
    }
    
    enum JackAction: String {
        case action = "Action"
        case none = ""
    }
    
    enum GameState {
        case notPlaying
        case playing
        case gameOver
    }
    
    //MARK: - didMove
    override func didMove(to view: SKView) {
        setupScene()
        backgroundColor = .white
        
    }
    
    //MARK: - setupScene
    private func setupScene() {
        scene?.size = (view?.frame.size)!
        setupTree()
        setupJack()
        setupBackground()
        setupLabels()
        setupButtons()
        setUpAudio()
    }
    
    //MARK: - setupTimer
    func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        timerNode = SKSpriteNode()
        timerNode.position = CGPoint(x: size.width/2, y: size.height/6*2.1)
        timerNode.zPosition = 10
        timerNode.color = .green
        addChild(timerNode)
    }
    
    //MARK: - updateTimer
    @objc func updateTimer() {
        secondsRemaining -= 0.01
        if secondsRemaining >= 10 {
            secondsRemaining = 10
        }
        if secondsRemaining <= 0 {
            gameOver()
        }
    }
    
    //MARK: - addTime
    func addTime()  {
        secondsRemaining += millisecondsToAdd
    }
    
    //MARK: - setupTree
    private func setupTree() {
        tree = SKSpriteNode.init(color: .brown, size: CGSize(width: size.width/7, height: size.height))
        tree.position = CGPoint(x: size.width/2, y: size.height)
        addChild(tree)
    }
    
    //MARK: - setupJack
    private func setupJack() {
        jack = SKSpriteNode(imageNamed: "lumberJack\(jackPosition.rawValue)\(jackAction.rawValue)")
        jackSize = size.height/8
        jack.zPosition = 1
        jack.size = CGSize(width: jackSize, height: jackSize)
        jack.position = CGPoint(x: size.width/2 + tree.size.width/2 + jackSize/2, y: size.height/2 + jackSize/2)
        addChild(jack)
    }
    
    //MARK: - buttonLeftAnimate
    func buttonLeftAnimate() {
        let yellowColorAction = SKAction.colorize(with: .yellow, colorBlendFactor: 1.0, duration: 0.2)
        let resetColorAction = SKAction.colorize(with: .white, colorBlendFactor: 0.0, duration: 0.2)
        
        let sequence = SKAction.sequence([yellowColorAction, resetColorAction])
        let sequence2 = SKAction.sequence([SKAction.scaleX(to: 1.1, y: 1.1, duration: 0.2), SKAction.scaleX(to: 1, y: 1, duration: 0.2)])
        
        leftButton.run(SKAction.group([sequence, sequence2]))
    }
    
    //MARK: - buttonRightAnimate
    func buttonRightAnimate() {
        let yellowColorAction = SKAction.colorize(with: .yellow, colorBlendFactor: 1.0, duration: 0.2)
        let resetColorAction = SKAction.colorize(with: .white, colorBlendFactor: 0.0, duration: 0.2)
        
        let sequence = SKAction.sequence([yellowColorAction, resetColorAction])
        let sequence2 = SKAction.sequence([SKAction.scaleX(to: 1.1, y: 1.1, duration: 0.2), SKAction.scaleX(to: 1, y: 1, duration: 0.2)])
        
        rightButton.run(SKAction.group([sequence, sequence2]))
    }
    //MARK: - setupBackground
    private func setupBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        let aspectRatio = background.size.width / background.size.height
        let newWidth = size.height * aspectRatio
        background.size = CGSize(width: newWidth, height: size.height)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -3
        addChild(background)
        
        let grass = SKSpriteNode(imageNamed: "grass")
        grass.size = CGSize(width: size.width, height: size.height/30)
        grass.position = CGPoint(x: size.width/2, y: size.height/2 + grass.size.height/2)
        grass.zPosition = 4
        addChild(grass)
        
        let leaf = SKSpriteNode(imageNamed: "leaf")
        leaf.size = CGSize(width: size.width * 1.3, height: size.height/3)
        leaf.position = CGPoint(x: size.width/2, y: size.height - size.height/10)
        leaf.zPosition = 4
        addChild(leaf)
        
        
        let grassBackground = SKSpriteNode(color: .brown, size: CGSize(width: size.width, height: size.height/2))
        grassBackground.zPosition = 3
        grassBackground.position = CGPoint(x: size.width/2, y: size.height/4)
        addChild(grassBackground)
        
        let bigTable = SKSpriteNode(imageNamed: "bigTable")
        bigTable.size = CGSize(width: size.width, height: size.height/2 * 0.8)
        bigTable.position = CGPoint(x: size.width/2, y: size.height/2 - size.height/4)
        bigTable.zPosition = 4
        addChild(bigTable)
    }
    
    //MARK: - setupLabels
    private func setupLabels() {
        scoreLabel = SKLabelNode()
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height/3*2)
        scoreLabel.zPosition = 10
        scoreLabel.text = "0"
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 24
        scoreLabel.fontColor  = .yellow
        addChild(scoreLabel)
    }
    
    //MARK: - setupButtons
    private func setupButtons() {
        homeButton = SKSpriteNode(imageNamed: "homeButton")
        homeButton.size = CGSize(width: 40, height: 40)
        homeButton.position = CGPoint(x: size.width/10, y: size.height/10*9)
        homeButton.zPosition = 10
        addChild(homeButton)
        
        leftButton = SKSpriteNode(imageNamed: "leftButton")
        leftButton.position = CGPoint(x: size.width/4, y: size.height/4)
        leftButton.size = CGSize(width: size.width/4, height: size.width/4)
        leftButton.zPosition = 5
        addChild(leftButton)
        
        rightButton = SKSpriteNode(imageNamed: "rightButton")
        rightButton.position = CGPoint(x: size.width/4*3, y: size.height/4)
        rightButton.size = CGSize(width: size.width/4, height: size.width/4)
        rightButton.zPosition = 5
        addChild(rightButton)
    }
    
    //MARK: - updateJackSkin
    private func updateJackSkin() {
        jack.run(SKAction.setTexture(SKTexture(imageNamed: "lumberJack\(jackPosition.rawValue)\(jackAction.rawValue)")))
    }
    
    //MARK: - touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let touchLocation = touch?.location(in: self){
            if homeButton.contains(touchLocation) {
                let yellowColorAction = SKAction.colorize(with: .yellow, colorBlendFactor: 1.0, duration: 0.2)
                let resetColorAction = SKAction.colorize(with: .white, colorBlendFactor: 0.0, duration: 0.2)
                
                let sequence = SKAction.sequence([yellowColorAction, resetColorAction])
                let sequence2 = SKAction.sequence([SKAction.scaleX(to: 1.1, y: 1.1, duration: 0.2), SKAction.scaleX(to: 1, y: 1, duration: 0.2)])
                
                homeButton.run(SKAction.group([sequence, sequence2]))
                
                let delegate = delegate as! GameViewController
                delegate.dismiss(animated: true)
                let vc = MenuViewController()
                vc.modalPresentationStyle = .fullScreen
                delegate.present(vc, animated: true)
                
                
            }
        }
        if gameState == .notPlaying {
            setupTimer()
            gameState = .playing
        }
        if gameState == .playing {
            let touch = touches.first
            jackAction = .action
            if let touchLocation = touch?.location(in: self){
                if touchLocation.x >= size.width/2 {
                    run(cutSoundAction)
                    jackPosition = .right
                    buttonRightAnimate()
                    jack.position = CGPoint(x: size.width/2 + tree.size.width/2 + jackSize/2, y: size.height/2 + jackSize/2)
                    updateJackSkin()
                    dropBranches()
                    addBranch()
                    score += 1
                } else {
                    run(cutSoundAction)
                    jackPosition = .left
                    buttonLeftAnimate()
                    jack.position = CGPoint(x: size.width/2 - tree.size.width/2 - jackSize/2, y: size.height/2 + jackSize/2)
                    updateJackSkin()
                    dropBranches()
                    addBranch()
                    score += 1
                }
                addTime()
            }
        }
    }
    
    //MARK: - touchesEnded
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameState == .playing {
            jackAction = .none
            updateJackSkin()
        }
    }
    
    //MARK: - touchesCanceled
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameState == .playing {
            jackAction = .none
            updateJackSkin()
        }
    }
    
    //MARK: - update
    override func update(_ currentTime: TimeInterval) {
        if gameState == .playing {
            removeNodesBelowScreenMid()
            if !branches.isEmpty && branches[0].position.x == jack.position.x && branches[0].position.y -  jackSize/4 <= jack.position.y {
                gameOver()
            }
        }
    }
    
    //MARK: - removeNodesBelowScreenMid
    func removeNodesBelowScreenMid() {
        for child in branches {
            if child.name == "none" || child.name == "branch" {
                if child.position.y <= jack.position.y {
                    print("Branch : \(child.position)")
                    print("Jack : \(jack.position)")
                    branches.remove(at: 0)
                    let hideAction = SKAction.fadeOut(withDuration: 0.5)
                    let moveAction: SKAction
                    
                    if jackPosition == .left {
                        moveAction = SKAction.group([
                            SKAction.moveBy(x: 20, y: 20, duration: 0.5),
                            SKAction.rotate(byAngle: -CGFloat.pi / 2, duration: 0.5)
                        ])
                    } else {
                        moveAction = SKAction.group([
                            SKAction.moveBy(x: -20, y: 20, duration: 0.5),
                            SKAction.rotate(byAngle: CGFloat.pi / 2, duration: 0.5)
                        ])
                    }
                    
                    let removeAction = SKAction.run {
                        child.removeFromParent()
                    }
                    
                    child.run(SKAction.sequence([SKAction.group([hideAction, moveAction]), removeAction]))
                }
            }
        }
    }
    
    //MARK: - addBranch
    func addBranch() {
        if isNone {
            let none = SKSpriteNode()
            none.size = CGSize(width: jackSize/2, height: jackSize/2)
            none.name = "none"
            let randomX: CGFloat!
            switch Int.random(in: 1...2) {
            case 1:
                randomX = size.width/2 - tree.size.width/2 - jackSize/4
            default:
                randomX = size.width/2 + tree.size.width/2 + jackSize/4
            }
            none.position = CGPoint(x: randomX, y: size.height/2+jackSize*5 - jackSize/4)
            addChild(none)
            branches.append(none)
        } else {
            switch Int.random(in: 1...2) {
            case 1:
                let branch = SKSpriteNode(imageNamed: "branchLeft")
                branch.name = "branch"
                branch.size = CGSize(width: jackSize, height: jackSize/2)
                let randomX: CGFloat!
                randomX = size.width/2 - tree.size.width/2 - jackSize/2
                branch.position = CGPoint(x: randomX, y: size.height/2+jackSize*5 - jackSize/4)
                addChild(branch)
                branches.append(branch)
            default:
                let branch = SKSpriteNode(imageNamed: "branchRight")
                branch.name = "branch"
                branch.size = CGSize(width: jackSize, height: jackSize/2)
                let randomX: CGFloat!
                randomX = size.width/2 + tree.size.width/2 + jackSize/2
                branch.position = CGPoint(x: randomX, y: size.height/2+jackSize*5 - jackSize/4)
                addChild(branch)
                branches.append(branch)
            }
        }
        isNone.toggle()
    }
    
    //MARK: - dropBranches
    func dropBranches() {
        for branch in branches {
            branch.fall()
        }
    }
    
    //MARK: - gameOver
    private func gameOver() {
        run(oughSoundAction)
        gameState = .gameOver
        Vibration.error.vibrate()
        timer?.invalidate()
        switch jackPosition {
        case  .left:
            jack.run(SKAction.setTexture(SKTexture(imageNamed: "lumberJackSitLeft")))
        case .right:
            jack.run(SKAction.setTexture(SKTexture(imageNamed: "lumberJackSitRight")))
        }
        if RecordManager.shared.isNewRecord(score: score) {
            run(recordSoundAction)
            let alertController = UIAlertController(title: "New Record!", message: nil, preferredStyle: .alert)
            
            // Add a text field to the alert
            alertController.addTextField { textField in
                textField.placeholder = "Type your name to save record"
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
                let delay = SKAction.wait(forDuration: 0.5)
                let sceneChange = SKAction.run {
                    let newGameScene = GameScene()
                    newGameScene.delegate = self.delegate
                    newGameScene.scaleMode = .aspectFit
                    self.view?.presentScene(newGameScene, transition: .crossFade(withDuration: 0.5))
                }
                self.run(.sequence([delay, sceneChange]))
            })
            let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                if let textField = alertController.textFields?.first, let text = textField.text {
                    RecordManager.shared.addScoreRecord(score: self!.score, name: text)
                }
                let delay = SKAction.wait(forDuration: 0.5)
                let sceneChange = SKAction.run {
                    let newGameScene = GameScene()
                    newGameScene.delegate = self!.delegate
                    newGameScene.scaleMode = .aspectFit
                    self!.view?.presentScene(newGameScene, transition: .crossFade(withDuration: 0.5))
                }
                self!.run(.sequence([delay, sceneChange]))
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            let vc = self.delegate as! GameViewController
            vc.present(alertController, animated: true, completion: nil)
        } else {
            let delay = SKAction.wait(forDuration: 0.5)
            let sceneChange = SKAction.run {
                let newGameScene = GameScene()
                newGameScene.delegate = self.delegate
                newGameScene.scaleMode = .aspectFit
                self.view?.presentScene(newGameScene, transition: .crossFade(withDuration: 0.5))
            }
            run(.sequence([delay, sceneChange]))
        }
    }
    
    //MARK: - Audio
    
    private func setUpAudio() {
        cutSoundAction = .playSoundFileNamed(
            "cut.mp3",
            waitForCompletion: false)
        oughSoundAction = .playSoundFileNamed(
            "ough.mp3",
            waitForCompletion: false)
        recordSoundAction = .playSoundFileNamed(
            "record.mp3",
            waitForCompletion: false)
    }
}

extension SKSpriteNode {
    func fall() {
        let fallAction = SKAction.moveBy(x: 0, y: -self.size.height, duration: TimeInterval(self.size.height / 1000))
        self.run(fallAction) {
            self.position = CGPoint(x: self.position.x, y: round(self.position.y * 1000) / 1000)
        }
    }
}
