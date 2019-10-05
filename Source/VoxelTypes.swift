//
//  VoxelTypes.swift
//  VoxelKit
//
//  Created by Anton Heestand on 2019-10-02.
//  Copyright © 2019 Hexagons. All rights reserved.
//

import Foundation

public enum Axis {
    case x
    case y
    case z
    var index: Int {
        switch self {
        case .x: return 0
        case .y: return 1
        case .z: return 2
        }
    }
}
