import SwiftUI
import SpriteKit

class SpinFortGameScene: SKScene {
    
    private var homeButton: SKSpriteNode {
        get {
            let homeNode = SKSpriteNode(imageNamed: "spin_fort_home_btn")
            homeNode.position = CGPoint(x: 250, y: 200)
            homeNode.name = "home_button"
            homeNode.size = CGSize(width: 170, height: 150)
            return homeNode
        }
    }
    
    private var balance: Int = UserDefaults.standard.integer(forKey: "credits") {
        didSet {
            saveBalanceAndShow()
        }
    }
    private var balanceLabel: SKLabelNode!
    
    let wheelSegments = 12
    let segmentPrizes = [
        1,2,5,10,1,2,5,1,2,1,2,1
    ]
    
    private var betSegment: String? = nil {
        didSet {
            if betSegment != nil {
                paysSegmentSelected?.run(SKAction.fadeAlpha(to: 1, duration: 0.3))
            } else {
                paysSegmentSelected?.run(SKAction.fadeAlpha(to: 0.6, duration: 0.3))
                paysSegmentSelected = nil
            }
        }
    }
    private var paysSegmentSelected: SKNode? = nil
    
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
    
    private var background: SKSpriteNode {
        get {
            let node = SKSpriteNode(imageNamed: "spin_fort_back")
            node.size = size
            node.position = CGPoint(x: size.width / 2, y: size.height / 2)
            node.zPosition = -1
            return node
        }
    }
    
    private var wheel: SKSpriteNode!
    private var wheelDetermineLayer: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        size = CGSize(width: 1200, height: 2100)

        addChild(background)
        
        createUserProfileItems()
        
        wheel = SKSpriteNode(imageNamed: "spin_fort_wheel")
        wheel.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        wheel.position = CGPoint(x: size.width / 2, y: size.height / 2 + 250)
        wheel.size = CGSize(width: 950, height: 1350)
        wheel.physicsBody = nil
        
        wheel.xScale = 1.0
        wheel.yScale = 1.0
        
        addChild(wheel)
        
        let rouletteIndicator = SKSpriteNode(imageNamed: "spin_fort_indicator")
        rouletteIndicator.position = CGPoint(x: size.width / 2, y: size.height / 2 + 600)
        rouletteIndicator.size = CGSize(width: 60, height: 52)
        addChild(rouletteIndicator)
        
        addDetermineLayer()
        
        addChild(homeButton)
        
        let winBackground = SKSpriteNode(imageNamed: "spin_fort_value_back")
        winBackground.position = CGPoint(x: 600, y: 200)
        winBackground.size = CGSize(width: 400, height: 120)
        addChild(winBackground)
        
        winLabel = SKLabelNode(text: "0")
        winLabel.position = CGPoint(x: 600, y: 180)
        winLabel.fontName = "PoetsenOne-Regular"
        winLabel.fontColor = .white
        winLabel.fontSize = 62
        addChild(winLabel)
        
        let dropBallBtn = SKSpriteNode(imageNamed: "spin_fort_play")
        dropBallBtn.position = CGPoint(x: size.width / 2 + 250, y: 400)
        dropBallBtn.size = CGSize(width: 400, height: 140)
        dropBallBtn.name = "drop_ball"
        addChild(dropBallBtn)
        
        let currentBetLabelBackground = SKSpriteNode(imageNamed: "spin_fort_value_back")
        currentBetLabelBackground.position = CGPoint(x: size.width / 2 - 250, y: 400)
        currentBetLabelBackground.size = CGSize(width: 400, height: 140)
        addChild(currentBetLabelBackground)
        
        let plusBetBtn = SKLabelNode(text: "+")
        plusBetBtn.fontName = "PoetsenOne-Regular"
        plusBetBtn.fontColor = .white
        plusBetBtn.fontSize = 62
        plusBetBtn.position = CGPoint(x: size.width / 2 - 100, y: 380)
        plusBetBtn.name = "plus_bet"
        addChild(plusBetBtn)
        
        let minusBetBtn = SKLabelNode(text: "-")
        minusBetBtn.fontName = "PoetsenOne-Regular"
        minusBetBtn.fontColor = .white
        minusBetBtn.fontSize = 62
        minusBetBtn.position = CGPoint(x: 200, y: 380)
        minusBetBtn.name = "minus_bet"
        addChild(minusBetBtn)
        
        let coinImage = SKSpriteNode(imageNamed: "coin")
        coinImage.position = CGPoint(x: size.width / 2 - 180, y: 400)
        coinImage.size = CGSize(width: 60, height: 60)
        addChild(coinImage)
        
        currentBetLabel = SKLabelNode(text: "\(currentBet)")
        currentBetLabel.position = CGPoint(x: size.width / 2 - 300, y: 385)
        currentBetLabel.fontName = "PoetsenOne-Regular"
        currentBetLabel.fontColor = .white
        currentBetLabel.fontSize = 42
        addChild(currentBetLabel)
        
        addPays()
        
        // spin()
    }
    
    private func addDetermineLayer() {
        wheelDetermineLayer = SKSpriteNode(color: .clear, size: wheel.size)
        wheelDetermineLayer.position = wheel.position
        addChild(wheelDetermineLayer)
        let itemAngle = 2 * .pi / CGFloat(wheelSegments)
        for i in 0..<wheelSegments {
            let dnode = SKSpriteNode(color: .clear, size: CGSize(width: 700, height: 75))
            dnode.anchorPoint = CGPoint(x: 0.5, y: 1)
            dnode.position = CGPoint(x: 0, y: 0)
            dnode.zRotation = -(itemAngle * CGFloat(i) - .pi / 2)
            dnode.name = "\(segmentPrizes[i])"
            wheelDetermineLayer.addChild(dnode)
        }
    }
    
    private var rotatingWheel = false
    
    private func spin() {
        if balance >= currentBet {
            if betSegment != nil {
                // Уменьшаем баланс
                balance -= currentBet
                
                // Сбрасываем масштаб, чтобы избежать деформации
                wheel.xScale = 1.0
                wheel.yScale = 1.0
                rotatingWheel = true
                // Устанавливаем точку привязки к центру
                wheel.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                
                // Генерируем случайное значение для вращения
                let randomSpin = CGFloat.random(in: 5...10)
                let rotateBy = randomSpin * 2 * .pi
                
                // Создаем действие вращения с easeInEaseOut
                let rotateAction = SKAction.rotate(byAngle: rotateBy, duration: 4.0)
                rotateAction.timingMode = .easeInEaseOut
                
                // Выполняем вращение
                wheel.run(rotateAction)
                wheelDetermineLayer.run(rotateAction) {
                    self.rotatingWheel = false
                    self.checkPrize()
                }
            } else {
                NotificationCenter.default.post(name: Notification.Name("alert"), object: nil, userInfo: ["message": "You must choose bet (pays 1x, pays 2x, etc.)"])
            }
        }
    }
    
    private func checkPrize() {
        let winningNode = atPoint(CGPoint(x: wheel.position.x, y: wheel.position.y + 250))
        
        if let prizeName = winningNode.name, let prize = Int(prizeName) {
            if prize == 1 && betSegment == "pay1" {
                win = currentBet * 1
            } else if prize == 2 && betSegment == "pay2" {
                win = currentBet * 2
            } else if prize == 5 && betSegment == "pay3" {
                win = currentBet * 5
            } else if prize == 10 && betSegment == "pay4" {
                win = currentBet * 10
            }
            balance += win
        }
        
        betSegment = nil
    }
    
    private func addPays() {
        let pay1 = SKSpriteNode(imageNamed: "pays_1")
        pay1.position = CGPoint(x: 330, y: 800)
        pay1.size = CGSize(width: 350, height: 200)
        pay1.alpha = 0.6
        pay1.name = "pay1"
        addChild(pay1)
        
        let pay2 = SKSpriteNode(imageNamed: "pays_2")
        pay2.position = CGPoint(x: 830, y: 800)
        pay2.size = CGSize(width: 350, height: 200)
        pay2.alpha = 0.6
        pay2.name = "pay2"
        addChild(pay2)
        
        
        let pay3 = SKSpriteNode(imageNamed: "pays_3")
        pay3.position = CGPoint(x: 330, y: 590)
        pay3.size = CGSize(width: 350, height: 200)
        pay3.alpha = 0.6
        pay3.name = "pay1"
        addChild(pay3)
        
        let pay4 = SKSpriteNode(imageNamed: "pays_4")
        pay4.position = CGPoint(x: 830, y: 590)
        pay4.size = CGSize(width: 350, height: 200)
        pay4.alpha = 0.6
        pay4.name = "pay4"
        addChild(pay4)
    }
    
    private func createUserProfileItems() {
        let userDataBackground = SKSpriteNode(imageNamed: "value_back")
        userDataBackground.position = CGPoint(x: 320, y: size.height - 200)
        userDataBackground.size = CGSize(width: 500, height: 120)
        addChild(userDataBackground)
        
        let userAvatar = SKSpriteNode(imageNamed: UserDefaults.standard.string(forKey: "user_avatar") ?? "avatar_1")
        userAvatar.position = CGPoint(x: 170, y: size.height - 200)
        userAvatar.size = CGSize(width: 220, height: 150)
        addChild(userAvatar)
        
        let userName = SKLabelNode(text: UserDefaults.standard.string(forKey: "user_name") ?? "")
        userName.fontName = "PoetsenOne-Regular"
        userName.fontColor = .white
        userName.fontSize = 42
        userName.position = CGPoint(x: 400, y: size.height - 220)
        addChild(userName)
        
        let userCreditsBackground = SKSpriteNode(imageNamed: "value_back")
        userCreditsBackground.position = CGPoint(x: size.width - 320, y: size.height - 200)
        userCreditsBackground.size = CGSize(width: 500, height: 120)
        addChild(userCreditsBackground)
        
        let coinImage = SKSpriteNode(imageNamed: "coin")
        coinImage.position = CGPoint(x: size.width - 170, y: size.height - 200)
        coinImage.size = CGSize(width: 220, height: 150)
        addChild(coinImage)
        
        balanceLabel = SKLabelNode(text: "\(formatNumber(balance))")
        balanceLabel.fontName = "PoetsenOne-Regular"
        balanceLabel.fontColor = .white
        balanceLabel.fontSize = 42
        balanceLabel.position = CGPoint(x: size.width - 400, y: size.height - 220)
        addChild(balanceLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touched = touches.first {
            let locationTouch = touched.location(in: self)
            let touchedObject = atPoint(locationTouch)
            
            if touchedObject.name?.contains("pay") == true {
                paysSegmentSelected?.run(SKAction.fadeAlpha(to: 0.6, duration: 0.3))
                paysSegmentSelected = touchedObject
                betSegment = touchedObject.name
            }
            
            switch (touchedObject.name) {
            case "plus_bet":
                if !rotatingWheel {
                    if currentBet < 1000 {
                        currentBet += 100
                    }
                }
            case "minus_bet":
                if !rotatingWheel {
                    if currentBet > 100 {
                        currentBet -= 100
                    }
                }
            case "drop_ball":
                self.win = 0
                spin()
            case "home_button":
                NotificationCenter.default.post(name: .homeAction, object: nil)
            default:
                let a = 0
            }
        }
    }
    
}

#Preview {
    VStack {
        SpriteView(scene: SpinFortGameScene())
            .ignoresSafeArea()
    }
}
