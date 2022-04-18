//
//  ContentDetailsObject.swift
//  Crows
//
//  Created by Yingwei Fan on 5/15/21.
//

import UIKit

class ContentDetailsObject: NSObject {

  let idString: String

  let title: String

  let text: String

  let postID: String

  let author: AuthorObject

  let imageURLs: [String]?

  let youtubeID: String?

  let createdTime: String

  var likeCount: Int

  var commentCount: Int

  init(idString: String,
       author: AuthorObject,
       title: String,
       text: String,
       postID: String,
       createdTime: String,
       likeCount: Int,
       commentCount: Int,
       imageURLs: [String]? = nil,
       youtubeID: String? = nil) {
    self.idString = idString
    self.author = author
    self.title = title
    self.text = text
    self.postID = postID
    self.createdTime = createdTime
    self.likeCount = likeCount
    self.commentCount = commentCount
    self.imageURLs = imageURLs
    self.youtubeID = youtubeID
    super.init()
  }

}
