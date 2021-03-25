//
//  MenuView.swift
//  Big Two
//
//  Created by Chase on 2021/3/22.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var gameSettings: GameSettings
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var cards: Cards
    @EnvironmentObject var players: Players
    @State private var volume:Float = 1
    var body: some View {
        ZStack {
            Color.white
            VStack{
                HStack{
                    Text("音樂")
                        .font(Font.system(size: 25))
                    Slider(value: $volume, in: 0...1 ){_ in
                            appSettings.player.volume = volume
                        }
                }.frame(width: UIScreen.main.bounds.width * 0.45)
                HStack {
                    Button(action: {
                        homepageBtn()
                    }) {
                        VStack{
                            Image("homepageBtn")
                                .resizable()
                                .renderingMode(.original)
                                .frame(width: 45, height: 45)
                            Text("回首頁")
                                .padding(.top,1)
                        }
                    }
                    .padding(.leading,10)
                    Spacer()
                    Button(action: {
                        restartBtn()
                    }) {
                        VStack{
                            Image("restartBtn")
                                .resizable()
                                .renderingMode(.original)
                                .frame(width: 45, height: 45)
                            Text("再來一次").padding(.top,1)
                        }
                    }.padding(.top,3)
                    .padding(.trailing,10)
                    Spacer()
                    Button(action: {
                        appSettings.isMenuView = false
                        
                    }) {
                        VStack{
                            Image(systemName: "play.fill")
                                .resizable()
                                .renderingMode(.original)
                                .frame(width: 45, height: 45)
                            Text("繼續").padding(.top,1)
                        }
                    }.padding(.top,3)
                    .padding(.trailing,22)
                }
            }
        }
        .cornerRadius(20).shadow(radius: 20)
        .onAppear{
            appSettings.player.volume = volume
        }
    }
    
    func homepageBtn() {
        appSettings.isHomePageView = true
        appSettings.isGameView = false
        appSettings.isGameOverView = false
        appSettings.isLobbyView = false
        appSettings.isDealCardView = false
        appSettings.isMenuView = false
    }
    
    func restartBtn() {
        appSettings.isHomePageView = false
        appSettings.isLobbyView = false
        appSettings.isGameView = false
        appSettings.isMenuView = false
        appSettings.isDealCardView = true
        generateCards()
        licensing()
        gameSettings.current_card_type = 0
        gameSettings.pass_opacity = [0.0, 0.0, 0.0, 0.0]
        gameSettings.isFirst = true
        for i in 0..<5 {
            gameSettings.currentCard[i] = Card(numInt: 0, suitStr: "back", suitInt: 0, realNum: 0)
        }
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
