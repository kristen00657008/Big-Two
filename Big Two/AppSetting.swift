//
//  GameSetting.swift
//  BIg Two
//
//  Created by Chase on 2021/3/16.
//

import Foundation
import SwiftUI
import AVFoundation

class AppSettings: ObservableObject {
    @Published var isGameView = false
    @Published var isHomePageView = true
    @Published var isLobbyView = false
    @Published var isGameOverView = false
    @Published var isDealCardView = false
    @Published var isMenuView = false
    @Published var volume = 1.0
    @Published var player = AVQueuePlayer()
}
