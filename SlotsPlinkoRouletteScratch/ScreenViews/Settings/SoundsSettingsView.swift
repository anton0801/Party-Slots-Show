import SwiftUI

struct SoundsSettingsView: View {

    @Environment(\.presentationMode) var presMode
    @EnvironmentObject var user: User
    
    @State var soundState = UserDefaults.standard.bool(forKey: "sound_state")
    @State var musicState = UserDefaults.standard.bool(forKey: "music_state")
    @State var vibroState = UserDefaults.standard.bool(forKey: "vibro_state")
    
    var body: some View {
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
            
            Text("Sounds")
                .foregroundColor(.white)
                .font(.custom("PoetsenOne-Regular", size: 32))
                .multilineTextAlignment(.center)
            
            ZStack {
                Image("card_background")
                VStack {
                    HStack {
                        Text("SOUND")
                            .foregroundColor(.white)
                            .font(.custom("PoetsenOne-Regular", size: 32))
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                        
                        Toggle(isOn: $soundState, label: {
                            EmptyView()
                        })
                        .onChange(of: soundState) { newValue in
                            UserDefaults.standard.set(newValue, forKey: "sound_state")
                        }
                    }
                    Spacer()
                    HStack {
                        Text("MUSIC")
                            .foregroundColor(.white)
                            .font(.custom("PoetsenOne-Regular", size: 32))
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                        
                        Toggle(isOn: $musicState, label: {
                            EmptyView()
                        })
                        .onChange(of: musicState) { newValue in
                            UserDefaults.standard.set(newValue, forKey: "music_state")
                        }
                    }
                    Spacer()
                    HStack {
                        Text("VIBRATION")
                            .foregroundColor(.white)
                            .font(.custom("PoetsenOne-Regular", size: 24))
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                        
                        Toggle(isOn: $vibroState, label: {
                            EmptyView()
                        })
                        .onChange(of: vibroState) { newValue in
                            UserDefaults.standard.set(newValue, forKey: "vibro_state")
                        }
                    }
                }
                .frame(width: 250, height: 200)
            }
            
            Button {
                presMode.wrappedValue.dismiss()
            } label: {
                Image("arrow_back")
            }
            .padding(.top, 42)
            
            Spacer()
        }
        .background(
            Image("slot_list_background")
                .resizable()
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
    
}

#Preview {
    SoundsSettingsView()
        .environmentObject(User())
}
