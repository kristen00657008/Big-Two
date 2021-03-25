//
//  GamesLobbyView.swift
//  BIg Two
//
//  Created by User16 on 2021/3/10.
//

import SwiftUI

struct LobbyView: View {
    @EnvironmentObject var gameSettings: GameSettings
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var cards: Cards
    @EnvironmentObject var players: Players
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                Image("homepage")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    HStack{
                        //TopView()
                    }
                    Spacer()
                    HStack{
                        /*Button(action: {
                            print("進入對戰紀錄")
                        }, label: {
                            VStack{
                                Image(systemName: "book.fill")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                Text("對戰紀錄").font(Font.system(size: 30))
                            }.padding(.trailing , 250).foregroundColor(.orange)
                        })
                        */
                        Button(action: {
                            print("開局")
                            startBtn()
                        }, label: {
                            VStack{
                                Image(systemName: "play.fill")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                Text("開局").font(Font.system(size: 30))
                            }.foregroundColor(.orange)
                        })
                    }
                    Spacer()
                }.frame(width: geometry.size.width, height: geometry.size.height)
            }.frame(width: geometry.size.width, height: geometry.size.height)
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
        players.player[0].Cards.removeAll()
        players.player[1].Cards.removeAll()
        players.player[2].Cards.removeAll()
        players.player[3].Cards.removeAll()
        for i in 0..<52 {
            if(cards.cards[i].numInt == 3 && cards.cards[i].suitStr == "clubs"){
                gameSettings.turn = i % 4
            }
            players.player[i % 4].Cards.append(cards.cards[i])
        }
        cardSort()
    }
    
    func cardSort() {
        print("cardSort")
        for i in 0..<4{
            players.player[i].Cards = players.player[i].Cards.sorted{ $0.suitInt < $1.suitInt}
            players.player[i].Cards = players.player[i].Cards.sorted{ $0.realNum < $1.realNum}
        }
    }
    
    func startBtn() {
        appSettings.isHomePageView = false
        appSettings.isLobbyView = false
        appSettings.isDealCardView = true
        generateCards()
        licensing()
        gameSettings.currentCard[0] = Card(numInt: 0, suitStr: "back", suitInt: 0, realNum: 0)
        for i in 0..<52{
            gameSettings.showCard[i] = true
        }
        print("startBtn Finish")
    }
}

struct LobbyView_Previews: PreviewProvider {
    static var previews: some View {
        LobbyView().previewLayout(.fixed(width: 844, height: 390))
        
    }
}
