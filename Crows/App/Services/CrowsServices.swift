//
//  CrowsServices.swift
//  Crows
//
//  Created by Yingwei Fan on 4/29/21.
//

import UIKit
import Alamofire
import KeychainSwift
import SwiftyJSON

class CrowsServices: NSObject {

  static let shared = CrowsServices(baseURLString: "https://kuroz.jp")

  private let baseURLString: String

  private init(baseURLString: String) {
    self.baseURLString = baseURLString
  }

  // MARK: - Public

  func login(identification: String, password: String, completionHandler: @escaping (Bool, Error?) -> Void) {
    let urlString = baseURLString + "/api/token"
    let parameters: [String : Any] = ["identification": identification, "password": password]
    AF.request(urlString, method: .post, parameters: parameters).responseJSON { response in
      switch response.result {
      case .success(let data):
        let json = JSON(data)
        guard let token = json["token"].string else {
          let detail = NSLocalizedString("SignIn.LoginFailureError", comment: "")
          let error = NSError(domain: "Login", code: 401, userInfo: [NSLocalizedDescriptionKey: detail])
          completionHandler(false, error)
          return
        }
        let userDefaults = CrowsUserDefaults.standard
        userDefaults.setValue(token, forKey: CrowsUserDefaults.loginTokenKey)
        let keychain = KeychainSwift()
        let userID = String(json["userId"].intValue)
        keychain.set(password, forKey: userID)
        self.fetchUserInfo(idOrUsername: userID) { authorObject, error in
          guard let authorObject = authorObject else {
            debugPrint("Author object is nil")
            completionHandler(true, nil)
            return
          }
          do {
            let encoder = JSONEncoder()
            let authorData = try encoder.encode(authorObject)
            userDefaults.set(authorData, forKey: CrowsUserDefaults.loginUserKey)
          } catch {
            debugPrint("Unable to encode author object.")
          }
          completionHandler(true, nil)
        }
      case .failure(let error):
        completionHandler(false, error)
      }
    }
  }

  func checkRegisterEmailConflict(email: String, completionHandler: @escaping (Bool, Error?) -> Void) {
    let urlString = baseURLString + "/api/users"
    let attributes = ["email": email]
    let parameters = ["data": ["type": "users", "attributes": attributes, "ischeckemail": true]]
    AF.request(urlString, method: .post, parameters: parameters).responseJSON { response in
      switch response.result {
      case .success(let data):
        let json = JSON(data)
        if let errorJson = json["errors"].array?.first {
          let code = errorJson["status"].intValue
          let detail = errorJson["detail"].stringValue
          let error = NSError(domain: "Register", code: code, userInfo: [NSLocalizedDescriptionKey: detail])
          completionHandler(false, error)
          return
        }
        completionHandler(true, nil)
      case .failure(let error):
        completionHandler(false, error)
      }
    }
  }

  func registerNewUser(username: String, email: String, password: String, completionHandler: @escaping (Bool, Error?) -> Void ) {
    let urlString = baseURLString + "/api/users"
    let attributes = ["username": username, "email": email, "password": password]
    let parameters = ["data": ["type": "users", "attributes": attributes, "ischeckemail": false]]
    AF.request(urlString, method: .post, parameters: parameters).responseJSON { response in
      switch response.result {
      case .success(let data):
        let json = JSON(data)
        if let errorJson = json["errors"].array?.first {
          let code = errorJson["status"].intValue
          let detail = errorJson["detail"].stringValue
          let error = NSError(domain: "Register", code: code, userInfo: [NSLocalizedDescriptionKey: detail])
          completionHandler(false, error)
          return
        }
        self.login(identification: username, password: password) { success, error in
          if !success {
            debugPrint(error?.localizedDescription ?? "Login in register failed.")
          }
          completionHandler(true, nil)
        }
      case .failure(let error):
        completionHandler(false, error)
      }
    }
  }

  func recoverPassword(email: String, completionHandler: @escaping (Bool, Error?) -> Void) {
    let urlString = baseURLString + "/api/forgot"
    let parameters = ["email": email]
    AF.request(urlString, method: .post, parameters: parameters).responseJSON { response in
      switch response.result {
      case .success(let data):
        let json = JSON(data)
        if let errorJson = json["errors"].array?.first {
          let code = errorJson["status"].intValue
          var detail = errorJson["detail"].stringValue
          if detail.isEmpty && code == 404 {
            detail = NSLocalizedString("SignIn.EmailNotRegistered", comment: "")
          }
          let error = NSError(domain: "Register", code: code, userInfo: [NSLocalizedDescriptionKey: detail])
          completionHandler(false, error)
          return
        }

        completionHandler(true, nil)
      case .failure(let error):
        completionHandler(false, error)
      }
    }
  }

  func fetchUserInfo(idOrUsername: String, completionHandler: @escaping (AuthorObject?, AFError?) -> Void) {
    let urlString = baseURLString + "/api/users/" + idOrUsername
    AF.request(urlString).responseJSON { response in
      switch response.result {
      case .success(let data):
        let json = JSON(data)
        let idString = json["data"]["id"].stringValue
        let username = json["data"]["attributes"]["username"].stringValue
        let nickname = json["data"]["attributes"]["displayName"].stringValue
        let avatarURL = json["data"]["attributes"]["avatarUrl"].string
        let author = AuthorObject(idString: idString, username: username, nickname: nickname, introduction: nil, avatarURL: avatarURL)
        completionHandler(author, nil)
      case .failure(let error):
        completionHandler(nil, error)
      }
    }
  }

  func fetchContentFeed(startIndex: Int, completionHandler: @escaping ([BaseContentObject]?, AFError?) -> Void) {
    let urlString = baseURLString + "/api/discussionsapi?page[offset]=\(startIndex)"
    AF.request(urlString).responseJSON { response in
      switch response.result {
      // Success.
      case .success(let data):
        DispatchQueue.global().async {
          let json = JSON(data).arrayValue
          // Get all discussion objects.
          var contentObjects = [BaseContentObject]()
          for discussionJson in json {
            guard let idString = discussionJson["id"].string,
                  let title = discussionJson["title"].string,
                  let userID = discussionJson["user"]["id"].string,
                  let username = discussionJson["user"]["username"].string,
                  let nickname = discussionJson["user"]["nickname"].string else { continue }

            let avatarURL = discussionJson["user"]["avatar_url"].string
            let author = AuthorObject(idString: userID, username: username, nickname: nickname, introduction: nil, avatarURL: avatarURL)
            let text = discussionJson["abstract"].string?.trimmingCharacters(in: .newlines)
            let imageURLs = discussionJson["image_urls"].arrayObject as? [String]
            let youtubeID = (discussionJson["video_urls"].arrayObject?.first as? String)?.youtubeID
            let likeCount = discussionJson["like_count"].intValue
            let commentCount = discussionJson["comment_count"].intValue
            let contentObject = BaseContentObject(author: author,
                                                  idString: idString,
                                                  title: title,
                                                  contentText: text,
                                                  imageURLs: imageURLs,
                                                  youtubeID: youtubeID,
                                                  numberOfLikes: likeCount,
                                                  numberOfComments: commentCount)
            contentObjects.append(contentObject)
          }
          DispatchQueue.main.async {
            completionHandler(contentObjects, nil)
          }
        }
      // Failure.
      case .failure(let error):
        completionHandler(nil, error)
      }
    }
  }

  func fetchContentDetails(contentID: String,
                           completionHandler: @escaping (ContentDetailsObject?, [ContentCommentObject]?, AFError?) -> Void) {
    let urlString = baseURLString + "/api/discussionsapi/" + contentID
    AF.request(urlString).responseJSON { response in
      switch response.result {
      // Success.
      case .success(let data):
        DispatchQueue.global().async {
          let json = JSON(data)
          guard let idString = json["id"].string,
                let title = json["title"].string,
                let text = json["content"].string,
                let postID = json["post_id"].string,
                var createdTime = json["created_at"].string,
                let userID = json["user"]["id"].string,
                let username = json["user"]["username"].string,
                let nickname = json["user"]["nickname"].string else { return }

          let author = AuthorObject(idString: userID,
                                    username: nickname.isEmpty ? username : nickname,
                                    avatarURL: json["user"]["avatar_url"].string)
          let imageURLs = json["image_urls"].arrayObject as? [String]
          let youtubeID = (json["video_urls"].arrayObject?.first as? String)?.youtubeID
          let likeCount = json["like_count"].intValue
          let commentCount = json["comment_count"].intValue - 1
          createdTime.removeLast(15)
          let contentDetailsObject = ContentDetailsObject(idString: idString,
                                                          author: author,
                                                          title: title,
                                                          text: text.trimmingCharacters(in: .newlines),
                                                          postID: postID,
                                                          createdTime: createdTime,
                                                          likeCount: likeCount,
                                                          commentCount: commentCount,
                                                          imageURLs: imageURLs,
                                                          youtubeID: youtubeID)

          let commentObjects = json["posts"].arrayValue.map { commentJson -> ContentCommentObject in
            guard let commentID = commentJson["id"].string,
                  let userID = commentJson["user"]["id"].string,
                  let username = commentJson["user"]["username"].string,
                  let nickname = commentJson["user"]["displayName"].string,
                  let text = commentJson["content"].string else {
              return ContentCommentObject(idString: "", author: AuthorObject(idString: "", username: ""), text: "", likeCount: 0)
            }
            let commentAuthor = AuthorObject(idString: userID,
                                             username: username,
                                             nickname: nickname,
                                             avatarURL: commentJson["user"]["avatar_url"].string)
            let likeCount = commentJson["like_count"].intValue
            return ContentCommentObject(idString: commentID,
                                        author: commentAuthor,
                                        text: text.trimmingCharacters(in: .newlines),
                                        likeCount: likeCount)
          }
          DispatchQueue.main.async {
            completionHandler(contentDetailsObject, commentObjects, nil)
          }
        }
      // Failure.
      case .failure(let error):
        completionHandler(nil, nil, error)
      }
    }
  }

  func uploadContent(title: String, text: String, images: [UIImage]?, videoLink: String?, completionHandler: @escaping (Bool, Error?) -> Void) {
    guard let token = CrowsUserDefaults.standard.value(forKey: CrowsUserDefaults.loginTokenKey) as? String,
          let authorData = CrowsUserDefaults.standard.data(forKey: CrowsUserDefaults.loginUserKey) else {
      debugPrint("Login user information is missing")
      return
    }
    let decoder = JSONDecoder()
    let author: AuthorObject
    do {
      author = try decoder.decode(AuthorObject.self, from: authorData)
    } catch {
      debugPrint("Unable to decode author data in user defaults")
      return
    }
    let urlString = baseURLString + "/api/discussions"
    let headers: HTTPHeaders = [
      .authorization("Token " + token + ";UserId=" + author.idString),
      .contentType("application/json")
    ]

    var finalText = text
    if let images = images, !images.isEmpty {
      uploadImages(images: images) { imageURLs, error in
        guard let imageURLs = imageURLs else {
          completionHandler(false, error)
          return
        }
        var imageURLString = ""
        for imageURL in imageURLs {
          let formattedImageURL = "![](https://" + imageURL + ")"
          imageURLString += formattedImageURL
          imageURLString.append("\n")
        }
        finalText = imageURLString + finalText
        let parameters: JSON = ["data": ["type": "discussions",
                                         "attributes": ["title": title, "content": finalText],
                                         "relationships": ["tags": ["data": [["type": "tags", "id": "1"]]]]]]
        AF.request(urlString, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
          switch response.result {
          case .success(let data):
            let json = JSON(data)
            if let errorJson = json["errors"].array?.first {
              let code = errorJson["status"].intValue
              let detail = errorJson["detail"].stringValue
              let error = NSError(domain: "UploadContent", code: code, userInfo: [NSLocalizedDescriptionKey: detail])
              completionHandler(false, error)
              return
            }
            completionHandler(true, nil)
          case .failure(let error):
            completionHandler(false, error)
          }
        }
      }
      return
    }

    if let videoLink = videoLink {
      finalText = videoLink + "\n" + text
    }

    let parameters: JSON = ["data": ["type": "discussions",
                               "attributes": ["title": title, "content": finalText],
                               "relationships": ["tags": ["data": [["type": "tags", "id": "1"]]]]]]
    AF.request(urlString, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
      switch response.result {
      case .success(let data):
        let json = JSON(data)
        if let errorJson = json["errors"].array?.first {
          let code = errorJson["status"].intValue
          let detail = errorJson["detail"].stringValue
          let error = NSError(domain: "UploadContent", code: code, userInfo: [NSLocalizedDescriptionKey: detail])
          completionHandler(false, error)
          return
        }
        completionHandler(true, nil)
      case .failure(let error):
        completionHandler(false, error)
      }
    }
  }

  func uploadImages(images: [UIImage], completionHandler: @escaping ([String]?, Error?) -> Void) {
    let urlString = baseURLString + "/api/upload"
    var imageURLs = Array(repeating: "", count: images.count)
    var summaryError: Error?
    let group = DispatchGroup()
    for i in 0..<images.count {
      group.enter()
      AF.upload(multipartFormData: { multipartFormData in
        if let data = images[i].jpegData(compressionQuality: 0.8) {
          multipartFormData.append(data, withName: "file", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpeg")
        }
      }, to: urlString, method: .post).responseString { response in
        switch response.result {
        case .success(let data):
          imageURLs[i] = data
        case .failure(let error):
          summaryError = error
        }
        group.leave()
      }
    }
    group.notify(queue: .main) {
      if let summaryError = summaryError {
        completionHandler(nil, summaryError)
        return
      }
      completionHandler(imageURLs, nil)
    }
  }

  func uploadComment(discussionID: String, content: String, completionHandler: @escaping (Bool, Error?) -> Void) {
    guard let token = CrowsUserDefaults.standard.value(forKey: CrowsUserDefaults.loginTokenKey) as? String,
          let authorData = CrowsUserDefaults.standard.data(forKey: CrowsUserDefaults.loginUserKey) else {
      debugPrint("Login user information is missing")
      return
    }
    let decoder = JSONDecoder()
    let author: AuthorObject
    do {
      author = try decoder.decode(AuthorObject.self, from: authorData)
    } catch {
      debugPrint("Unable to decode author data in user defaults")
      return
    }
    let urlString = baseURLString + "/api/posts"
    let headers: HTTPHeaders = [
      .authorization("Token " + token + ";UserId=" + author.idString),
      .contentType("application/json")
    ]
    let parameters: JSON = ["data": ["type": "posts",
                                     "attributes": ["content": content],
                                     "relationships": ["discussion": ["data": ["type": "discussions", "id": discussionID]]]]]
    AF.request(urlString, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
      switch response.result {
      case .success(let data):
        let json = JSON(data)
        if let errorJson = json["errors"].array?.first {
          let code = errorJson["status"].intValue
          var detail = errorJson["detail"].stringValue
          if detail.isEmpty {
            detail = "Upload failed. Please try again."
          }
          let error = NSError(domain: "UploadContent", code: code, userInfo: [NSLocalizedDescriptionKey: detail])
          completionHandler(false, error)
          return
        }
        completionHandler(true, nil)
      case .failure(let error):
        completionHandler(false, error)
      }
    }
  }

  func updateAvatar(image: UIImage, completionHandler: @escaping (String?, Error?) -> Void) {
    guard let token = CrowsUserDefaults.standard.value(forKey: CrowsUserDefaults.loginTokenKey) as? String,
          let authorData = CrowsUserDefaults.standard.data(forKey: CrowsUserDefaults.loginUserKey) else {
      debugPrint("Login user information is missing")
      return
    }
    let decoder = JSONDecoder()
    let author: AuthorObject
    do {
      author = try decoder.decode(AuthorObject.self, from: authorData)
    } catch {
      debugPrint("Unable to decode author data in user defaults")
      return
    }
    let headers: HTTPHeaders = [
      .authorization("Token " + token + ";UserId=" + author.idString),
      .contentType("application/json")
    ]
    let urlString = baseURLString + "/api/users/" + author.idString + "/avatar"
    AF.upload(multipartFormData: { multipartFormData in
      if let data = image.jpegData(compressionQuality: 0.8) {
        multipartFormData.append(data, withName: "avatar", fileName: "user_\(author.idString)_avatar.jpg", mimeType: "image/jpeg")
      }
    }, to: urlString, method: .post, headers: headers).responseString { response in
      switch response.result {
      case .success(let data):
        if data.contains("errors") {
          let detail = "Upload failed. Please try again."
          let error = NSError(domain: "UpdateAvatar", code: 500, userInfo: [NSLocalizedDescriptionKey: detail])
          completionHandler(nil, error)
          return
        }
        completionHandler(data, nil)
      case .failure(let error):
        completionHandler(nil, error)
      }
    }
  }

}
