//
//  Messsage.swift
//  gameofchats
//
//  Created by Umoru Joseph on 11/29/16.
//  Copyright © 2016 Umoru Joseph. All rights reserved.
//

import UIKit
import Firebase

class Messsage: NSObject {
    var fromId: String?
    var text: String?
    var timeStamp: NSNumber?
    var toId: String?
    
    func chatPartnerId() -> String? {
        if fromId == FIRAuth.auth()?.currentUser?.uid {
            return toId
        }else{
            return fromId
        }
    }
}
