//
//  BaseContentObject.swift
//  Crows
//
//  Created by Yingwei Fan on 4/3/21.
//

import Foundation

class BaseContentObject: NSObject {

  var author: AuthorObject

  var idString: String

  var title: String

  var contentText: String?

  var imageURLs: [String]?

  var youtubeID: String?

  var numberOfLikes: Int

  var numberOfComments: Int

  var status: String {
    let format = NSLocalizedString("BasicContentObject.Status", comment: "")
    return String(format: format, numberOfLikes, numberOfComments)
  }

  init(author: AuthorObject,
       idString: String,
       title: String,
       contentText: String?,
       imageURLs: [String]?,
       youtubeID: String?,
       numberOfLikes: Int = 0,
       numberOfComments: Int = 0) {
    self.author = author
    self.idString = idString
    self.title = title
    self.contentText = contentText
    self.imageURLs = imageURLs
    self.youtubeID = youtubeID
    self.numberOfLikes = numberOfLikes
    self.numberOfComments = numberOfComments
  }

}
