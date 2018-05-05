//
//  APIConstant.swift
//  Dryveways
//
//  Created by Apple on 09/08/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation

fileprivate struct ServerType {
    
    static var DevlopmentBaseURL: String{
        return "https://www.ctinfotech.com/CT06/cancer-connect/"
    }
    static var ProductionBaseURL: String{
        return "https://www.ctinfotech.com/CT06/cancer-connect/"
    }
    
    static var BaseURL: String{
        return ProductionBaseURL + "Ios/"/*"Api/"*/
    }
    
    static var ImageBaseURL: String{
        return ProductionBaseURL
    }
    

}

 struct APIController {
    static var HomeController: String{
        return ServerType.BaseURL+"home/"
    }
    static var DashboardController: String{
        return ServerType.BaseURL+"dashboard/"
    }
    static var ProductController: String{
        return ServerType.BaseURL+"product/"
    }
    static var CartController: String{
        return ServerType.BaseURL+"cart/"
    }
    static var ShippingAddressController: String{
        return ServerType.BaseURL+"ship_address/"
    }
    static var SalesController: String{
        return ServerType.BaseURL+"sales/"
    }
    
    
    //////// FOR IMAGES
    
    //https://www.ctinfotech.com/CT06/cancer-connect/assets/userfile/post
    
    static var PostController: String{
        return ServerType.ImageBaseURL+"assets/userfile/post/"
    }
    static var UserProfilePicController: String{
        return ServerType.ImageBaseURL+"assets/userfile/"
    }
    static var ResourcePicController: String{
        return ServerType.ImageBaseURL+"assets/resource/"
    }
    static var DoctorsPicController: String{
        return ServerType.ImageBaseURL+"assets/doctors/"
    }
    //https://www.ctinfotech.com/CT06/cancer-connect/assets/resource/image.jpg

}

struct APIConstant {
    
   /* static var SignupAPI: String{
        return APIController.HomeController + "signup"
    }
    static var LoginAPI: String{
        return APIController.HomeController + "login"
    }
    static var ForgotPasswordAPI: String{
        return APIController.HomeController + "forget_password"
    }*/

    static var SignupAPI: String{
        return ServerType.BaseURL + "signup"
    }
    static var SocialSignUpAPI: String{
        return ServerType.BaseURL + "social_login"
    }
    static var LoginAPI: String{
        return ServerType.BaseURL + "login"
    }
    static var FeedsAPI: String{
        return ServerType.BaseURL + "newsfeed"
    }
    static var AddPostAPI: String{
        return ServerType.BaseURL + "addPost"
    }
    static var UpdateProfileAPI: String{
        return ServerType.BaseURL + "updateProfile"
    }
    static var GetProfileAPI: String{
        return ServerType.BaseURL + "getProfile"
    }
    static var FriendRequestActionsAPI: String{ // SEND = 0 & CANCEL = 2 & ACCEPT = 1
        return ServerType.BaseURL + "friendRequest"
    }
    static var PostCommentAPI: String{
        return ServerType.BaseURL + "comment"
    }
    static var LikeUnlikePostAPI: String{
        return ServerType.BaseURL + "likeUnlike"
    }
    static var AllUsersAPI: String{
        return ServerType.BaseURL + "allUser"
    }
    static var SearchUsersAPI: String{
        return ServerType.BaseURL + "searchUser"
    }
    static var GetFriendRequestAPI: String{
        return ServerType.BaseURL + "getFreindRequest"
    }
    static var GetNotificationsAPI: String{
        return ServerType.BaseURL + "notification"
    }
    static var GetCommentsAPI: String{
        return ServerType.BaseURL + "getComment"
    }
    static var ChatAPI: String{
        return ServerType.BaseURL + "chat"
    }
    static var getFriendListAPI: String{
        return ServerType.BaseURL + "friendList"
    }
    static var GetChatListAPI: String{
        return ServerType.BaseURL + "chatlist"
    }
    static var GetChatHistoryAPI: String{
        return ServerType.BaseURL + "chatHistory"
    }
    static var GetRsourceListAPI: String{
        return ServerType.BaseURL + "resourceList"
    }
    static var GetDoctorsAPI: String{
        return ServerType.BaseURL + "doctorList"
    }
    static var ForgotPasswordAPI: String{
        return ServerType.BaseURL + "forgetPassword"
    }
    static var ResetPasswordAPI: String{
        return ServerType.BaseURL + "resetPassword"
    }
    static var AddEventAPI: String{
        return ServerType.BaseURL + "addEvent"
    }
    static var GetEventAPI: String{
        return ServerType.BaseURL + "getEvent"
    }
    static var EULA_API: String{
        return ServerType.BaseURL + "getPage/eula"
    }
    static var Logout_API: String{
        return ServerType.BaseURL + "logout"
    }
    static var Report_API: String{
        return ServerType.BaseURL + "reportHide"
    }
    static var BlockUnblock_API: String{
        return ServerType.BaseURL + "blockUnblock"
    }
    //resetPassword
    /*static var ForgotPasswordAPI: String{
        return ServerType.BaseURL + "forget_password"
    }*/
    
    
}

struct App {
    
    //static let kHeader = "Bearer b7748d1b-0d68-4ed6-9766-d624f3831af4"
    static let kAuthkey = "dfs#!df154$"
    static let kDeviceTokenKey = "device_token"
    static let kDeviceTypeKey = "devicetype"
}
