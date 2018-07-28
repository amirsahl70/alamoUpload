//
//  HTTTPHandler.swift
//  alamoFileUpload
//
//  Created by Amir on 7/24/2016.
//  Copyright © 2018 uni. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class HttpHandler{
    var a = 10
    static func fileUpload(url :URL, filePath: URL , sessionManager: SessionManager ,completionHandler:  @escaping (SessionManager.MultipartFormDataEncodingResult) -> Void  ){
        sessionManager.upload( multipartFormData: { multipartFormData in
            multipartFormData.append(filePath, withName: "file")
        },
           to:  url ,
           encodingCompletion: { (encodingResult) in
            completionHandler(encodingResult)

           }
        )
        SSLPinning.giveAccess(session: sessionManager)
    }
    
}
