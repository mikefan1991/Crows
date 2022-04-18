//
//  CrowsYouTubePlayerView.swift
//  Crows
//
//  Created by Yingwei Fan on 5/8/21.
//

import UIKit
import YouTubePlayer

class CrowsYouTubePlayerView: YouTubePlayerView {

  override init(frame: CGRect) {
    super.init(frame: frame)

    var parameters = YouTubePlayerView.YouTubePlayerParameters()
    parameters["playsinline"] = "1" as AnyObject
    parameters["modestbranding"] = "1" as AnyObject
    parameters["rel"] = "0" as AnyObject
    playerVars = parameters
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
