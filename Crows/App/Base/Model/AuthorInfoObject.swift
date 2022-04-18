//
//  AuthorInfoObject.swift
//  Crows
//
//  Created by Yingwei Fan on 4/3/21.
//

import Foundation

class AuthorObject: NSObject {

  let id: String

  var username: String

  var nickname: String?

  var introduction: String?

  var avatarURL: String?

  init(idString: String, username: String, nickname: String? = nil, introduction: String? = nil, avatarURL: String? = nil) {
    id = idString
    self.username = username
    self.nickname = nickname
    self.introduction = introduction
    self.avatarURL = avatarURL
  }

}
