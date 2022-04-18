//
//  ContentCommentObject.swift
//  Crows
//
//  Created by Yingwei Fan on 5/16/21.
//

import UIKit

class ContentCommentObject: NSObject {

  let idString: String

  let author: AuthorObject

  let text: String

  var likeCount: Int

  init(idString: String, author: AuthorObject, text: String, likeCount: Int) {
    self.idString = idString
    self.author = author
    self.text = text
    self.likeCount = likeCount
  }

}
