//
//  JRUser.swift
//  Journey
//
//  Created by Aaron Cabreja on 2/15/19.
//  Copyright © 2019 Aaron Cabreja. All rights reserved.
//

import Foundation

struct JRUser {
  let username: String?
  let imageURL: String?
  
  init(dict: [String: Any]) {
    self.username = dict["username"] as? String ?? "no username"
    self.imageURL = dict["imageURL"] as? String ?? "no imageURL"
  }
}
