import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var user: User
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
//                    Spacer()
//                    NavigationLink(destination: EmptyView()
//                        .environmentObject(user)
//                        .navigationBarBackButtonHidden()) {
//                        VStack {
//                            Image("shop")
//                            Text("Shop")
//                                .foregroundColor(.white)
//                                .font(.custom("PoetsenOne-Regular", size: 22))
//                        }
//                    }
                    Spacer()
                    NavigationLink(destination: DailyBonusView()
                        .environmentObject(user)
                        .navigationBarBackButtonHidden()) {
                        VStack {
                            Image("daily_prizes")
                            Text("daily")
                                .foregroundColor(.white)
                                .font(.custom("PoetsenOne-Regular", size: 22))
                        }
                    }
                    Spacer()
                    NavigationLink(destination: SettingsProfileView()
                        .environmentObject(user)
                        .navigationBarBackButtonHidden()) {
                        VStack {
                            Image("settings_button")
                            Text("settings")
                                .foregroundColor(.white)
                                .font(.custom("PoetsenOne-Regular", size: 22))
                        }
                    }
                    Spacer()
                }
                
                ZStack {
                    Image("balance_background")
                    Text(formatNumber(user.credits))
                        .foregroundColor(.white)
                        .font(.custom("PoetsenOne-Regular", size: 22))
                        .offset(x: 15)
                }
                .padding(.top, 42)
                
                NavigationLink(destination: AvailableSlotListView()
                    .environmentObject(user)
                    .navigationBarBackButtonHidden()) {
                    Image("play_button")
                }
                .padding(.top, 32)
                
                
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
    ContentView()
        .environmentObject(User())
}
