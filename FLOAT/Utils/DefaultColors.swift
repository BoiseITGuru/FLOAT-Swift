//
//  DefaultColors.swift
//  FLOAT
//
//  Created by BoiseITGuru on 8/29/22.
//

import SwiftUI

extension Color {
    init(type: DefaultColors) {
        self.init(hex: type.rawValue)
    }
}

enum DefaultColors: String {
    case backgroundColor = "011E30"
    case accentColor = "38e8c6"
    case textColor = "1e3a8a"
}
