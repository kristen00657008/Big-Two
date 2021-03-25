//
//  PlayerCards.swift
//  Big Two
//
//  Created by Chase on 2021/3/16.
//

import Foundation

struct Player{
    var Cards: [Card]
}

class Players: ObservableObject {
    @Published var player = [Player(Cards: [Card]()), Player(Cards: [Card]()), Player(Cards: [Card]()), Player(Cards: [Card]())]
}
