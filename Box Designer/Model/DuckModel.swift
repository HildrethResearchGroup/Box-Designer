//
//  DuckModel.swift
//  Box Designer
//
//  Created by Owen Hildreth on 5/22/20.
//  Copyright © 2020 Hildreth Research Group. All rights reserved.
//

import Foundation

enum DuckState {
    case safe
    case dead
    case inDanger
}

struct DuckModel {
    var delegate: DuckModelDelegate? = nil
    var duckState = DuckState.inDanger {
        didSet {
            if duckState != oldValue {
                delegate?.duckModelStateDidChange(duckState)
            }
        }
    }
}

protocol DuckModelDelegate {
    
    /**
    Function that will be called if a delegate exists to inform the delegate that the state did change.
         
    - Parameters:
        - duckState:  DuckState Enum that has the state of the duck
     
     # Example #
     ````
      delegate?.duckModelStateDidChange(DuckState.safe)
     ````
    */
    func duckModelStateDidChange(_ duckState: DuckState)
}
