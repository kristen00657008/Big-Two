//
//  PlayerCardsView.swift
//  Big Two
//
//  Created by Chase on 2021/3/16.
//

import SwiftUI

struct MyCardsView: View {
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var gameSettings: GameSettings
    @EnvironmentObject var cards: Cards
    @EnvironmentObject var players: Players
    @State private var degree:Double = 0.0
    @State private var cardWidth:CGFloat = 0.0
    @State private var cardHeight:CGFloat = 0.0
    @State private var spacing:CGFloat = 0.0
    @State private var xOffset:CGFloat = 0.0
    @State private var yOffsets:[CGFloat] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    @State private var pressed:[Bool] = [false, false, false, false,false, false,false, false,false, false,false, false,false]
    @State private var my_card_type = 1
    @State private var choosed_card_num = 0
    @State private var choosed_card_index = [Int]()
    @State private var choosed_card = [Card]()
    @AppStorage("coin") var coin:Int = 1000
    var body: some View {
        ZStack{
            if gameSettings.turn == 0 {
                HStack{
                    Button(action: {
                        playCardBtn()
                    }, label: {
                        Capsule()
                            .fill(Color.black)
                            .overlay(Text("出牌").font(Font.system(size: 15)).foregroundColor(.white))
                            .frame(width: 50, height: 30)
                    })
                    
                    Button(action: {
                        set_yOffset_and_pressed(yOffset: 0.0)
                        gameSettings.pass_opacity[0] = 1.0
                        gameSettings.turn += 1
                        autoPlay()
                    }, label: {
                        Capsule()
                            .fill(Color.black)
                            .overlay(Text("pass").font(Font.system(size: 15)).foregroundColor(.white))
                            .frame(width: 50, height: 30)
                    })
                    
                }.offset(x:UIScreen.main.bounds.width * 0.2 ,y: -UIScreen.main.bounds.height * 0.20)
                
            }
            
            ForEach(0..<players.player[0].Cards.count, id: \.self) { (index) in
                Button(action: {
                    print(index)
                    if pressed[index] {
                        choosed_card_num -= 1
                        choosed_card_index.removeLast()
                        choosed_card.removeLast()
                        self.pressed[index] = false
                        yOffsets[index] += 10
                    }
                    else{
                        choosed_card_index.append(index)
                        choosed_card.append(players.player[0].Cards[index])
                        choosed_card_num += 1
                        self.pressed[index] = true
                        yOffsets[index] += -10
                    }
                    
                }, label: {
                    Image("\(players.player[0].Cards[index].numInt)_of_\(players.player[0].Cards[index].suitStr)")
                        .resizable()
                })
                .frame(width: self.cardWidth, height: self.cardHeight)
                .offset(x: CGFloat(CGFloat(index) * spacing) + xOffset, y: yOffsets[index])
                .rotationEffect(.degrees(Double(self.degree)))
            }
            Capsule()
                .fill(Color.black)
                .overlay(Text("PASS").font(Font.system(size: 35)).opacity(gameSettings.pass_opacity[0]).foregroundColor(.white))
                .opacity(gameSettings.pass_opacity[0])
                .frame(width: 100, height: 50)
            Text(gameSettings.card_message[0])
                .opacity(gameSettings.card_message_opacity[0])
                .offset(x: -200, y: -80)
                .foregroundColor(.orange)
                .font(Font.system(size: 55, weight: .bold))
        }
        .onAppear{
            degree = 0.0
            cardWidth = UIScreen.main.bounds.width * 0.1
            cardHeight = UIScreen.main.bounds.height * 0.23
            spacing = UIScreen.main.bounds.width * 0.04
            xOffset =  -(UIScreen.main.bounds.width * 0.25)
            pressed = [false, false, false, false,false, false,false, false,false, false,false, false,false]
            my_card_type = 1
            choosed_card_num = 0
            choosed_card_index = []
            choosed_card = []
            set_yOffset_and_pressed(yOffset: 0)
            setPassOpacity()
        }
        
    }
    
    func autoPlay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            print("輪到\(gameSettings.turn)號玩家")
            print("場上的牌為\(gameSettings.currentCard_by_who)號玩家出的")
            AIplayCard()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                print("輪到\(gameSettings.turn)號玩家")
                print("場上的牌為\(gameSettings.currentCard_by_who)號玩家出的")
                AIplayCard()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                    print("輪到\(gameSettings.turn)號玩家")
                    print("場上的牌為\(gameSettings.currentCard_by_who)號玩家出的")
                    AIplayCard()
                    if gameSettings.currentCard_by_who == 0 {
                        gameSettings.current_card_type = 0
                    }
                }
            }
        }
    }
    func AIplayCard(){ // AI出牌
        for i in 0..<4 {
            gameSettings.card_message[i] = ""
            gameSettings.card_message_opacity[i] = 0.0
        }
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
    
    func smart_playCard() {
        if gameSettings.current_card_type == 1 {
            gameSettings.currentCard[0] = players.player[gameSettings.turn].Cards[choosed_card_index[0]]
            players.player[gameSettings.turn].Cards.remove(at: choosed_card_index[0])
        }
        else if gameSettings.current_card_type == 2 {
            gameSettings.currentCard[0] = players.player[gameSettings.turn].Cards[choosed_card_index[0]]
            gameSettings.currentCard[1] = players.player[gameSettings.turn].Cards[choosed_card_index[1]]
            players.player[gameSettings.turn].Cards.remove(at: choosed_card_index[1])
            players.player[gameSettings.turn].Cards.remove(at: choosed_card_index[0])
        }
        else if gameSettings.current_card_type == 3 || gameSettings.current_card_type == 4 || gameSettings.current_card_type == 5 || gameSettings.current_card_type == 6 {
            for i in 0..<5 {
                gameSettings.currentCard[i] = players.player[gameSettings.turn].Cards[choosed_card_index[i]]
            }
            players.player[gameSettings.turn].Cards.remove(at: choosed_card_index[4])
            players.player[gameSettings.turn].Cards.remove(at: choosed_card_index[3])
            players.player[gameSettings.turn].Cards.remove(at: choosed_card_index[2])
            players.player[gameSettings.turn].Cards.remove(at: choosed_card_index[1])
            players.player[gameSettings.turn].Cards.remove(at: choosed_card_index[0])
        }
        else {
            
        }
        gameSettings.currentCard_by_who = gameSettings.turn
        setPassOpacity()
    }
    
    func set_yOffset_and_pressed(yOffset: CGFloat) {
        for i in 0..<13 {
            self.yOffsets[i] = yOffset
            self.pressed[i] = false
        }
    }
    
    func game_over(winner: Int) {
        gameSettings.winner = winner
        //appSettings.isGameView = false
        appSettings.isGameOverView = true
        print("gameover, 玩家\(gameSettings.winner)獲勝")
        print("isGameView:\(appSettings.isGameView)")
        print("isGameOverView:\(appSettings.isGameOverView)")
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
    
    func playCardBtn() {
        print("所選的牌的位置：\(choosed_card_index)")
        choosed_card_index.sort()
        for i in 0..<4 {
            gameSettings.card_message[i] = ""
            gameSettings.card_message_opacity[i] = 0.0
        }
        if choosed_card_num <= 0 {   //沒有選牌
            print("沒有選牌")
        }
        else if choosed_card_num >= 6 {  //選超過5張
            print("選超過5張")
        }
        else {
            print("選了\(choosed_card_num)張牌")
            if judgeCard() {    //出得牌合法
                print("合法")
                if gameSettings.isFirst {   //第一次出牌
                    print("第一次出牌")
                    
                    if choosed_card_index[0] == 0 {       //第一張選了梅花三
                        gameSettings.current_card_type = my_card_type
                        smart_playCard()
                        gameSettings.isFirst = false
                        gameSettings.turn += 1
                        autoPlay()
                    }
                    else {                      //第一張選的不是梅花三
                        gameSettings.showAlert[0] = true
                        print("警告\(gameSettings.showAlert[0])")
                    }
                }
                else {      //不是第一次出牌
                    print("不是第一次出牌")
                    if gameSettings.currentCard_by_who == 0 {   // 上一張牌是自己出的
                        print("上一張牌是自己出的")
                        gameSettings.current_card_type = my_card_type
                        smart_playCard()
                        if players.player[0].Cards.count <= 0 {     //我沒牌了
                            game_over(winner: 0)
                        }
                        else {
                            gameSettings.turn += 1
                            autoPlay()
                        }
                    }
                    else {      //上一張牌是別人出的
                        print("上一張牌是別人出的")
                        if gameSettings.current_card_type == self.my_card_type && self.my_card_type == 1 {       //出單張
                            print("出單張")
                            if (players.player[0].Cards[choosed_card_index[0]].realNum == gameSettings.currentCard[0].realNum && players.player[0].Cards[choosed_card_index[0]].suitInt > gameSettings.currentCard[0].suitInt) || (players.player[0].Cards[choosed_card_index[0]].realNum > gameSettings.currentCard[0].realNum) {   //出得牌比上一張大
                                smart_playCard()
                                if players.player[0].Cards.count <= 0 {     //我沒牌了
                                    game_over(winner: 0)
                                }
                                else {
                                    gameSettings.turn += 1
                                    autoPlay()
                                }
                            }
                            else {                              //出得牌比上一張小
                                print("目前所選的牌為第\(choosed_card_index[0])幾個")
                                print("場上的牌為\(gameSettings.currentCard[0].realNum)_of_\(gameSettings.currentCard[0].suitInt)")
                                print("要出的牌為\(players.player[0].Cards[choosed_card_index[0]].realNum)_of_\(players.player[0].Cards[choosed_card_index[0]].suitInt)")
                                gameSettings.showAlert[1] = true
                            }
                        }
                        else if gameSettings.current_card_type == self.my_card_type && self.my_card_type == 2{
                            print("出呸")
                            if (players.player[0].Cards[choosed_card_index[0]].realNum == gameSettings.currentCard[0].realNum && players.player[0].Cards[choosed_card_index[0]].suitInt > gameSettings.currentCard[0].suitInt) || (players.player[0].Cards[choosed_card_index[0]].realNum > gameSettings.currentCard[0].realNum) {   //出得牌比上一張大
                                smart_playCard()
                                if players.player[0].Cards.count <= 0 {     //我沒牌了
                                    game_over(winner: 0)
                                }
                                else {
                                    gameSettings.turn += 1
                                    autoPlay()
                                }
                            }
                            else {
                                print("目前所選的牌為第\(choosed_card_index[0])幾個")
                                print("場上的牌為\(gameSettings.currentCard[0].realNum)_of_\(gameSettings.currentCard[0].suitInt)")
                                print("要出的牌為\(players.player[0].Cards[choosed_card_index[0]].realNum)_of_\(players.player[0].Cards[choosed_card_index[0]].suitInt)")
                                gameSettings.showAlert[1] = true
                            }
                        }
                    }
                }
            }
            else {
                gameSettings.showAlert[2] = true
            }
            
        }
        choosed_card_index.removeAll()
        choosed_card_num = 0
        choosed_card.removeAll()
        set_yOffset_and_pressed(yOffset: 0.0)
    }
    
    func judgeCard() -> Bool {
        if choosed_card_num == 1 {
            self.my_card_type = 1
            return true
        }
        else if choosed_card_num == 2 {
            if choosed_card[0].realNum == choosed_card[1].realNum {
                self.my_card_type = 2
                if choosed_card[0].numInt == 1 {
                    gameSettings.card_message[0] =  "A呸!"
                }
                else if choosed_card[0].numInt == 2 {
                    gameSettings.card_message[0] = "老二呸!"
                }else{
                    gameSettings.card_message[0] = String(choosed_card[0].numInt) + "呸!"
                }
                gameSettings.card_message_opacity[0] = 1.0
                return true
            }
        }
        else if choosed_card_num == 3 {
            return false
        }
        else if choosed_card_num == 4 {
            return false
        }
        else if choosed_card_num == 5 {
            if choosed_card[0].realNum == choosed_card[1].realNum && choosed_card[1].realNum == choosed_card[2].realNum{    //前三張一樣
                if choosed_card[2].realNum == choosed_card[3].realNum{  //第四張與前三張一樣
                    self.my_card_type = 5   //鐵支
                    gameSettings.card_message[0] = "鐵支!!!"
                    gameSettings.card_message_opacity[0] = 1.0
                    return true
                }
                else if choosed_card[3].realNum == choosed_card[4].realNum {    //第四第五張一樣
                    self.my_card_type = 3   //葫蘆
                    gameSettings.card_message[0] = "葫蘆!"
                    gameSettings.card_message_opacity[0] = 1.0
                    return true
                }
            }
            //  判斷順子&同花順
            if choosed_card[0].numInt == choosed_card[1].numInt-1 {
                if choosed_card[1].numInt == choosed_card[2].numInt-1 {
                    if choosed_card[2].numInt == choosed_card[3].numInt-1 {
                        if choosed_card[3].numInt == choosed_card[4].numInt-1 {
                            if choosed_card[0].suitInt == choosed_card[1].suitInt && choosed_card[1].suitInt == choosed_card[2].suitInt && choosed_card[2].suitInt == choosed_card[3].suitInt && choosed_card[3].suitInt == choosed_card[4].suitInt{
                                self.my_card_type = 6   //同花順
                                gameSettings.card_message[0] = "同花順!!!"
                                gameSettings.card_message_opacity[0] = 1.0
                                return true
                            }
                            else {
                                self.my_card_type = 4   //順子
                                gameSettings.card_message[0] = "順子!"
                                gameSettings.card_message_opacity[0] = 1.0
                                return true
                            }
                        }
                    }
                }
            }
            return false
        }
        return false
    }
    
}

