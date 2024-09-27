import SpriteKit
import SwiftUI

class SlotEgyptSceneGame: SKScene {
    
    private var background: SKSpriteNode {
        get {
            let node = SKSpriteNode(imageNamed: "slot_egypt_bg")
            node.size = size
            node.position = CGPoint(x: size.width / 2, y: size.height / 2)
            node.zPosition = -1
            return node
        }
    }
    
    private var homeButton: SKSpriteNode {
        get {
            let homeNode = SKSpriteNode(imageNamed: "home_btn")
            homeNode.position = CGPoint(x: 250, y: 200)
            homeNode.name = "home_button"
            homeNode.size = CGSize(width: 190, height: 150)
            return homeNode
        }
    }    
    
    private var infoButton: SKSpriteNode {
        get {
            let homeNode = SKSpriteNode(imageNamed: "info_btn")
            homeNode.position = CGPoint(x: size.width - 250, y: 200)
            homeNode.name = "info_button"
            homeNode.size = CGSize(width: 190, height: 150)
            return homeNode
        }
    }
    
    private func saveBalanceAndShow() {
         balanceLabel.text = "\(balance)"
         UserDefaults.standard.set(balance, forKey: "credits")
     }
    
    private var balance: Int = UserDefaults.standard.integer(forKey: "credits") {
        didSet {
            saveBalanceAndShow()
        }
    }
    private var balanceLabel: SKLabelNode!
    
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
    
    private var playButton: SKSpriteNode!
    
    private var barabanNode1: BarabanNodeItemSloting!
    private var barabanNode2: BarabanNodeItemSloting!
    private var barabanNode3: BarabanNodeItemSloting!
    
    override func didMove(to view: SKView) {
        size = CGSize(width: 1200, height: 2100)
        
        addChild(background)
        addChild(homeButton)
        addChild(infoButton)
        
        createUserProfileItems()
        
        let winBackground = SKSpriteNode(imageNamed: "blue_back")
        winBackground.position = CGPoint(x: 600, y: 200)
        winBackground.size = CGSize(width: 400, height: 120)
        addChild(winBackground)
        
        winLabel = SKLabelNode(text: "0")
        winLabel.position = CGPoint(x: 600, y: 180)
        winLabel.fontName = "PoetsenOne-Regular"
        winLabel.fontColor = .white
        winLabel.fontSize = 62
        addChild(winLabel)
        
        playButton = SKSpriteNode(imageNamed: "plinko_play")
        playButton.position = CGPoint(x: size.width / 2 + 250, y: 400)
        playButton.size = CGSize(width: 400, height: 140)
        playButton.name = "play_btn"
        playButton.alpha = 1
        addChild(playButton)
        
        let currentBetLabelBackground = SKSpriteNode(imageNamed: "blue_back")
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
        
        let slotsBackground = SKSpriteNode(imageNamed: "slot_egypt_back")
        slotsBackground.position = CGPoint(x: size.width / 2, y: size.height / 2 + 150)
        slotsBackground.size = CGSize(width: 1100, height: 1100)
        addChild(slotsBackground)
        
        barabanNode1 = BarabanNodeItemSloting(egyptianSlotSymbols: [
            "slot_egypt_symbol_1", "slot_egypt_symbol_2", "slot_egypt_symbol_3", "slot_egypt_symbol_4", "slot_egypt_symbol_5", "slot_egypt_symbol_6", "slot_egypt_symbol_7", "slot_egypt_symbol_8", "slot_egypt_symbol_9"
        ], size: CGSize(width: 230, height: 720)) {
                   
        }
        barabanNode1.position = CGPoint(x: size.width / 2 - 280, y: size.height / 2)
        addChild(barabanNode1)

        barabanNode2 = BarabanNodeItemSloting(egyptianSlotSymbols: [
            "slot_egypt_symbol_1", "slot_egypt_symbol_2", "slot_egypt_symbol_3", "slot_egypt_symbol_4", "slot_egypt_symbol_5", "slot_egypt_symbol_6", "slot_egypt_symbol_7", "slot_egypt_symbol_8", "slot_egypt_symbol_9"
        ], size: CGSize(width: 230, height: 720)) {
           
        }
        barabanNode2.position = CGPoint(x: size.width / 2, y: size.height / 2 - 50)
        addChild(barabanNode2)

        barabanNode3 = BarabanNodeItemSloting(egyptianSlotSymbols: [
            "slot_egypt_symbol_1", "slot_egypt_symbol_2", "slot_egypt_symbol_3", "slot_egypt_symbol_4", "slot_egypt_symbol_5", "slot_egypt_symbol_6", "slot_egypt_symbol_7", "slot_egypt_symbol_8", "slot_egypt_symbol_9"
        ], size: CGSize(width: 230, height: 720)) {
            self.checkWinningLines()
        }
        barabanNode3.position = CGPoint(x: size.width / 2 + 280, y: size.height / 2)
        addChild(barabanNode3)
    }
    
    private func checkWinningLines() {
        playButton.alpha = 1
        
        let centerItem = atPoint(CGPoint(x: size.width / 2, y: size.height / 2 - 50))
        let leftItem = atPoint(CGPoint(x: size.width / 2 - 280, y: size.height / 2))
        let rightItem = atPoint(CGPoint(x: size.width / 2 + 280, y: size.height / 2))
        let leftTopSymbol = atPoint(CGPoint(x: size.width / 2 - 280, y: size.height / 2 + 230))
        let leftBottomSymbol = atPoint(CGPoint(x: size.width / 2 - 280, y: size.height / 2 - 230))
        let rightTopItem = atPoint(CGPoint(x: size.width / 2 + 280, y: size.height / 2 + 230))
        let rightBottomItem = atPoint(CGPoint(x: size.width / 2 + 280, y: size.height / 2 - 230))
        let centerTopItem = atPoint(CGPoint(x: size.width / 2, y: size.height / 2 + 280))
        let centerBottomItem = atPoint(CGPoint(x: size.width / 2, y: size.height / 2 - 280))
        
        if centerItem.name == leftItem.name && centerItem.name == rightItem.name {
            win += currentBet * 5
            animateNodes(nodes: [centerItem, leftItem, rightItem])
        }
        
        if centerTopItem.name == leftTopSymbol.name && centerTopItem.name == rightTopItem.name {
            win += currentBet * 5
            animateNodes(nodes: [centerTopItem, leftTopSymbol, rightTopItem])
        }
        
        if centerBottomItem.name == leftBottomSymbol.name && centerBottomItem.name == rightBottomItem.name {
            win += currentBet * 5
            animateNodes(nodes: [centerBottomItem, leftBottomSymbol, rightBottomItem])
        }
        
        if leftBottomSymbol.name == centerItem.name && centerItem.name == rightBottomItem.name {
            win += currentBet * 5
            animateNodes(nodes: [leftBottomSymbol, centerItem, rightBottomItem])
        }
        
        if leftTopSymbol.name == centerItem.name && centerItem.name == rightBottomItem.name {
            win += currentBet * 5
            animateNodes(nodes: [leftTopSymbol, centerItem, rightBottomItem])
        }
        
        if leftItem.name == centerBottomItem.name && centerBottomItem.name == rightItem.name {
            win += currentBet * 5
            animateNodes(nodes: [leftItem, centerBottomItem, rightItem])
        }
        
        if leftItem.name == centerTopItem.name && centerTopItem.name == rightItem.name {
            win += currentBet * 5
            animateNodes(nodes: [leftItem, centerTopItem, rightItem])
        }
        
        if leftTopSymbol.name == centerItem.name && centerItem.name == rightBottomItem.name {
            win += currentBet * 5
            animateNodes(nodes: [leftTopSymbol, centerItem, rightBottomItem])
        }
        
        if rightTopItem.name == centerItem.name && centerItem.name == leftBottomSymbol.name {
            win += currentBet * 5
            animateNodes(nodes: [rightTopItem, centerItem, leftBottomSymbol])
        }
    }
    
    private func animateNodes(nodes: [SKNode]) {
        for node in nodes {
            let actionScale = SKAction.scale(to: 1.3, duration: 0.3)
            let actionScale2 = SKAction.scale(to: 1, duration: 0.3)
            let seq = SKAction.sequence([actionScale, actionScale2])
            let repeate = SKAction.repeat(seq, count: 3)
            node.run(repeate)
        }
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
    
    class BarabanNodeItemSloting: SKSpriteNode {
        
        var randomValue: Int = 42
        var meaninglessArray: [Int] = []
        
        private let barabanCrop: SKCropNode
        var egyptianSlotSymbols: [String]
        
        init(egyptianSlotSymbols: [String], size: CGSize, spinEndCallback: @escaping () -> Void) {
            self.egyptianSlotSymbols = egyptianSlotSymbols
            self.barabanCrop = SKCropNode()
            self.barabanContent = SKNode()
            self.spinEndCallback = spinEndCallback
            super.init(texture: nil, color: .clear, size: size)
            addSymbols()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        var spinEndCallback: () -> Void
        
        func addSymbols() {
            barabanCrop.position = CGPoint(x: 0, y: 0)
            let maskNode = SKSpriteNode(color: .black, size: size)
            maskNode.position = CGPoint(x: 0, y: 0)
            barabanCrop.maskNode = maskNode
            addChild(barabanCrop)
            
            func pointlessFunction() -> Int {
                // Бессмысленный цикл, возвращающий один и тот же результат
                var result = 0
                for number in meaninglessArray {
                    result += number % 2 == 0 ? number / 2 : number * 2
                    result *= randomValue
                    result -= randomValue / 2
                }
                return result
            }
            
            barabanCrop.addChild(barabanContent)
            let shuffledSymbols = egyptianSlotSymbols.shuffled()
            for i in 0..<egyptianSlotSymbols.count * 8 {
                let symbolName = shuffledSymbols[i % 8]
                let symbol = SKSpriteNode(imageNamed: symbolName)
                symbol.size = CGSize(width: 230, height: 220)
                symbol.zPosition = 1
                symbol.name = symbolName
                symbol.position = CGPoint(x: 0, y: size.height - CGFloat(i) * 240.5)
                barabanContent.addChild(symbol)
            }
            barabanContent.run(SKAction.moveBy(x: 0, y: 240.5 * CGFloat(egyptianSlotSymbols.count * 3), duration: 0.0))
        }
        
        func unnecessaryRecursion(_ value: Int) -> Int {
            // Бессмысленная рекурсия
            if value == 0 {
                return 0
            }
            return value + unnecessaryRecursion(value - 1)
        }
        
        var spinReversedState = false
        
        func startScrolling() {
            if spinReversedState {
                spinReversedState = false
                let actionMove = SKAction.moveBy(x: 0, y: -(240.5 * CGFloat(Int.random(in: 4...6))), duration: 0.5)
                barabanContent.run(actionMove) {
                    self.spinEndCallback()
                }
            } else {
                let actionMove = SKAction.moveBy(x: 0, y: 240.5 * CGFloat(Int.random(in: 4...6)), duration: 0.5)
                barabanContent.run(actionMove) {
                    self.spinEndCallback()
                }
                spinReversedState = true
            }
        }
        private let barabanContent: SKNode
        
        func endlessLoop() {
            // Цикл с ненужной работой
            var counter = 0
            while counter < 1000 {
                counter += Int.random(in: 1...5)
                if counter % 100 == 0 {
                    print("Pointless milestone: \(counter)")
                }
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touched = touches.first {
            let locationTouch = touched.location(in: self)
            let touchedObject = atPoint(locationTouch)
            
            switch (touchedObject.name) {
            case "plus_bet":
                if playButton.alpha == 1 {
                    if currentBet < 1000 {
                        currentBet += 100
                    }
                }
            case "minus_bet":
                if playButton.alpha == 1 {
                    if currentBet > 100 {
                        currentBet -= 100
                    }
                }
            case "play_btn":
                if playButton.alpha == 1 {
                    self.win = 0
                    spin()
                }
            case "home_button":
                NotificationCenter.default.post(name: .homeAction, object: nil)
            case "info_button":
                NotificationCenter.default.post(name: .infoAction, object: nil)
            default:
                let a = 0
            }
        }
    }
    
    private func spin() {
        playButton.alpha = 0.6
        if balance >= currentBet {
            balance -= currentBet
            barabanNode1.startScrolling()
            barabanNode2.startScrolling()
            barabanNode3.startScrolling()
        }
    }
    
}

#Preview {
    VStack {
        SpriteView(scene: SlotEgyptSceneGame())
            .ignoresSafeArea()
    }
}
