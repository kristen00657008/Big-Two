//
//  BankruptView.swift
//  Big Two
//
//  Created by Chase on 2021/3/23.
//

import SwiftUI

struct BankruptView: View {
    @AppStorage("coin") var coin:Int = 10000
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack{
            Text("你破產了")
                .font(Font.system(size: 80))
                .foregroundColor(.gray)
            Text("You are bankrupt")
                .font(Font.system(size: 80))
                .foregroundColor(.gray)
            
            Button(action: {
                coin = 10000
                print("coin")
                presentationMode.wrappedValue.dismiss()
            }){
                Text("乞討點錢繼續玩")
            }
            
        }
        
    }
}

struct BankruptView_Previews: PreviewProvider {
    static var previews: some View {
        BankruptView()
    }
}
