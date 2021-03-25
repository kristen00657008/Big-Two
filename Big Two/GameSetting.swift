//
//  GameSetting.swift
//  Big Two
//
//  Created by Chase on 2021/3/16.
//

import Foundation
import SwiftUI

class GameSettings: ObservableObject {
    @Published var turn = 0
    @Published var currentCard = [Card(numInt: 0, suitStr: "back", suitInt: 0, realNum: 0), Card(numInt: 0, suitStr: "back", suitInt: 0, realNum: 0), Card(numInt: 0, suitStr: "back", suitInt: 0, realNum: 0), Card(numInt: 0, suitStr: "back", suitInt: 0, realNum: 0),Card(numInt: 0, suitStr: "back", suitInt: 0, realNum: 0)]
    @Published var isFirst = true
    @Published var showAlert = [false, false, false]
    @Published var currentCard_by_who = 0
    @Published var isOver = false
    @Published var winner = 0
    @Published var pass_opacity = [0.0, 0.0, 0.0, 0.0]
    @Published var showCard = [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true,  true,true, true, true,true, true, true, true, true, true, true, true, true, true, true, true,true,true, true, true,true,true, true, true,true,true,  true, true, true, true, true, true,]
    @Published var current_card_type = 1 //1:單張 2:呸 3:葫蘆 4: 順子 5: 鐵支 6:同花順
    @Published var isBankrupt = false
    @Published var card_message = ["", "", "", ""]
    @Published var card_message_opacity: [Double] = [0.0, 0.0, 0.0, 0.0]
}
