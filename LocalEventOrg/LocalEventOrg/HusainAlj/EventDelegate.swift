//
//  EventDelegate.swift
//  LocalEventOrg
//
//  Created by YourName on Date.
//
import UIKit

class EventDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        // If using a storyboard-based launch, you can load it here:
        //   let storyboard = UIStoryboard(name: "Event", bundle: nil)
        //   let navController = storyboard.instantiateInitialViewController()
        //       as? UINavigationController
        //   window.rootViewController = navController
        
        // OR if your "Main Interface" in target settings = "Event", it might automatically load.
        // We'll assume the above or a main storyboard is set. If you rely purely on code, do something like:
        //   let createEventVC = CreateEventViewController()
        //   let nav = UINavigationController(rootViewController: createEventVC)
        //   window.rootViewController = nav

        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}
