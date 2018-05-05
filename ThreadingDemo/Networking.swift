//
//  Networking.swift
//  SwiftEXT
//
//  Created by Apple on 07/04/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Alamofire

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}


class Networking: NSObject
{
    static fileprivate let kTimeOutInterval:Double = 300
    
    static fileprivate var sharedAlamofire:SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = kTimeOutInterval
        configuration.timeoutIntervalForRequest =  kTimeOutInterval
        let alamoFireManager = Alamofire.SessionManager(configuration: configuration)
        
        return alamoFireManager
    }()
    

    final class func dataTask_POST(_ path: URL, method: HTTPMethod, param: Dictionary<String, Any>, compilationBlock:@escaping (_ result: Result<Any, NSError> ) -> Void){
        
        /*let headers: HTTPHeaders = [
         "Authorization": App.kHeader,
         "Accept": "application/json"
         ]*/
        
        print("************************************************************************************************\n\n \(path)\n\n********************************************************************************************")
        
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            // do some tasks..
                /*JSONEncoding.default*/  //WHEN YOU SEND PARAMETERS IN JSON POST FORM USE THIS ENCODING
                /*URLEncoding*/           //WHEN YOU SEND PARAMETERS IN NORMAL POST FORM USE THIS ENCODING
            self.sharedAlamofire.request(path, method: .post, parameters: param, encoding:URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(let JSON):
                    compilationBlock(.success(JSON))
                    break
                case .failure(_):
                    let customError = NSError(domain: "Network", code: 67, userInfo: [NSLocalizedDescriptionKey : "Server Not Responding"]);
                    compilationBlock(.failure(customError))
                    print(response.result)
                    break
                    
                }
            }
        }
        else{
            let customError = NSError(domain: "Network", code: 67, userInfo: [NSLocalizedDescriptionKey : "No Internet Connection Available....."]);
            compilationBlock(.failure(customError))
        }
    }
    
    
    
    final class func dataTask_GET(_ path: URL, method: HTTPMethod, param: Dictionary<String, Any>, compilationBlock:@escaping (_ result: Result<Any, NSError> ) -> Void){
        
        /*let headers: HTTPHeaders = [
         "Authorization": App.kHeader,
         "Accept": "application/json"
         ]*/
        
        
        self.sharedAlamofire.request(path, method: .get, parameters: param, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(let JSON):
                compilationBlock(.success(JSON))
                break
            case .failure(_):
                let customError = NSError(domain: "Network", code: 67, userInfo: [NSLocalizedDescriptionKey : "Server Not Responding"]);
                compilationBlock(.failure(customError))
                break
                
            }
        }
    }
    
    
    final class func dataTask_Multipart(_ path: URL, method: HTTPMethod, param: Dictionary<String, Any>, Imageparam: Dictionary<String, Any>, compilationBlock:@escaping (_ result: Result<Any, NSError> ) -> Void){
        
        /*let headers: HTTPHeaders = [
         "Authorization": App.kHeader,
         /*"Accept": "application/json"*/
         ]*/
        
        self.sharedAlamofire.upload(multipartFormData:{ MultipartFormData in
            
            //if Imageparam
            
            for  (key, value) in Imageparam
            {
                if  let arr = value as? [UIImage] {
                    
                    for image in arr{
                        
                        MultipartFormData.append(UIImageJPEGRepresentation(image , 0.9)!, withName: key, fileName: "swift_file.jpeg", mimeType: "image/jpeg")
                    }
                    
                }
                else {
                    
                    MultipartFormData.append(UIImageJPEGRepresentation(value as! UIImage, 0.9)!, withName: key, fileName: "swift_file.jpeg", mimeType: "image/jpeg")
                }
                
            }
            for  (key, value) in param{
                
                MultipartFormData.append((value as AnyObject).data!(using: String.Encoding.utf8.rawValue)!, withName: key)
                
            }},
                                    usingThreshold:UInt64.init(),
                                    to:path,
                                    method:.post,
                                    headers:nil,
                                    encodingCompletion: {encodingResult in
                                        switch encodingResult {
                                        case .success(let upload, _, _):
                                            upload.responseJSON { response in
                                                //debugPrint(response)
                                                
                                                switch response.result{
                                                case .success(let result):
                                                    
                                                    compilationBlock(.success(result))
                                                case .failure(let error):
                                                    let customError = NSError(domain: "Network", code: 67, userInfo: [NSLocalizedDescriptionKey : error.localizedDescription]);
                                                    compilationBlock(.failure(customError))
                                                }
                                                
                                            }
                                        case .failure(let encodingError):
                                            print(encodingError)
                                            let customError = NSError(domain: "Network", code: 67, userInfo: [NSLocalizedDescriptionKey : "Server Not Responding"]);
                                            compilationBlock(.failure(customError))
                                        }
                                        
        })
        
        
    }
    
    final class func dataTask_MultipartWith(_ path: URL, method: HTTPMethod, param: Dictionary<String, Any>, Imageparam: Dictionary<String, Any>,Videoparam: Dictionary<String, Any>,VideoThumbImageparam: Dictionary<String, Any>, compilationBlock:@escaping (_ result: Result<Any, NSError> ) -> Void){
        
        /*let headers: HTTPHeaders = [
         "Authorization": App.kHeader,
         /*"Accept": "application/json"*/
         ]*/
        
        self.sharedAlamofire.upload(multipartFormData:{ MultipartFormData in
            
            //if Imageparam
            
            for  (key, value) in Imageparam
            {
                if  let arr = value as? [UIImage] {
                    
                    for image in arr{
                        
                        MultipartFormData.append(UIImageJPEGRepresentation(image , 0.9)!, withName: key, fileName: "swift_file.jpeg", mimeType: "image/jpeg")
                    }
                    
                }
                else {
                    
                    MultipartFormData.append(UIImageJPEGRepresentation(value as! UIImage, 0.9)!, withName: key, fileName: "swift_file.jpeg", mimeType: "image/jpeg")
                }
                
            }
            for (key, value) in Videoparam{
                var data = NSData()
                do {
                    data = try NSData(contentsOf: (value as! NSURL) as URL)//try Data.init(contentsOf: value as! URL)
                }
                catch{
                    print("Error to Conver URL to DATA")
                }
                MultipartFormData.append(data as Data, withName: key, fileName: "VideoIOS.mov", mimeType: "video/mp4")//quicktime
            }
            for  (key, value) in VideoThumbImageparam
            {
                /*if  let arr = value as? [UIImage] {
                    
                    for image in arr{
                        
                        MultipartFormData.append(UIImageJPEGRepresentation(image , 0.9)!, withName: key, fileName: "swift_file.jpeg", mimeType: "image/jpeg")
                    }
                    
                }
                else {*/
                    
                    MultipartFormData.append(UIImageJPEGRepresentation(value as! UIImage, 0.9)!, withName: key, fileName: "swift_file.jpeg", mimeType: "image/jpeg")
                //}
                
            }
            
            
            for  (key, value) in param{
                
                MultipartFormData.append((value as AnyObject).data!(using: String.Encoding.utf8.rawValue)!, withName: key)
                
            }},
                                    usingThreshold:UInt64.init(),
                                    to:path,
                                    method:.post,
                                    headers:nil,
                                    encodingCompletion: {encodingResult in
                                        switch encodingResult {
                                        case .success(let upload, _, _):
                                            upload.responseJSON { response in
                                                //debugPrint(response)
                                                
                                                switch response.result{
                                                case .success(let result):
                                                    
                                                    compilationBlock(.success(result))
                                                case .failure(let error):
                                                    let customError = NSError(domain: "Network", code: 67, userInfo: [NSLocalizedDescriptionKey : error.localizedDescription]);
                                                    compilationBlock(.failure(customError))
                                                }
                                                
                                            }
                                        case .failure(let encodingError):
                                            print(encodingError)
                                            let customError = NSError(domain: "Network", code: 67, userInfo: [NSLocalizedDescriptionKey : "Server Not Responding"]);
                                            compilationBlock(.failure(customError))
                                        }
                                        
        })
        
        
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
