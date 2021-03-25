//
//  TopView.swift
//  Big Two
//
//  Created by Chase on 2021/3/16.
//

import SwiftUI

struct TopView: View {
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var gameSettings: GameSettings
    @AppStorage("coin") var coin:Int = 1000
    
    var body: some View {
        HStack{
            Button(action: {
                appSettings.isMenuView = true
            }){
                Image("settings")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            Spacer()
            Text("$\(coin)")
                .border(Color.black)
                .foregroundColor(Color.white)
        }
    }
    
    func settingBtn() {
        appSettings.isMenuView = true
        
    }
    
}

struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        TopView()
    }
}
