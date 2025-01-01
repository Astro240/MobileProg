import UIKit
import FirebaseAuth
import FirebaseDatabase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }

        // Check if the user is already authenticated
        if let currentUser = Auth.auth().currentUser {
            let ref = Database.database().reference()
            ref.child("Users").child(currentUser.uid).observeSingleEvent(of: .value) { snapshot in
                guard let userData = snapshot.value as? [String: Any],
                      let roleName = userData["Role"] as? String else {
                    print("Error: Unable to fetch user role")
                    SceneDelegate.showLogin() // Show login if unable to determine role
                    return
                }
                
                // Navigate based on Role
                switch roleName {
                case "User":
                    print("Logged in successfully as User!")
                    SceneDelegate.showHome()
                case "Organizer":
                    print("Logged in successfully as Organizer!")
                    SceneDelegate.showEvHome()
                case "Administrator":
                    print("Logged in successfully as Administrator!")
                    SceneDelegate.showAdminHome()
                default:
                    print("Error: Unknown role")
                    SceneDelegate.showLogin()
                }
            } withCancel: { error in
                print("Database error: \(error.localizedDescription)")
                SceneDelegate.showLogin() // Fall back to login on error
            }
        } else {
            // No user is logged in, show the login screen
            SceneDelegate.showLogin()
        }
    }

    // Static method to show login screen
    static func showLogin() {
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        let storyboard = UIStoryboard(name: "Alhasan - Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        sceneDelegate.window?.rootViewController = vc
        sceneDelegate.window?.makeKeyAndVisible()
    }

    // Static method to show interests screen
    static func showInterests() {
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        let storyboard = UIStoryboard(name: "Alhasan - Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InterestsViewController")
        sceneDelegate.window?.rootViewController = vc
        sceneDelegate.window?.makeKeyAndVisible()
    }

    // Static method to show home screen for users
    static func showHome() {
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeTabBar")
        sceneDelegate.window?.rootViewController = vc
        sceneDelegate.window?.makeKeyAndVisible()
    }

    // Static method to show home screen for event organizers
    static func showEvHome() {
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EvOrgTab")
        sceneDelegate.window?.rootViewController = vc
        sceneDelegate.window?.makeKeyAndVisible()
    }
    static func showAdminHome() {
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "adminTab")
        sceneDelegate.window?.rootViewController = vc
        sceneDelegate.window?.makeKeyAndVisible()
    }
    func sceneDidDisconnect(_ scene: UIScene) {
        // Clean up resources as needed when the scene disconnects
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Restart paused tasks
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Pause ongoing tasks
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Restore state as the app enters the foreground
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Save state as the app enters the background
    }
}
