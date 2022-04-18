//
//  CirclePageContentScrollable.swift
//  CirclePageDemo
//
//  Created by Yingwei Fan on 4/15/21.
//

import Foundation

/** The scrollable protocol for child view controllers of the circle view controller. */
protocol CirclePageContentScrollable: NSObjectProtocol {
  // Whether the content is currently scrollable.
  var contentScrollable: Bool { get set}

  // Callback for the base view to change scrollable state.
  var baseScrollableCallback: ((Bool) -> Void)? { get set }
}
