//
//  NetworkingManager.swift
//  IoART
//
//  Created by Andrew Fang on 4/20/16.
//  Copyright © 2016 Fang Industries. All rights reserved.
//

import Foundation
class NetworkingManager {
    
    // Use this class as a singleton
    // NetworkingManager.sharedInstance.whateverMethod()
    static let sharedInstance = NetworkingManager()
    
    // The local IP Address to connect to. Change this if you're on a different WiFi
    // Look up System Preferences -> Network -> Status -> WiFi is connected...IP Address is X.X.X.X
    let serverIPAddr = "http://10.31.134.45:3000"
    
    
    // Packages up the current post it note and sends it as a POST request thanks to
    // http://stackoverflow.com/questions/26364914/http-request-in-swift-with-post-method
    func sendHTTPPostPostIt(body:String) {
        let request = NSMutableURLRequest(URL: NSURL(string: self.serverIPAddr)!)
        request.HTTPMethod = "POST"
        let postString = body
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            // check for fundamental networking error
            guard error == nil && data != nil else {
                print("error=\(error)")
                return
            }
            
            // check for http errors
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
        }
        task.resume()
    }
}