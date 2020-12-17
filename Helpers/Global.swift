//
//  Global.swift
//  FIBRA
//
//  Created by Irfan Malik on 16/12/2020.
//

import Foundation
import UIKit

class Global {
    class var shared : Global {
        
        struct Static {
            static let instance : Global = Global()
        }
        return Static.instance
        
    }
    var profileUrl = ""
}
