//
//  ContentView.swift
//  BIg Two
//
//  Created by User16 on 2021/3/10.
//

import SwiftUI
import AVFoundation

struct HomePageView: View {
    @StateObject var appSettings = AppSettings()
    @StateObject var gameSettings = GameSettings()
    @StateObject var cards = Cards()
    @StateObject var players = Players()
    @State var looper: AVPlayerLooper?
    @AppStorage("coin") var coin:Int = 1000
    var body: some View {
        ZStack{
            if appSettings.isHomePageView {
                
                Image("homepage")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                VStack(alignment: .center){
                    Text("BIG-TWO")
                        .foregroundColor(.white)
                        .font(.custom("HanyiSentyChalkOriginal", size: 100))
                    Text("大老二")
                        .foregroundColor(.white)
                        .font(.custom("HanyiSentyChalkOriginal", size: 80))
                    HStack{
                        Button(action: {
                            print("進入大廳")
                            appSettings.isHomePageView = false
                            appSettings.isLobbyView = true
                        }, label: {
                            Text("進入大廳")
                                .frame(width: 160, height: 80)
                                .font(Font.system(size: 30))
                                .foregroundColor(.white)
                        })
                        .background(Color.orange)
                        .cornerRadius(5.0)
                        .padding(.trailing, 300)
                        .padding(.leading, 80)
                        
                        Link("規則說明",
                             destination: URL(string: "https://zh.wikipedia.org/wiki/%E9%8B%A4%E5%A4%A7%E5%BC%9F")!)
                            .frame(width: 160, height: 80)
                            .font(Font.system(size: 30))
                            .foregroundColor(.white)
                            .background(Color.orange)
                            .cornerRadius(5.0)
                            .padding(.trailing, 80)
                    }
                }.onAppear{
                    print("Homepage")
                }
                
            }
            else if appSettings.isMenuView {
                ZStack{
                    GameView().environmentObject(appSettings).environmentObject(cards).environmentObject(players).environmentObject(gameSettings)
                    MenuView().environmentObject(appSettings).environmentObject(cards).environmentObject(players).environmentObject(gameSettings).frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.5)
                }
                
            }
            else if appSettings.isLobbyView {
                LobbyView().environmentObject(appSettings).environmentObject(cards).environmentObject(players).environmentObject(gameSettings)
            }
            else if appSettings.isDealCardView {
                DealCardView().environmentObject(appSettings).environmentObject(gameSettings)
            }
            else if appSettings.isGameView {
                ZStack{
                    GameView().environmentObject(appSettings).environmentObject(cards).environmentObject(players).environmentObject(gameSettings)
                    EmptyView()
                        .alert(isPresented: $gameSettings.showAlert[0]) {
                            Alert(title: Text("首張需出梅花三"), message: Text("The first card should be clubs 3"), dismissButton: .default(Text("OK")))
                        }
                    EmptyView().alert(isPresented: $gameSettings.showAlert[1]) {
                        Alert(title: Text("需大於上一張的牌"), message: Text("Need to be greater than the previous card"), dismissButton: .default(Text("OK")))
                    }
                    EmptyView().alert(isPresented: $gameSettings.showAlert[2]) {
                        Alert(title: Text("不合法出牌"), message: Text("Illegal Card"), dismissButton: .default(Text("OK")))
                    }
                    EmptyView().fullScreenCover(isPresented: $appSettings.isGameOverView){  GameOverView().environmentObject(appSettings).environmentObject(cards).environmentObject(players).environmentObject(gameSettings)
                    }
                }
            }
        }
        .onAppear{
            let fileUrl = Bundle.main.url(forResource: "music", withExtension: "mp3")!
            let item = AVPlayerItem(url: fileUrl)
            self.looper = AVPlayerLooper(player: appSettings.player, templateItem: item)
            appSettings.player.play()
        }
    }
}
