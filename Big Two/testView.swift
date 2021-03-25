//
//  testView.swift
//  Big Two
//
//  Created by Chase on 2021/3/16.
//

import SwiftUI

struct testView: View {
    var body: some View {
        VStack{
            TopView()
        }
    }
}

struct testView_Previews: PreviewProvider {
    static var previews: some View {
        testView()
            .previewLayout(.fixed(width: 865, height: 375))
    }
}
