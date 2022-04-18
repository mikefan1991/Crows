//
//  DynamicHeightCollectionView.swift
//  Crows
//
//  Created by Yingwei Fan on 4/9/21.
//

import UIKit

class DynamicHeightCollectionView: UICollectionView {

  override func layoutSubviews() {
    super.layoutSubviews()

    if bounds.size != intrinsicContentSize {
      invalidateIntrinsicContentSize()
    }
  }

  override var intrinsicContentSize: CGSize {
    return contentSize
  }

}
