//
//  PlayerCardsView.swift
//  Big Two
//
//  Created by Chase on 2021/3/16.
//

import SwiftUI

struct PlayerCardsView: View {
    var player: Int
    var isTop: Bool
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var gameSettings: GameSettings
    @EnvironmentObject var cards: Cards
    @EnvironmentObject var players: Players
    @State private var degree:Double = 0.0
    @State private var cardWidth:CGFloat = 0.0
    @State private var cardHeight:CGFloat = 0.0
    @State private var spacing:CGFloat = 0.0
    @State private var xOffset:CGFloat = 0.0
    var body: some View {
        ZStack{
            ForEach(0..<players.player[player].Cards.count, id: \.self) { (index) in
                Button(action: {
                }, label: {
                    //Image("\(players.player[player].Cards[index].numInt)_of_\(players.player[player].Cards[index].suitStr)")
                    //   .resizable()
                    Image("0_of_back")
                        .resizable()
                })
                .frame(width: self.cardWidth, height: self.cardHeight)
                .offset(x: CGFloat(CGFloat(index) * spacing) + xOffset)
                .rotationEffect(.degrees(Double(self.degree)))
                .disabled(true)
            }
            Capsule()
                .fill(Color.black)
                .overlay(Text("PASS").font(Font.system(size: 35)).opacity(gameSettings.pass_opacity[player]).foregroundColor(.white))
                .opacity(gameSettings.pass_opacity[player])
                .frame(width: 100, height: 50)
        }
        .onAppear{
            if isTop {
                self.degree = 0.0
                self.cardWidth = UIScreen.main.bounds.width * 0.08
                self.cardHeight = UIScreen.main.bounds.height * 0.2
                self.spacing = UIScreen.main.bounds.width * 0.03
                self.xOffset =  -(UIScreen.main.bounds.width * 0.15)
            }
            else {
                self.degree = 90.0
                self.cardWidth = UIScreen.main.bounds.height * 0.16
                self.cardHeight = UIScreen.main.bounds.width * 0.12
                self.spacing = UIScreen.main.bounds.height * 0.04
                self.xOffset =  -(UIScreen.main.bounds.height * 0.25)
            }
        }
    }
}

struct PlayerCardsView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerCardsView(player: 0, isTop: true)
    }
}
