//
//  Crop.swift
//  unistay
//
//  Created by Gustavo Amaro on 02/09/23.
//

import SwiftUI

// MARK: - Crop Config

enum Crop: Equatable {
    case circle
    
    func name() -> String {
        switch self {
        case .circle: return "Circle"
            
        }
    }
    
    func size() -> CGSize {
        switch self {
        case .circle: return CGSize(width: 300, height: 300)
        }
    }
}
