import SwiftUI

struct AvailableSlotListView: View {
    
    @Environment(\.presentationMode) var presMode
    @EnvironmentObject var user: User
    
    var allGames = [
        "slot_egypt",
        "spin_fort",
        "plinko_zeus"
    ]
    @State var currentSlotIndex = 0
    
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
                
                Text("CHOOSE SLOT\nTO PLAY")
                    .foregroundColor(.white)
                    .font(.custom("PoetsenOne-Regular", size: 42))
                    .multilineTextAlignment(.center)
                
                TabView(selection: $currentSlotIndex) {
                    ForEach(allGames.indices, id: \.self) { gameIndex in
                        NavigationLink(destination: AnyGameView(gameId: allGames[gameIndex])
                            .environmentObject(user)
                            .navigationBarBackButtonHidden()) {
                                Image(allGames[gameIndex])
                                    .resizable()
                                    .frame(width: 250, height: 350)
                                    .tag(gameIndex)
                            }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack {
                    Spacer()
                    Button {
                        withAnimation(.linear) {
                            currentSlotIndex -= 1
                        }
                    } label: {
                        Image("arrow_back")
                    }
                    .opacity(currentSlotIndex == 0 ? 0.4 : 1)
                    .disabled(currentSlotIndex == 0 ? true : false)
                    
                    Button {
                        withAnimation(.linear) {
                            currentSlotIndex += 1
                        }
                    } label: {
                        Image("arrow_next")
                    }
                    .opacity(currentSlotIndex == allGames.count - 1 ? 0.4 : 1)
                    .disabled(currentSlotIndex == allGames.count - 1 ? true : false)
                    
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
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    AvailableSlotListView()
        .environmentObject(User())
}
