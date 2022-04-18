//
//  Images.swift
//  Crows
//
//  Created by Yingwei Fan on 5/2/21.
//

import UIKit

class CrowsImage: NSObject {

  static let placeholder: UIImage = {
    guard let imagePath = Bundle.main.path(forResource: "ImagePlaceholder", ofType: "png"),
          let image = UIImage(contentsOfFile: imagePath) else {
      return UIImage()
    }
    return image
  }()

}
