import SwiftUI

struct SettingsProfileView: View {
    
    @Environment(\.presentationMode) var presMode
    @EnvironmentObject var user: User
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    ZStack {
                        Image("value_back")
                        HStack {
                            Image(user.avatar)
                            Text(user.userName ?? "")
                                .foregroundColor(.white)
                                .font(.custom("PoetsenOne-Regular", size: 18))
                            Spacer()
                        }
                        .frame(width: 200)
                    }
                    Spacer()
                    ZStack {
                        Image("balance_background")
                        Text(formatNumber(user.credits))
                            .foregroundColor(.white)
                            .font(.custom("PoetsenOne-Regular", size: 22))
                            .offset(x: 15)
                    }
                }
                .padding(.horizontal)
                
                Text("SETTINGS")
                    .foregroundColor(.white)
                    .font(.custom("PoetsenOne-Regular", size: 42))
                    .multilineTextAlignment(.center)
                
                ZStack {
                    Image("card_background")
                    VStack {
//                        NavigationLink(destination: EmptyView()
//                            .navigationBarBackButtonHidden()
//                            .environmentObject(user)) {
//                                ZStack {
//                                    Image("button_bg")
//                                    Text("Profile")
//                                        .foregroundColor(.white)
//                                        .font(.custom("PoetsenOne-Regular", size: 32))
//                                }
//                            }
                        NavigationLink(destination: SoundsSettingsView()
                            .navigationBarBackButtonHidden()
                            .environmentObject(user)) {
                                ZStack {
                                    Image("button_bg")
                                    Text("Sounds")
                                        .foregroundColor(.white)
                                        .font(.custom("PoetsenOne-Regular", size: 32))
                                }
                            }
                        NavigationLink(destination: AboutUsSettingsView()
                            .navigationBarBackButtonHidden()
                            .environmentObject(user)) {
                                ZStack {
                                    Image("button_bg")
                                    Text("About us")
                                        .foregroundColor(.white)
                                        .font(.custom("PoetsenOne-Regular", size: 32))
                                }
                            }
                    }
                }
                
                Spacer()
                
                HStack {
                    Button {
                        presMode.wrappedValue.dismiss()
                    } label: {
                        Image("home_btn")
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }
            .background(
                Image("slot_list_background")
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
    SettingsProfileView()
        .environmentObject(User())
}
