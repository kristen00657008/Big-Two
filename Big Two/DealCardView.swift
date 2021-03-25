//
//  DealAnimationView.swift
//  PickRed
//
//  Created by Chase on 2021/3/18.
//

import SwiftUI

struct DealCardView: View {
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var gameSettings: GameSettings
    @State private var currentDate = Date()
    @State private var timer = Timer.publish(every: 0.125, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack(alignment: .center){
            Image("homepage")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    ZStack{
                        ForEach(0..<52, id: \.self){ index in
                            if(index%4==0){
                                if(gameSettings.showCard[index]){
                                    Image("0_of_back")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.08, height: UIScreen.main.bounds.height * 0.2)
                                        .transition(.bottomTransition)
                                }
                                else{
                                    Image("0_of_back")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.08, height: UIScreen.main.bounds.height * 0.2)
                                        .hidden()
                                }
                            }
                            else if(index%4==1){
                                if(gameSettings.showCard[index]){
                                    Image("0_of_back")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.08, height: UIScreen.main.bounds.height * 0.2)
                                        .transition(.leftTransition)
                                }
                                else{
                                    Image("0_of_back")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.08, height: UIScreen.main.bounds.height * 0.2)
                                        .hidden()
                                }
                            }
                            else if(index%4==2){
                                if(gameSettings.showCard[index]){
                                    Image("0_of_back")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.08, height: UIScreen.main.bounds.height * 0.2)
                                        .transition(.topTransition)
                                }
                                else{
                                    Image("0_of_back")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.08, height: UIScreen.main.bounds.height * 0.2)
                                        .hidden()
                                }
                            }
                            else if(index%4==3){
                                if(gameSettings.showCard[index]){
                                    Image("0_of_back")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.08, height: UIScreen.main.bounds.height * 0.2)
                                        .transition(.rightTransition)
                                }
                                else{
                                    Image("0_of_back")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.08, height: UIScreen.main.bounds.height * 0.2)
                                        .hidden()
                                }
                            }
                        }
                    }
                    Spacer()
                }
                Spacer()
            }
            
            Button(action: {
                endDeal()
            }){
                Text("Skip")
                    .font(Font.system(size: 50))
            }.offset(x:320, y:180)
            
        }
        .onReceive(timer){ input in
            withAnimation{
                let timeInterval = input.timeIntervalSince1970 - currentDate.timeIntervalSince1970
                gameSettings.showCard[Int((timeInterval)*8) - 1] = false
                print(Int((timeInterval)*8) - 1)
                if(Int((timeInterval)*8) - 1 >= 50){
                    endDeal()
                }
            }
        }
    }
    
    func endDeal() {
        timer.upstream.connect().cancel()
        appSettings.isDealCardView = false
        appSettings.isGameView = true
    }
}

extension AnyTransition{
    static var rightTransition: AnyTransition{
        let insertion = AnyTransition.offset(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2)
        let removal = AnyTransition.offset(x: UIScreen.main.bounds.size.width/2-100, y: 0)
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    static var leftTransition: AnyTransition{
        let insertion = AnyTransition.offset(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2)
        let removal = AnyTransition.offset(x: -UIScreen.main.bounds.size.width/2+100, y: 0)
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    static var topTransition: AnyTransition{
        let insertion = AnyTransition.offset(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2)
        let removal = AnyTransition.offset(x: 0, y: -UIScreen.main.bounds.size.height/2+50)
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    static var bottomTransition: AnyTransition{
        let insertion = AnyTransition.offset(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2)
        let removal = AnyTransition.offset(x: 0, y: UIScreen.main.bounds.size.height/2-50)
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
}

