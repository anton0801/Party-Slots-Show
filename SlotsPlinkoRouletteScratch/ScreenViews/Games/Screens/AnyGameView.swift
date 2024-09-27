import SwiftUI
import SpriteKit

struct AnyGameView: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var user: User
    var gameId: String

    @State var showSlotsInfo = false
    
    @State var alertVisible = false
    @State var alertMessage = ""
    
    var body: some View {
        ZStack {
            if gameId == "plinko_zeus" {
                SpriteView(scene: PlinkoZeusSceneGame())
                    .ignoresSafeArea()
            } else if gameId == "spin_fort" {
                SpriteView(scene: SpinFortGameScene())
                    .ignoresSafeArea()
            } else if gameId == "slot_egypt" {
                SpriteView(scene: SlotEgyptSceneGame())
                    .ignoresSafeArea()
            }
            
            if showSlotsInfo {
                VStack {
                    ZStack {
                        Image("card_background")
                            .resizable()
                            .frame(width: 350, height: 450)
                        
                        VStack {
                            TabView {
                                Image("slot_egypt_info")
                                    .resizable()
                                    .frame(width: 350, height: 400)
                                    .tag(0)
                                
                                Image("slot_egypt_info_2")
                                    .tag(1)
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                            .frame(width: 350, height: 420)
                        }
                        
                        Button {
                            withAnimation(.easeIn) {
                                showSlotsInfo = false
                            }
                        } label: {
                            Image("close")
                        }
                        .offset(x: 170, y: -210)
                    }
                }
                .background(
                    Rectangle()
                        .fill(.black.opacity(0.4))
                        .frame(width: UIScreen.main.bounds.width,
                               height: UIScreen.main.bounds.height)
                        .ignoresSafeArea()
                )
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .homeAction), perform: { _ in
            user.credits = UserDefaults.standard.integer(forKey: "credits")
            presentationMode.wrappedValue.dismiss()
        })
        .onReceive(NotificationCenter.default.publisher(for: .infoAction), perform: { _ in
            withAnimation(.easeIn) {
                showSlotsInfo = true
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: .infoClose), perform: { _ in
            withAnimation(.easeIn) {
                showSlotsInfo = false
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: .alert), perform: { notification in
            guard let userInfo = notification.userInfo as? [String: Any],
                  let message = userInfo["message"] as? String else { return }
            alertVisible = true
            alertMessage = message
        })
        .alert(isPresented: $alertVisible, content: {
            Alert(title: Text("Alert"),
            message: Text(alertMessage),
                  dismissButton: .default(Text("OK")))
        })
    }
}

extension Notification.Name {
    static let homeAction = Notification.Name("home_pressed")
    static let infoAction = Notification.Name("info_action")
    static let infoClose = Notification.Name("info_close_action")
    static let alert = Notification.Name("alert")
}

#Preview {
    AnyGameView(gameId: "slot_egypt")
        .environmentObject(User())
}
