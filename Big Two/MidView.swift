//
//  MidView.swift
//  Big Two
//
//  Created by Chase on 2021/3/16.
//

import SwiftUI

struct MidView: View {
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var gameSettings: GameSettings
    @EnvironmentObject var cards: Cards
    @EnvironmentObject var players: Players
    var body: some View {
        if gameSettings.current_card_type == 0{ //空牌
            Image("0_of_back")
                .resizable()
                .frame(width: UIScreen.main.bounds.width * 0.13, height: UIScreen.main.bounds.height * 0.3)
        }
        else if gameSettings.current_card_type == 1{    //  單張
            Image("\(gameSettings.currentCard[0].numInt)_of_\(gameSettings.currentCard[0].suitStr)")
                .resizable()
                .frame(width: UIScreen.main.bounds.width * 0.13, height: UIScreen.main.bounds.height * 0.3)
        }
        else if gameSettings.current_card_type == 2 {   //呸
            HStack{
                Image("\(gameSettings.currentCard[0].numInt)_of_\(gameSettings.currentCard[0].suitStr)")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.13, height: UIScreen.main.bounds.height * 0.3)
                Image("\(gameSettings.currentCard[1].numInt)_of_\(gameSettings.currentCard[1].suitStr)")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.13, height: UIScreen.main.bounds.height * 0.3)
            }
        }
        else if gameSettings.current_card_type == 3 ||  gameSettings.current_card_type == 4 || gameSettings.current_card_type == 5 || gameSettings.current_card_type == 6{   //葫蘆 and 順子 and 鐵支 and 同花順
            HStack{
                Image("\(gameSettings.currentCard[0].numInt)_of_\(gameSettings.currentCard[0].suitStr)")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.13, height: UIScreen.main.bounds.height * 0.3)
                Image("\(gameSettings.currentCard[1].numInt)_of_\(gameSettings.currentCard[1].suitStr)")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.13, height: UIScreen.main.bounds.height * 0.3)
                Image("\(gameSettings.currentCard[2].numInt)_of_\(gameSettings.currentCard[2].suitStr)")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.13, height: UIScreen.main.bounds.height * 0.3)
                Image("\(gameSettings.currentCard[3].numInt)_of_\(gameSettings.currentCard[3].suitStr)")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.13, height: UIScreen.main.bounds.height * 0.3)
                Image("\(gameSettings.currentCard[4].numInt)_of_\(gameSettings.currentCard[4].suitStr)")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.13, height: UIScreen.main.bounds.height * 0.3)
            }
        }
    }
}

struct MidView_Previews: PreviewProvider {
    static var previews: some View {
        MidView()
    }
}
