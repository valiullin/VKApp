//
//  ViewController.swift
//  VKTest
//

import UIKit

let APP_ID = "5664811"
let APP_Bundle = "com.vk.Vlanguish"
let SCOPE = [VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_NOHTTPS, VK_PER_EMAIL, VK_PER_MESSAGES];

extension ViewController: VKSdkDelegate, VKSdkUIDelegate {
    
    @objc(vkSdkAccessAuthorizationFinishedWithResult:) func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult) {
        if let token = result.token{
            TOKEN_KEY = token
            //perform segue here
        } else if let _ = result.error {
            present(UIAlertController(title: "Error", message: "Access denied", preferredStyle: .alert), animated: true, completion: nil)
        }
        
    }
    func vkSdkUserAuthorizationFailed() {
        present(UIAlertController(title: "Error", message: "Access denied", preferredStyle: .alert), animated: true, completion: nil)
        navigationController?.popToRootViewController(animated: true)
    }
}

class ViewController: UIViewController {
    
    var TOKEN_KEY: VKAccessToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vkSdkInstanse = VKSdk.initialize(withAppId: APP_ID)
        vkSdkInstanse?.register(self)
        vkSdkInstanse?.uiDelegate = self
        
        VKSdk.wakeUpSession(SCOPE) { (state, error) in
            if state == .authorized{
                print("authorized")
            } else if state == .initialized {
                print("initialized")
            } else {
                print(error)
            }
        }
    }
    
    @IBAction func authTouchUp(sender: UIButton) {
        
        VKSdk.authorize(SCOPE)
        
    }
    
    func vkSdkAcceptedUserToken(token: VKAccessToken!) {
        print("ACCEPTED")
    }
    
    @objc(vkSdkShouldPresentViewController:) func vkSdkShouldPresent(_ controller: UIViewController!) {
        navigationController?.topViewController?.present(controller, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        let captchaViewController = VKCaptchaViewController.captchaControllerWithError(captchaError)
        captchaViewController?.present(in: navigationController?.topViewController)
    }
    
    
    func vkSdkTokenHasExpired(_ expiredToken: VKAccessToken!) {
        VKSdk.authorize(nil)
    }
    
    
}
