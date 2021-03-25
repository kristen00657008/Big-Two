//
//  GameOverView.swift
//  Big Two
//
//  Created by Chase on 2021/3/20.
//

import SwiftUI

struct GameOverView: View {
    @EnvironmentObject var gameSettings: GameSettings
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var cards: Cards
    @EnvironmentObject var players: Players
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("coin") var coin: Int = 1000
    var body: some View {
        ZStack {
            Color.gray
            VStack{
                Text("$\(coin)")
                    .border(Color.black)
                    .foregroundColor(Color.white)
                    .font(Font.system(size: 40))
                Spacer()
                if gameSettings.winner == 0 {
                    Text("Win!!!")
                        .foregroundColor(.orange)
                        .font(Font.system(size: 80))
                    Spacer()
                    Text("$$$ +1000 $$$")
                        .foregroundColor(.orange)
                        .font(Font.system(size: 30))
                }
                else {
                    Text("Lose QAQ")
                        .foregroundColor(.orange)
                        .font(Font.system(size: 80))
                    Spacer()
                    Text("$$$ -1000 $$$")
                        .foregroundColor(.orange)
                        .font(Font.system(size: 30))
                }
                
                Spacer()
                HStack {
                    Button(action: {
                        homepageBtn()
                    }) {
                        VStack{
                            Image("homepageBtn")
                                .resizable()
                                .renderingMode(.original)
                                .frame(width: 80, height: 50)
                        }
                        
                    }
                    .padding(.trailing,30)
                    Button(action: {
                        restartBtn()
                    }) {
                        VStack{
                            Image("restartBtn")
                                .resizable()
                                .renderingMode(.original)
                                .frame(width: 45, height: 45)
                        }
                    }.padding(.top,3)
                    .padding(.trailing,10)
                }
                Spacer()
            }
            .cornerRadius(20).shadow(radius: 20)
            EmptyView().sheet(isPresented: $gameSettings.isBankrupt){
                BankruptView()
            }
        }.edgesIgnoringSafeArea(.all)
        .onAppear{
            print("isBankrupt:\(gameSettings.isBankrupt)")
        }
        
    }
    
    func homepageBtn() {
        presentationMode.wrappedValue.dismiss()
        appSettings.isHomePageView = true
        appSettings.isGameView = false
        appSettings.isGameOverView = false
        appSettings.isLobbyView = false
        appSettings.isDealCardView = false
        appSettings.isMenuView = false
    }
    
    func restartBtn() {
        presentationMode.wrappedValue.dismiss()
        appSettings.isHomePageView = false
        appSettings.isLobbyView = false
        appSettings.isGameView = false
        appSettings.isMenuView = false
        appSettings.isDealCardView = true
        generateCards()
        licensing()
        gameSettings.currentCard[0] = Card(numInt: 0, suitStr: "back", suitInt: 0, realNum: 0)
        for i in 0..<52{
            gameSettings.showCard[i] = true
        }
    }
    
    func generateCards(){
        print("generateCards")
        cards.cards.removeAll()
        var realNum = 0
        let suits = ["clubs", "diamonds", "hearts", "spades"]
        for i in 1..<14 {
            for j in 1..<5 {
                if i == 1{
                    realNum = 14
                }
                else if i == 2 {
                    realNum = 15
                }
                else{
                    realNum = i
                }
                cards.cards.append(Card(numInt: i, suitStr: suits[j-1], suitInt: j, realNum: realNum))
            }
        }
    }
    
    func licensing() {
        cards.cards.shuffle()
        for i in 0..<4 {
            players.player[i].Cards.removeAll()
        }
        for i in 0..<52 {
            if(cards.cards[i].numInt == 3 && cards.cards[i].suitStr == "clubs"){
                gameSettings.turn = i % 4
            }
            players.player[i % 4].Cards.append(cards.cards[i])
        }
        cardSort()
    }
    
    func cardSort() {
        for i in 0..<4{
            players.player[i].Cards = players.player[i].Cards.sorted{ $0.suitInt < $1.suitInt}
            players.player[i].Cards = players.player[i].Cards.sorted{ $0.realNum < $1.realNum}
        }
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView()
    }
}
