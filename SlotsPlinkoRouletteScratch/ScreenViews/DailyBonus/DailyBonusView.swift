import SwiftUI

struct DailyBonusView: View {
    
    @Environment(\.presentationMode) var presMode
    @EnvironmentObject var user: User
    @StateObject var dailyBonusManager = DailyBonusManager()
    
    @State var currentBonusPage = 0
    @State var alertVisible = false
    @State var claimSuccess = false
    
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
            
            Text("CHOOSE SLOT\nTO PLAY")
                .foregroundColor(.white)
                .font(.custom("PoetsenOne-Regular", size: 42))
                .multilineTextAlignment(.center)
            
            TabView(selection: $currentBonusPage) {
                ForEach(0...dailyBonusManager.maxDays - 1, id: \.self) { gameIndex in
                    let bonusPrize = (gameIndex + 1) * 2000
                    ZStack {
                        Image("card_background")
                        VStack {
                            Text("DAY \(gameIndex + 1)")
                                .foregroundColor(.white)
                                .font(.custom("PoetsenOne-Regular", size: 32))
                                .multilineTextAlignment(.center)
                            
                            Spacer()
                            
                            switch (bonusPrize) {
                            case 2000, 4000:
                                Image("coins_1")
                            case 6000, 8000:
                                Image("coins_2")
                            case 10000, 12000:
                                Image("coins_3")
                            case 14000:
                                Image("coins_4")
                            default:
                                EmptyView()
                            }
                            
                            Spacer()
                            
                            Text("\(bonusPrize)X")
                                .foregroundColor(.white)
                                .font(.custom("PoetsenOne-Regular", size: 32))
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 24)
                        }
                        .frame(height: 280)
                        
                        if dailyBonusManager.isBonusAvailable(for: gameIndex + 1) {
                            Button {
                                if dailyBonusManager.isBonusAvailable(for: gameIndex + 1) {
                                    let claimPrize = dailyBonusManager.claimBonus(for: gameIndex + 1)
                                    if claimPrize != nil {
                                        user.credits += claimPrize!
                                        claimSuccess = true
                                    } else {
                                        claimSuccess = false
                                    }
                                } else {
                                    claimSuccess = false
                                }
                                alertVisible = true
                            } label: {
                                Image("get_button")
                            }
                            .offset(y: 150)
                        }
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            HStack {
                Spacer()
                Button {
                    withAnimation(.linear) {
                        currentBonusPage -= 1
                    }
                } label: {
                    Image("arrow_back")
                }
                .opacity(currentBonusPage == 0 ? 0.4 : 1)
                .disabled(currentBonusPage == 0 ? true : false)
                
                Button {
                    withAnimation(.linear) {
                        currentBonusPage += 1
                    }
                } label: {
                    Image("arrow_next")
                }
                .opacity(currentBonusPage == dailyBonusManager.maxDays - 1 ? 0.4 : 1)
                .disabled(currentBonusPage == dailyBonusManager.maxDays - 1 ? true : false)
                
                Spacer()
            }
            
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
        .alert(isPresented: $alertVisible) {
            if claimSuccess {
                Alert(title: Text("Bonus claimed"),
                      dismissButton: .default(Text("Ok")))
            } else {
                Alert(title: Text("Error!"),
                      message: Text("This bonus is not available, either you have already received it or it is not available yet. Try more later!"),
                      dismissButton: .default(Text("Ok")))
            }
        }
    }
}

#Preview {
    DailyBonusView()
        .environmentObject(User())
}
