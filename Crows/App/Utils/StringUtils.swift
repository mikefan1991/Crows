//
//  StringUtils.swift
//  Crows
//
//  Created by Yingwei Fan on 5/14/21.
//

import Foundation

extension String {

  var isYouTubeLink: Bool {
    let youtubeRegex = "(http(s)?:\\/\\/)?(www\\.|m\\.)?youtu(be\\.com|\\.be)(\\/watch\\?([&=a-z]{0,})(v=[\\d\\w]{1,}).+|\\/[\\d\\w]{1,})"

    let youtubeCheckResult = NSPredicate(format: "SELF MATCHES %@", youtubeRegex)
    return youtubeCheckResult.evaluate(with: self)
  }

  var youtubeID: String? {
    guard isYouTubeLink else { return nil }

    let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
    let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    let range = NSRange(location: 0, length: self.count)
    guard let result = regex?.firstMatch(in: self, range: range) else {
      return nil
    }
    let start = self.index(self.startIndex, offsetBy: result.range.lowerBound)
    let end = self.index(self.startIndex, offsetBy: result.range.upperBound)
    return String(self[start..<end])
  }

  var isValidEmail: Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPredicate.evaluate(with: self)
  }

}
