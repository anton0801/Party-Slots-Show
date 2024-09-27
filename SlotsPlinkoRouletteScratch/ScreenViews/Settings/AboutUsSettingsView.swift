import SwiftUI

struct AboutUsSettingsView: View {
    
    @Environment(\.presentationMode) var presMode
    @EnvironmentObject var user: User
    
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
            
            Text("About us")
                .foregroundColor(.white)
                .font(.custom("PoetsenOne-Regular", size: 32))
                .multilineTextAlignment(.center)
            
            ZStack {
                Image("card_background")
                ScrollView(showsIndicators: false) {
                    Text("DSADSADS DSADSADSAD DSADSAD DSADSAD DSADSAD DSADSDSADSADADSDSADSADDSADSAD")
                        .foregroundColor(.white)
                        .font(.custom("PoetsenOne-Regular", size: 32))
                        .multilineTextAlignment(.leading)
                }
                .frame(width: 250, height: 280)
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
    AboutUsSettingsView()
        .environmentObject(User())
}
