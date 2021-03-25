//
//  Cards.swift
//  BIg Two
//
//  Created by Chase on 2021/3/16.
//

import Foundation

struct Card {
    var numInt: Int
    var suitStr: String
    var suitInt: Int
    var realNum: Int
}

class Cards: ObservableObject {
    @Published var cards = [Card]()
}

