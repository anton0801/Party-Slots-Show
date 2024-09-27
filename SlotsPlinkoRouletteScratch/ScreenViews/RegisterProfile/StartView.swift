import SwiftUI

struct StartView: View {
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Image("card_background")
                    VStack(spacing: 16) {
                        Text("WELCOME!")
                            .foregroundColor(.white)
                            .font(.custom("PoetsenOne-Regular", size: 42))
                            .multilineTextAlignment(.center)
                        
                        Text("Choose a slot, win collect coins, and most importantly enjoy yourself")
                            .foregroundColor(.white)
                            .font(.custom("PoetsenOne-Regular", size: 24))
                            .multilineTextAlignment(.center)
                            .frame(width: 250)
                    }
                    
                    NavigationLink(destination: RegisterProfileView()
                        .navigationBarBackButtonHidden()) {
                            Image("next_btn")
                        }
                        .offset(y: 150)
                }
                
                Spacer()
            }
            .background(
                Image("menu_background_image")
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
    StartView()
}
