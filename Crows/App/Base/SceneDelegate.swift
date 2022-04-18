//
//  SceneDelegate.swift
//  Crows
//
//  Created by Yingwei Fan on 4/9/21.
//

import UIKit
import KeychainSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?


  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    guard let windowScene = (scene as? UIWindowScene) else { return }

    self.window = UIWindow(windowScene: windowScene)

    let userDefaults = CrowsUserDefaults.standard
    if let authorData = userDefaults.data(forKey: CrowsUserDefaults.loginUserKey) {
      let decoder = JSONDecoder()
      let authorObject: AuthorObject
      do {
        authorObject = try decoder.decode(AuthorObject.self, from: authorData)
      } catch {
        debugPrint("Unable to decode author object.")
        return
      }
      let keychain = KeychainSwift()
      let password = keychain.get(authorObject.idString) ?? ""
      CrowsServices.shared.login(identification: authorObject.username, password: password) { success, error in
        guard success else {
          debugPrint("Login failed while opening the app.")
          return
        }
      }
      self.window?.rootViewController = RootTabBarViewController()
    } else {
      let signInViewController = SignInViewController()
      let signInNavigationController = SignInNavigationController(rootViewController: signInViewController)
      self.window?.rootViewController = signInNavigationController
    }
    self.window?.makeKeyAndVisible()
  }

  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }

  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
  }


}

