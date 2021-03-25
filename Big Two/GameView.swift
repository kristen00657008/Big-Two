//
//  GameView.swift
//  BIg Two
//
//  Created by Chase on 2021/3/16.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var gameSettings: GameSettings
    @EnvironmentObject var cards: Cards
    @EnvironmentObject var players: Players
    @AppStorage("coin") var coin:Int = 1000
    var body: some View {
        ZStack{
            Image("homepage")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack{
                TopView().environmentObject(appSettings)
                PlayerCardsView(player: 2, isTop: true).environmentObject(appSettings).environmentObject(cards).environmentObject(players).environmentObject(gameSettings)
                Spacer()
                HStack{
                    PlayerCardsView(player: 3, isTop: false).environmentObject(appSettings).environmentObject(cards).environmentObject(players).environmentObject(gameSettings).padding(.leading, 10)
                    Spacer()
                    MidView().environmentObject(appSettings).environmentObject(cards).environmentObject(players).environmentObject(gameSettings)
                    Spacer()
                    PlayerCardsView(player: 1, isTop: false) .environmentObject(appSettings).environmentObject(cards).environmentObject(players).environmentObject(gameSettings)
                }
                Spacer()
                MyCardsView().environmentObject(appSettings).environmentObject(cards).environmentObject(players).environmentObject(gameSettings)
            }
        }
        .onAppear{
            print("目前輪到\(gameSettings.turn)號玩家")
            
            if gameSettings.turn != 0 {
                print("begin autoplay ")
                autoPlay()
                print("autoplay")
            }
            
        }
        
    }
    
    func autoPlay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            print("輪到\(gameSettings.turn)號玩家")
            AIplayCard()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                print("輪到\(gameSettings.turn)號玩家")
                AIplayCard()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                    print("輪到\(gameSettings.turn)號玩家")
                    AIplayCard()
                }
            }
        }
    }
    
    func AIplayCard(){ // AI出牌
        var turn = gameSettings.turn
        if turn != 0 {
            if players.player[turn].Cards.count != 0 {   //
                for i in 0..<players.player[turn].Cards.count {
                    if(gameSettings.isFirst){
                        print("第一次出牌")
                        if(players.player[turn].Cards[i].numInt == 3 && players.player[turn].Cards[i].suitStr == "clubs"){
                            gameSettings.current_card_type = 1
                            stupid_playCard(index: i)
                            gameSettings.isFirst = false
                            if players.player[turn].Cards.count == 0 {
                                game_over(winner: turn)
                            }
                            break
                        }
                    }
                    else{
                        if gameSettings.currentCard_by_who == turn {
                            print("玩家\(turn)從最小開始出")
                            gameSettings.current_card_type = 1
                            stupid_playCard(index: 0)
                            if players.player[turn].Cards.count == 0 {
                                game_over(winner: turn)
                            }
                            break
                        }
                        else {
                            if gameSettings.current_card_type == 1 {    //只出單張
                                if(players.player[turn].Cards[i].realNum == gameSettings.currentCard[0].realNum && players.player[turn].Cards[i].suitInt > gameSettings.currentCard[0].suitInt){
                                    gameSettings.current_card_type = 1
                                    stupid_playCard(index: i)
                                    if players.player[turn].Cards.count == 0 {
                                        game_over(winner: turn)
                                    }
                                    break
                                }
                                else if(players.player[turn].Cards[i].realNum > gameSettings.currentCard[0].realNum){
                                    gameSettings.current_card_type = 1
                                    stupid_playCard(index: i)
                                    if players.player[turn].Cards.count == 0 {
                                        game_over(winner: turn)
                                    }
                                    break
                                }
                                else {
                                    gameSettings.pass_opacity[turn] = 1.0
                                }
                            }
                            else{   //若不是單張就pass
                                gameSettings.pass_opacity[turn] = 1.0
                            }
                        }
                    }
                }
                turn += 1
                if(turn / 4 > 0){
                    turn = 0
                }
                gameSettings.turn = turn
                
            }
            else {                                      // 牌出完了
                game_over(winner: turn)
            }
        }
    }
    
    func stupid_playCard(index: Int){
        gameSettings.currentCard[0] = players.player[gameSettings.turn].Cards[index]
        players.player[gameSettings.turn].Cards.remove(at: index)
        gameSettings.currentCard_by_who = gameSettings.turn
        setPassOpacity()
        print("目前的牌為\(gameSettings.currentCard[0].numInt)_of_\(gameSettings.currentCard[0].suitStr)")
    }
    
    func game_over(winner: Int) {
        gameSettings.winner = winner
        //appSettings.isGameView = false
        appSettings.isGameOverView = true
        print("gameover, 玩家\(gameSettings.winner)獲勝")
        if gameSettings.winner == 0{
            coin += 1000
        }
        else {
            coin -= 1000
        }
        if coin <= 0{
            gameSettings.isBankrupt = true
        }
    }
    
    func setPassOpacity() {
        for i in 0..<4 {
            gameSettings.pass_opacity[i] = 0.0
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .previewLayout(.fixed(width: 865, height: 450))
    }
}




