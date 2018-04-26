//
//  ProfileUser.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 4/11/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

class ProfileUser {
    
    var username : String?
    var description : String?
    var avatar : UIImage?
    
    var usernameWasEdited : Bool = false
    var descriptionWasEdited : Bool = false
    var avatarWasEdited : Bool = false
    
    init() {
    }
    
    init(username : String?, description : String?, avatar : UIImage?) {
        self.username = username
        self.description = description
        self.avatar = avatar
    }
    
}
