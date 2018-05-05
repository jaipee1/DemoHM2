//
//  LoginViewController.swift
//  CancerConnect
//
//  Created by Apple on 26/02/18.
//  Copyright © 2018 Jaipee Tech. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire


class LoginViewController: UIViewController {
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Login"
        {
            if segue.destination is NavigationController {
                //destinationVC.numberToDisplay = counter
            }
        }
    }
    
    
    @IBAction func backAction(sender:UIButton) {
        
        //self.dissmissViewControllerJ()
        self.popViewControllerJ()
    }
    
    func Validate() -> (status: Bool, message: String)
    {
        var message = ""
        var status = true
        
        if txtEmail.text!.isEmpty
        {
            message = "Please Enter Email ID"
            status = false
        }
        else if !self.txtEmail.text!.isValidEmail {
            message = "Please enter valid Email ID"
            status = false
            
        }
        else if txtPassword.text!.isEmpty
        {
            message = "Please Enter Password"
            status = false
        }
        
        
        
        return (status: status, message: message)
        
    }
    
    @IBAction func btnLoginAction(_ sender: Any) {
        
        if Validate().status {
            
            self.login()
        }else {
            
            self.showAnnouncment(withMessage: Validate().message)
        }
        
    }
    
    @IBAction func btnSocialAction(_ sender: UIButton) {
        if sender.tag == 2 {
            GIDSignIn.sharedInstance().delegate     = self
            GIDSignIn.sharedInstance().uiDelegate   = self
            GIDSignIn.sharedInstance().signIn()
        }
        else if sender.tag == 1 {
            
            /*let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: accessToken.tokenString, version: nil, HTTPMethod: "GET")
             req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
             if(error == nil)
             {
             print("result \(result)")
             }
             else
             {
             print("error \(error)")
             }
             })*/
            
            FBSDKAccessToken.setCurrent(nil) 
            SocialAuthController.loginWithFaceBook(presentingViewController: self, permissions: ["public_profile","email"]) { (result, error) in
                if error != nil {
                    self.showAnnouncment(withMessage: error!.localizedDescription)
                }else {
                    
                    _ =  SocialAuthController.facebookGraphRequest(fields: "id,name,education,email,gender,picture.type(large)", compilationHandler: { (connection, data, error) in
                        if error == nil &&  result != nil{
                            
                            if let result = data as? [String: Any] {
                                let name = result["name"] as? String;
                                let email  = result["email"] as? String;
                                
                                
                                
                                //let authprovider: SocialAuthProvider = .facebook
                                
                                let authIDAny = result["id"]! as Any;
                                let id = "\(authIDAny)"
                                let imageUrl = "http://graph.facebook.com/\(id)/picture?type=large"
                                
                                var  (firstName, lastName): (String?, String?) = (nil, nil)
                                
                                guard email != nil && name != nil  else {
                                    return
                                }
                                self.socialLoginBy(email!, name: name!, imageURl: imageUrl)
                                
                            }else {
                                //JPHUD.hide()
                                self.showAnnouncment(withMessage: error!.localizedDescription)
                            }
                        }
                    })
                }
            }
        }
    }
    
}

extension LoginViewController : GIDSignInDelegate,GIDSignInUIDelegate{
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
              withError error: Error!) {
        //SVProgressHUD.isUserInteraction(Enable: true)
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        SVProgressHUD.isUserInteraction(Enable: false)
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            //let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            //let givenName = user.profile.givenName
            //let familyName = user.profile.familyName
            let email = user.profile.email
            
            print(user.profile.name)
            
            if user.profile.hasImage{
                // crash here !!!!!!!! cannot get imageUrl here, why?
                // let imageUrl = user.profile.imageURLWithDimension(120)
                let imageUrl = signIn.currentUser.profile.imageURL(withDimension: 120)
                print(" image url: ", imageUrl?.absoluteString as Any)
                socialLoginBy(user.profile.email, name: user.profile.name, imageURl: (imageUrl?.absoluteString)!)
            }
            else{
                
                socialLoginBy(user.profile.email, name: user.profile.name, imageURl: "")
            }
            
            /*{
             "first_name":"mayank",
             "last_name":"patidar",
             "email":"mayank.ctinformatics@gmail.com",
             "facebook_id":"fb-id",
             "google_id":"google-id",
             "device_token":"device token2",
             "token":"df094c0342bd72c64733012bc2b810a1"
             }*/
            
            /* let fullNameArr = fullName?.components(separatedBy: " ")
             
             var Param = [String: Any] ()
             Param["email"]          = email
             Param["first_name"]     = fullNameArr?.first
             Param["last_name"]      = fullNameArr?.last
             Param["facebook_id"]    = ""
             Param["google_id"]      = userId
             Param["device_token"]   = ""
             Param["ios_device_token"]   = SharedPrefrence.deviceToken()
             Param["token"]          = App.kAppToken
             
             print(Param)*/
            
            SVProgressHUD.isUserInteraction(Enable: true)
            
            //SocialLoginAPI_CallWith(Param)
            
        } else {
            print("\(error.localizedDescription)")
            SVProgressHUD.isUserInteraction(Enable: true)
        }
    }
    
    
}


extension LoginViewController {
    fileprivate func login(){
        
        /*
         
         password:123456
         email:sunil@gmail.com
         authkey :dfs#!df154$
         android_token:
         ios_token:
         
         
         */
        
        
        SVProgressHUD.isUserInteraction(Enable: false)
        
        
        var Param = [String: Any] ()
        Param["authkey"]        = App.kAuthkey
        Param["email"]          = txtEmail.text!
        Param["password"]       = txtPassword.text!
        Param["ios_token"]      = SharedPrefrence.deviceToken()
        Param["android_token"]  = ""
        
        
        
        print(Param)
        
        
        
        Networking.dataTask_POST(Foundation.URL(string: APIConstant.LoginAPI)!  , method: .post, param: Param) { (response) in
            
            switch response{
                
            case .success(let dictionary as [String: Any]):
                
                print(dictionary)
                
                let status = dictionary["success"] as! String
                
                if status == "true" {
                    
                    var CancerTypeDict = [[String: Any]]()
                    CancerTypeDict = dictionary["cancerType"] as! [[String : Any]]
                    
                    print("JAI ::::::\(CancerTypeDict)")
                    
                    let userinfo = Userinfo_Base.init(dictionary: dictionary as NSDictionary)  
                    print(userinfo?.userinfo?.email as Any)
                    print(userinfo?.userinfo?.name as Any)
                    //print(userinfo?.userinfo?.email as Any)
                    
                    let userData : UserData = UserData.sharedInstance
                    
                    userData.userID         = userinfo?.userinfo?.id
                    userData.firstNmae      = userinfo?.userinfo?.name
                    //userData.lastName       = userinfo?.userinfo?.last_name
                    userData.emailID        = userinfo?.userinfo?.email
                    userData.profilePic     = userinfo?.userinfo?.image
                    userData.contact_no     = userinfo?.userinfo?.mobile
                    userData.cancerType     = userinfo?.userinfo?.cancerType
                    userData.city           = userinfo?.userinfo?.city
                    userData.dob            = userinfo?.userinfo?.dob
                    userData.zip            = userinfo?.userinfo?.zipcode
                    userData.userType       = userinfo?.userinfo?.uType
                    userData.state          = userinfo?.userinfo?.state
                    userData.onlinestatus   = userinfo?.userinfo?.online_status
                    userData.mood           = userinfo?.userinfo?.mood
                    userData.gender         = userinfo?.userinfo?.gender
                    userData.forgotToken    = userinfo?.userinfo?.forgot_token
                    userData.address        = userinfo?.userinfo?.address
                    userData.cancerName     = userinfo?.userinfo?.cancer_name
                    
                    //userData.ArrcancerType  = userinfo?.cancerType
                    let encodedData = NSKeyedArchiver.archivedData(withRootObject: CancerTypeDict)
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(encodedData, forKey: "JAIKEY")
                    
                    let decoded  = UserDefaults.standard.object(forKey: "JAIKEY") as! Data
                    let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [[String:Any]]
                    print("Decode :: :: \(decodedTeams)")
                    
                    SharedPrefrence.saveUserData(userData)
                    self.performSegue(withIdentifier: "Login", sender: nil)
                    
                }
                else {
                    
                    self.showAnnouncment(withMessage: dictionary["message"] as! String)
                }
                
                //JPHUD.hide()
                SVProgressHUD.isUserInteraction(Enable: true)
                break
            case .failure(let error):
                //JPHUD.hide()
                SVProgressHUD.isUserInteraction(Enable: true)
                
                print(error.userInfo.first?.value as Any)
                
                self.showAnnouncment(withMessage: error.userInfo.first?.value as! String)
                
            default:
                break
            }
        }
    }
    
    fileprivate func socialLoginBy(_ email: String, name : String ,imageURl : String){
        
        /*
         email:
         image:
         name :
         authkey:dfs#!df154$
         android_token:
         ios_token:
         
         */
        
        
        SVProgressHUD.isUserInteraction(Enable: false)
        
        
        var Param = [String: Any] ()
        Param["authkey"]        = App.kAuthkey
        Param["email"]          = email
        Param["name"]           = name
        Param["image"]          = imageURl
        Param["ios_token"]      = SharedPrefrence.deviceToken()
        Param["android_token"]  = ""
        
        
        
        print(Param)
        
        
        
        Networking.dataTask_POST(Foundation.URL(string: APIConstant.SocialSignUpAPI)!  , method: .post, param: Param) { (response) in
            
            switch response{
                
            case .success(let dictionary as [String: Any]):
                
                print(dictionary)
                
                let status = dictionary["success"] as! String
                
                if status == "true" {
                    
                    var CancerTypeDict = [[String: Any]]()
                    CancerTypeDict = dictionary["cancerType"] as! [[String : Any]]
                    
                    print("JAI ::::::\(CancerTypeDict)")
                    
                    let userinfo = Userinfo_Base.init(dictionary: dictionary as NSDictionary)
                    print(userinfo?.userinfo?.email as Any)
                    print(userinfo?.userinfo?.name as Any)
                    //print(userinfo?.userinfo?.email as Any)
                    
                    let userData : UserData = UserData.sharedInstance
                    
                    userData.userID         = userinfo?.userinfo?.id
                    userData.firstNmae      = userinfo?.userinfo?.name
                    //userData.lastName       = userinfo?.userinfo?.last_name
                    userData.emailID        = userinfo?.userinfo?.email
                    userData.profilePic     = userinfo?.userinfo?.image
                    userData.contact_no     = userinfo?.userinfo?.mobile
                    userData.cancerType     = userinfo?.userinfo?.cancerType
                    userData.city           = userinfo?.userinfo?.city
                    userData.dob            = userinfo?.userinfo?.dob
                    userData.zip            = userinfo?.userinfo?.zipcode
                    userData.userType       = userinfo?.userinfo?.uType
                    userData.state          = userinfo?.userinfo?.state
                    userData.onlinestatus   = userinfo?.userinfo?.online_status
                    userData.mood           = userinfo?.userinfo?.mood
                    userData.gender         = userinfo?.userinfo?.gender
                    userData.forgotToken    = userinfo?.userinfo?.forgot_token
                    userData.address        = userinfo?.userinfo?.address
                    userData.cancerName     = userinfo?.userinfo?.cancer_name
                    
                    //userData.ArrcancerType  = userinfo?.cancerType
                    let encodedData = NSKeyedArchiver.archivedData(withRootObject: CancerTypeDict)
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(encodedData, forKey: "JAIKEY")
                    
                    let decoded  = UserDefaults.standard.object(forKey: "JAIKEY") as! Data
                    let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [[String:Any]]
                    print("Decode :: :: \(decodedTeams)")
                    
                    SharedPrefrence.saveUserData(userData)
                    self.performSegue(withIdentifier: "Login", sender: nil)
                    
                }
                else {
                    
                    self.showAnnouncment(withMessage: dictionary["message"] as! String)
                }
                
                //JPHUD.hide()
                SVProgressHUD.isUserInteraction(Enable: true)
                break
            case .failure(let error):
                //JPHUD.hide()
                SVProgressHUD.isUserInteraction(Enable: true)
                
                print(error.userInfo.first?.value as Any)
                
                self.showAnnouncment(withMessage: error.userInfo.first?.value as! String)
                
            default:
                break
            }
        }
    }
    
    
}
extension LoginViewController {
    
    fileprivate func updateProfile(){

        SVProgressHUD.isUserInteraction(Enable: false)
        
        
        var Param = [String: Any] ()
        /*Param["authkey"]            = App.kAuthkey
        Param["id"]                 = SharedPrefrence.getUserData().getUserid()
        Param["email"]              = SharedPrefrence.getUserData().getEmailID()
*/
        
        var ImageParam = [String: Any] ()
        //ImageParam["file"]                      = imageViewProfilePic.image
        print(Param)
        Networking.dataTask_Multipart(Foundation.URL(string: APIConstant.UpdateProfileAPI)!, method: .post, param: Param, Imageparam: ImageParam) { (responce) in
            switch responce{
                
            case .success(let dictionary as [String: Any]):
                print(dictionary)
                let success = dictionary["success"] as! String
                if success == "true" {

                    self.showAnnouncment(withMessage: dictionary["message"] as! String)
                }
                else {
                    
                    self.showAnnouncment(withMessage: dictionary["message"] as! String)
                }
                
                //JPHUD.hide()
                SVProgressHUD.isUserInteraction(Enable: true)
                break
            case .failure(let error):
                //JPHUD.hide()
                SVProgressHUD.isUserInteraction(Enable: true)
                
                print(error.userInfo.first?.value as Any)
                
                self.showAnnouncment(withMessage: error.userInfo.first?.value as! String)
                
            default:
                break
                
            }
        }
    }
}

extension SVProgressHUD{
    
    static func isUserInteraction(Enable:Bool){
        let window = UIApplication.shared.keyWindow
        
        if Enable {
            window?.isUserInteractionEnabled = true
            SVProgressHUD.dismiss()
        }
        else{
            window?.isUserInteractionEnabled = false
            SVProgressHUD.show(withStatus: "loading...")
        }
    }
    
}
/*
 @import IQKeyboardManagerSwift;
 @import SVProgressHUD;
 */
