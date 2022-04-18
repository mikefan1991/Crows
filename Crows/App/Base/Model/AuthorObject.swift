//
//  AuthorObject.swift
//  Crows
//
//  Created by Yingwei Fan on 4/3/21.
//

import Foundation

struct AuthorObject: Codable {

  let idString: String

  var username: String

  var nickname: String?

  var introduction: String?

  var avatarURL: String?

  init(idString: String, username: String, nickname: String? = nil, introduction: String? = nil, avatarURL: String? = nil) {
    self.idString = idString
    self.username = username
    self.nickname = nickname
    self.introduction = introduction
    self.avatarURL = avatarURL
  }

}
