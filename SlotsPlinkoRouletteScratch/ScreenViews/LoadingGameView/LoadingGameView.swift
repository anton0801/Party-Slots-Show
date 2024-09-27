import SwiftUI

struct LoadingGameView: View {
    
    @StateObject var user: User = User()
    @State var loadedSplash = false
    
    var body: some View {
        NavigationView {
            VStack {
                let username = UserDefaults.standard.string(forKey: "user_name")
                if username?.isEmpty == true || username == nil {
                    NavigationLink(destination: StartView()
                        .navigationBarBackButtonHidden(), isActive: $loadedSplash) {
                            
                        }
                } else {
                    NavigationLink(destination: ContentView()
                            .navigationBarBackButtonHidden()
                            .environmentObject(user), isActive: $loadedSplash) {
                                
                            }
                }
            }
            .onReceive(Timer.publish(every: 2.0, on: .main, in: .common).autoconnect(), perform: { _ in
                if !loadedSplash {
                    loadedSplash = true
                }
            })
            .background(
                Image("loading_image_background")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    LoadingGameView()
}
