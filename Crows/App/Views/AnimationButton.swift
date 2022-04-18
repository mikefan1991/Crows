//
//  AnimationButton.swift
//  Crows
//
//  Created by Yingwei Fan on 5/9/21.
//

import UIKit

private let ScaleDownAnimationDuration = 0.05
private let ScaleUpAnimationDuration = 0.15
private let DraggableWidth: CGFloat = 73.0

class AnimationButton: UIButton {

  private var originalFrame: CGRect = .zero

  private var scaledTransform = CGAffineTransform(scaleX: 0.9, y: 0.9)

  private var isAnimating = false

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)

    guard !isAnimating else { return }
    isAnimating = true
    originalFrame = frame
    self.transform = self.scaledTransform
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self.superview)
    let leftX = originalFrame.minX - DraggableWidth
    let rightX = originalFrame.maxX + DraggableWidth
    let topY = originalFrame.minY - DraggableWidth
    let bottomY = originalFrame.maxY + DraggableWidth
    if location.x > leftX, location.x < rightX, location.y > topY, location.y < bottomY {
      UIView.animate(withDuration: ScaleDownAnimationDuration, delay: 0, options: .curveEaseIn, animations: {
        self.transform = self.scaledTransform
      }, completion: nil)
    } else {
      UIView.animate(withDuration: ScaleUpAnimationDuration, delay: 0, options: .curveEaseOut, animations: {
        self.transform = .identity
      }, completion: nil)
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)

    UIView.animate(withDuration: ScaleUpAnimationDuration, delay: 0, options: .curveEaseOut) {
      self.transform = .identity
    } completion: { _ in
      self.isAnimating = false
    }
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)

    UIView.animate(withDuration: ScaleUpAnimationDuration, delay: 0, options: .curveEaseOut) {
      self.transform = .identity
    } completion: { _ in
      self.isAnimating = false
    }
  }

}
