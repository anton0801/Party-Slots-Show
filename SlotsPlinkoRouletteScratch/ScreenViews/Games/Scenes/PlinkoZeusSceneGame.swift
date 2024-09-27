import SwiftUI
import SpriteKit

class PlinkoZeusSceneGame: SKScene, SKPhysicsContactDelegate {
    
    private var plinkoBackground: SKSpriteNode {
        get {
            let node = SKSpriteNode(imageNamed: "plinko_background_image")
            node.size = size
            node.position = CGPoint(x: size.width / 2, y: size.height / 2)
            node.zPosition = -1
            return node
        }
    }
    
    private var homeButton: SKSpriteNode {
        get {
            let homeNode = SKSpriteNode(imageNamed: "home_btn")
            homeNode.position = CGPoint(x: 400, y: 200)
            homeNode.name = "home_button"
            homeNode.size = CGSize(width: 280, height: 180)
            return homeNode
        }
    }
    
    private var selectedStairsOfGame = 9
    
    private var balance: Int = UserDefaults.standard.integer(forKey: "credits") {
        didSet {
            saveBalanceAndShow()
        }
    }
    private var balanceLabel: SKLabelNode!
    
    let plinkoInfoGame = PlinkoInfoGame()
    
    private var currentBet = 100 {
        didSet {
            currentBetLabel.text = "\(currentBet)"
        }
    }
    private var currentBetLabel: SKLabelNode!
    
    private var win: Int = 0 {
        didSet {
            balance += win
            winLabel.text = "\(win)"
        }
    }
    
    private var winLabel: SKLabelNode!
    
    private func saveBalanceAndShow() {
        balanceLabel.text = "\(balance)"
        UserDefaults.standard.set(balance, forKey: "credits")
    }
    
    override func didMove(to view: SKView) {
        size = CGSize(width: 2048, height: 2732)
        physicsWorld.contactDelegate = self
        
        addChild(plinkoBackground)
        addChild(homeButton)
        
        createUserProfileItems()
        // createStairButtons()
        createPlinkoGameFieldAll()
        
        let winBackground = SKSpriteNode(imageNamed: "blue_back")
        winBackground.position = CGPoint(x: 950, y: 200)
        winBackground.size = CGSize(width: 700, height: 150)
        addChild(winBackground)
        
        winLabel = SKLabelNode(text: "0")
        winLabel.position = CGPoint(x: 950, y: 170)
        winLabel.fontName = "PoetsenOne-Regular"
        winLabel.fontColor = .white
        winLabel.fontSize = 82
        addChild(winLabel)
        
        let dropBallBtn = SKSpriteNode(imageNamed: "plinko_play")
        dropBallBtn.position = CGPoint(x: size.width / 2 + 450, y: 420)
        dropBallBtn.size = CGSize(width: 800, height: 190)
        dropBallBtn.name = "drop_ball"
        addChild(dropBallBtn)
        
        let currentBetLabelBackground = SKSpriteNode(imageNamed: "blue_back")
        currentBetLabelBackground.position = CGPoint(x: size.width / 2 - 450, y: 420)
        currentBetLabelBackground.size = CGSize(width: 800, height: 190)
        addChild(currentBetLabelBackground)
        
        let plusBetBtn = SKLabelNode(text: "+")
        plusBetBtn.fontName = "PoetsenOne-Regular"
        plusBetBtn.fontColor = .white
        plusBetBtn.fontSize = 82
        plusBetBtn.position = CGPoint(x: size.width / 2 - 180, y: 390)
        plusBetBtn.name = "plus_bet"
        addChild(plusBetBtn)
        
        let minusBetBtn = SKLabelNode(text: "-")
        minusBetBtn.fontName = "PoetsenOne-Regular"
        minusBetBtn.fontColor = .white
        minusBetBtn.fontSize = 82
        minusBetBtn.position = CGPoint(x: 280, y: 390)
        minusBetBtn.name = "minus_bet"
        addChild(minusBetBtn)
        
        let coinImage = SKSpriteNode(imageNamed: "coin")
        coinImage.position = CGPoint(x: size.width / 2 - 320, y: 420)
        coinImage.size = CGSize(width: 120, height: 90)
        addChild(coinImage)
        
        currentBetLabel = SKLabelNode(text: "\(currentBet)")
        currentBetLabel.position = CGPoint(x: size.width / 2 - 550, y: 390)
        currentBetLabel.fontName = "PoetsenOne-Regular"
        currentBetLabel.fontColor = .white
        currentBetLabel.fontSize = 82
        addChild(currentBetLabel)
    }
    
    private func createUserProfileItems() {
        let userDataBackground = SKSpriteNode(imageNamed: "value_back")
        userDataBackground.position = CGPoint(x: 500, y: size.height - 200)
        userDataBackground.size = CGSize(width: 700, height: 120)
        addChild(userDataBackground)
        
        let userAvatar = SKSpriteNode(imageNamed: UserDefaults.standard.string(forKey: "user_avatar") ?? "avatar_1")
        userAvatar.position = CGPoint(x: 170, y: size.height - 200)
        userAvatar.size = CGSize(width: 220, height: 150)
        addChild(userAvatar)
        
        let userName = SKLabelNode(text: UserDefaults.standard.string(forKey: "user_name") ?? "")
        userName.fontName = "PoetsenOne-Regular"
        userName.fontColor = .white
        userName.fontSize = 62
        userName.position = CGPoint(x: 500, y: size.height - 220)
        addChild(userName)
        
        let userCreditsBackground = SKSpriteNode(imageNamed: "value_back")
        userCreditsBackground.position = CGPoint(x: size.width - 500, y: size.height - 200)
        userCreditsBackground.size = CGSize(width: 700, height: 120)
        addChild(userCreditsBackground)
        
        let coinImage = SKSpriteNode(imageNamed: "coin")
        coinImage.position = CGPoint(x: size.width - 170, y: size.height - 200)
        coinImage.size = CGSize(width: 220, height: 150)
        addChild(coinImage)
        
        balanceLabel = SKLabelNode(text: "\(formatNumber(balance))")
        balanceLabel.fontName = "PoetsenOne-Regular"
        balanceLabel.fontColor = .white
        balanceLabel.fontSize = 62
        balanceLabel.position = CGPoint(x: size.width - 500, y: size.height - 220)
        addChild(balanceLabel)
    }
    
    private func createStairButtons() {
        for i in 0...3 {
            let buttonNode = ButtonNode(number: 9 + i, size: CGSize(width: 400, height: 120))
            buttonNode.name = "stairs_\(9 + i)"
            buttonNode.position = CGPoint(x: 400 + CGFloat(400 * i), y: size.height - 450)
            addChild(buttonNode)
        }
    }
    
    private func createPlinkoGameFieldAll() {
        let ballPase = SKSpriteNode(imageNamed: "plinko_ball_pase")
        ballPase.position = CGPoint(x: size.width / 2 - 70, y: size.height - 750)
        ballPase.size = CGSize(width: 130, height: 80)
        addChild(ballPase)
        
        resetBall()
        
        createPlinkoField()
        createOds()
    }
    
    private func createPlinkoField() {
        for i in 1...selectedStairsOfGame {
            let centerPoint = CGPoint(x: size.width / 2, y: size.height / 2)
            let numRows = i + 2
            let pegSize = CGSize(width: 52, height: 32)
            let totalWidth = CGFloat(numRows) * (pegSize.width + 30)
            let startPointX = centerPoint.x - totalWidth
            let startPointY = size.height - 800 - CGFloat(pegSize.height * 4) * CGFloat(i)
            
            for peg in 0..<numRows {
                let pegNode = SKSpriteNode(imageNamed: "plinko_peg")
                pegNode.size = pegSize
                pegNode.position = CGPoint(x: startPointX + (CGFloat(peg) * 190), y: startPointY)
                pegNode.physicsBody = SKPhysicsBody(circleOfRadius: pegNode.size.width / 2)
                pegNode.physicsBody?.isDynamic = false
                pegNode.physicsBody?.affectedByGravity = false
                pegNode.physicsBody?.categoryBitMask = 2
                pegNode.physicsBody?.collisionBitMask = 1
                pegNode.physicsBody?.contactTestBitMask = 1
                pegNode.name = "pegNode"
                addChild(pegNode)
            }
        }
    }
    
    private func createOds() {
        let endPlinkoY = size.height - 800 - CGFloat(32 * 4) * CGFloat(selectedStairsOfGame)
        
        for (index, odItem) in plinkoInfoGame.ods[selectedStairsOfGame]!.enumerated() {
            let color = plinkoInfoGame.colorOds[index]
            let odNode = SKSpriteNode(color: .clear, size: CGSize(width: 190, height: 70))
            odNode.position = CGPoint(x: 20 + CGFloat(index * 200), y: endPlinkoY - 150)
            odNode.anchorPoint = CGPoint(x: 0, y: 0.5)
            odNode.name = "\(odItem)"
            
            let odItemSeparator = SKSpriteNode(imageNamed: "plinko_od_separator")
            odItemSeparator.position = CGPoint(x: 0, y: 0)
            odItemSeparator.size = CGSize(width: 15, height: 80)
            odNode.addChild(odItemSeparator)
            
            let text = SKLabelNode(text: "x\(odItem)")
            text.fontName = "PoetsenOne-Regular"
            text.fontSize = 52
            text.fontColor = color
            text.position = CGPoint(x: 90, y: -20)
            odNode.addChild(text)
            
            odNode.physicsBody = SKPhysicsBody(rectangleOf: odNode.size)
            odNode.physicsBody?.isDynamic = false
            odNode.physicsBody?.affectedByGravity = false
            odNode.physicsBody?.categoryBitMask = 3
            odNode.physicsBody?.collisionBitMask = 1
            odNode.physicsBody?.contactTestBitMask = 1
            
            addChild(odNode)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touched = touches.first {
            let locationTouch = touched.location(in: self)
            let touchedObject = atPoint(locationTouch)
            
            switch (touchedObject.name) {
            case "plus_bet":
                if ball.physicsBody?.affectedByGravity == false {
                    if currentBet < 1000 {
                        currentBet += 100
                    }
                }
            case "minus_bet":
                if ball.physicsBody?.affectedByGravity == false {
                    if currentBet > 100 {
                        currentBet -= 100
                    }
                }
            case "drop_ball":
                self.win = 0
                dropBall()
            case "home_button":
                NotificationCenter.default.post(name: .homeAction, object: nil)
            default:
                let a = 0
            }
        }
    }
    
    
    
    private func dropBall() {
        if balance >= currentBet {
            balance -= currentBet
            ball.physicsBody?.affectedByGravity = true
        }
    }
    
    private var ball: SKSpriteNode!
    
    private func resetBall() {
        ball = SKSpriteNode(imageNamed: "plinko_ball")
        ball.position = CGPoint(x: size.width / 2 - 60, y: size.height - 750)
        ball.size = CGSize(width: 80, height: 80)
        ball.xScale = 1.0
        ball.yScale = 1.0
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.allowsRotation = true
        ball.physicsBody?.friction = 0.4 // Сопротивление трению
        ball.physicsBody?.linearDamping = 0.5 // Уменьшает линейное движение со временем
        ball.physicsBody?.angularDamping = 0.5
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.restitution = Double.random(in: 0.1...0.7)
        ball.physicsBody?.categoryBitMask = 1
        ball.physicsBody?.collisionBitMask = 2 | 3
        ball.physicsBody?.contactTestBitMask = 2 | 3
        ball.name = "ball"
        addChild(ball)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactBodyA = contact.bodyA
        let contactBodyB = contact.bodyB
        
        if (contactBodyA.categoryBitMask == 1 && contactBodyB.categoryBitMask == 2) ||
            (contactBodyA.categoryBitMask == 2 && contactBodyB.categoryBitMask == 1) {
            var ballBody: SKPhysicsBody
            var pegBody: SKPhysicsBody
            
            if contactBodyA.categoryBitMask == 1 {
                ballBody = contactBodyA
                pegBody = contactBodyB
            } else {
                ballBody = contactBodyB
                pegBody = contactBodyA
            }
            
            if let pegNode = pegBody.node {
                let pulsePegNode = SKSpriteNode(imageNamed: "pulse_peg")
                pulsePegNode.position = pegNode.position
                pulsePegNode.size = CGSize(width: 52, height: 32)
                addChild(pulsePegNode)
                
                let actionSeq = SKAction.sequence([
                    SKAction.scale(to: 3, duration: 0.5),
                    SKAction.fadeOut(withDuration: 0.2),
                    SKAction.removeFromParent()
                ])
                pulsePegNode.run(actionSeq)
            }
        }
        
        if (contactBodyA.categoryBitMask == 1 && contactBodyB.categoryBitMask == 3) ||
            (contactBodyA.categoryBitMask == 3 && contactBodyB.categoryBitMask == 1) {
            var ballBody: SKPhysicsBody
            var odBody: SKPhysicsBody
            
            if contactBodyA.categoryBitMask == 1 {
                ballBody = contactBodyA
                odBody = contactBodyB
            } else {
                ballBody = contactBodyB
                odBody = contactBodyA
            }
            
            if let odNode = odBody.node,
               let odName = odNode.name {
                let xMultiply = Double(odName) ?? 0.0
                win = Int(Double(currentBet) * xMultiply)
                
                ball.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.2), SKAction.removeFromParent()])) {
                    self.resetBall()
                }
            }
        }
    }
    
}

class ButtonNode: SKSpriteNode {
    
    var number: Int
    
    init(number: Int, size: CGSize) {
        self.number = number
        
        let background = SKSpriteNode(imageNamed: "plinko_number_stairs_btn_bg")
        background.size = size
        
        let numberLabel = SKLabelNode(text: "\(number)")
        numberLabel.fontName = "PoetsenOne-Regular"
        numberLabel.fontColor = .white
        numberLabel.fontSize = 82
        numberLabel.position = CGPoint(x: 0, y: -30)
        
        super.init(texture: nil, color: .clear, size: size)
        addChild(background)
        addChild(numberLabel)
        
    
        if number == 9 {
            setSelected()
        } else {
            unselect()
        }
        
    }
    
    func setSelected() {
        run(SKAction.fadeAlpha(to: 1, duration: 0.3))
    }
    
    func unselect() {
        run(SKAction.fadeAlpha(to: 0.6, duration: 0.3))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

#Preview {
    VStack {
        SpriteView(scene: PlinkoZeusSceneGame())
            .ignoresSafeArea()
    }
}

class PlinkoInfoGame {
    
    let ods = [
        9: [
            0.6,
            1.1,
            1.3,
            2,
            5,
            5,
            2,
            1.3,
            1.1,
            0.6
        ]
    ]
    
    let colorOds = [
        UIColor.init(red: 126/255, green: 171/255, blue: 233/255, alpha: 1),
        .white,
        UIColor.init(red: 0, green: 120/255, blue: 224/255, alpha: 1),
        UIColor.init(red: 222/255, green: 75/255, blue: 144/255, alpha: 1),
        UIColor.init(red: 255/255, green: 233/255, blue: 0, alpha: 1),
        UIColor.init(red: 255/255, green: 233/255, blue: 0, alpha: 1),
        UIColor.init(red: 222/255, green: 75/255, blue: 144/255, alpha: 1),
        UIColor.init(red: 0, green: 120/255, blue: 224/255, alpha: 1),
        .white,
        UIColor.init(red: 126/255, green: 171/255, blue: 233/255, alpha: 1)
    ]
    
}
