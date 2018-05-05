//
//  Constant.swift
//  Electronic Medical
//
//  Created by Apple on 29/11/17.
//  Copyright © 2017 Jaipee Tech. All rights reserved.
//

import Foundation
import UIKit

struct IconSize{
    struct Navigation{
        static var Menu:CGSize {
            return CGSize(width: 20, height: 20)
        }
        static var Back:CGSize {
            return CGSize(width: 20, height: 20)
        }
        static var Text:CGSize {
            return CGSize(width: 60, height: 20)
        }
    }
}


struct Constants {
    struct Segue {
        static var LoginHomeSegue: String{
            return "LoginHomeSegue"
        }
        
        static var loginSignupSegue: String{
            return "loginSignupSegue"
        }
        static var ReserveLocationSegue: String{
            return "ReserveLocationSegue"
        }
        
        static var ForgotPasswordSegue: String{
            return "ForgotPasswordSegue"
        }
        static var LoginSegue: String{
            return "LoginSegue"
        }
        
        static var PayForSegue: String{
            return "PayForSegue"
        }

    }
    
    struct StoryBoard {
        
        static var Initiater: String{
            return "Initiater"
        }
        
        static var Main: String{
            return "Main"
        }
        static var Login: String{
            return "LoginSignUP"
        }
    }
}


extension Constants{
    
    struct Provider{
        static var APIKey: String {
            return "AIzaSyCEAgYBDDFD_EjOZKyLOBdbx2fIuW7oGkA"
        }
    }
    
}

struct AppColor {
    static var PinkColor : UIColor{
        return UIColor(red: 255.0/255.0, green: 107.0/255.0, blue: 177.0/255.0, alpha: 1.0)
    }
}
