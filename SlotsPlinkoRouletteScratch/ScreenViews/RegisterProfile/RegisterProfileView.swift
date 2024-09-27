import SwiftUI

struct RegisterProfileView: View {
    
    @State var username: String = ""
    @State var avatar: String = ""
    
    @State var showAvatars = false
    
    var avatars = [
        "avatar_1",
        "avatar_2",
        "avatar_3",
        "avatar_4",
        "avatar_5",
        "avatar_6"
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Image("card_background")
                    VStack(spacing: 16) {
                        Button {
                            withAnimation(.easeIn) {
                                showAvatars = true
                            }
                        } label: {
                            if avatar.isEmpty {
                                Image("avatar_placeholder")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                            } else {
                                Image(avatar)
                                    .resizable()
                                    .frame(width: 80, height: 80)
                            }
                        }
                        
                        if showAvatars {
                            LazyVGrid(columns: [
                                GridItem(.fixed(70)),
                                GridItem(.fixed(70)),
                                GridItem(.fixed(70))
                            ]) {
                                ForEach(avatars, id: \.self) { userAvatar in
                                    Button {
                                        avatar = userAvatar
                                        withAnimation(.easeOut) {
                                            showAvatars = false
                                        }
                                    } label: {
                                        Image(userAvatar)
                                    }
                                }
                            }
                        } else {
                            HStack {
                                Spacer()
                                Text("YOUR NAME")
                                    .foregroundColor(.white)
                                    .font(.custom("PoetsenOne-Regular", size: 24))
                            }
                            .frame(width: 260)
                            .padding(.top)
                            
                            TextField("Your name", text: $username)
                                .font(.custom("PoetsenOne-Regular", size: 18))
                                .foregroundColor(.white)
                                .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                                .background(
                                    RoundedRectangle(cornerRadius: 12.0, style: .continuous)
                                        .fill(RadialGradient(colors: [
                                            Color.init(red: 62/255, green: 245/255, blue: 169/255).opacity(0.2),
                                            Color.init(red: 100/255, green: 136/255, blue: 0).opacity(0.2),
                                        ], center: .center, startRadius: 0, endRadius: 360))
                                )
                                .background(
                                    RoundedRectangle(cornerRadius: 12.0, style: .continuous)
                                        .stroke(.white, lineWidth: 3.0)
                                )
                                .frame(width: 250)
                        }
                    }
                    
                    NavigationLink(destination: RegisterProfileView()
                       .navigationBarBackButtonHidden()) {
                           Image("start_btn")
                       }
                       .offset(y: 170)
                       .opacity((username.isEmpty || avatar.isEmpty) ? 0.6 : 1)
                       .disabled((username.isEmpty || avatar.isEmpty) ? true : false)
                }
                
                Spacer()
            }
            .onChange(of: username) { newValue in
                UserDefaults.standard.set(newValue, forKey: "user_name")
            }
            .onChange(of: avatar) { newValue in
                UserDefaults.standard.set(newValue, forKey: "user_avatar")
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
    RegisterProfileView()
}
