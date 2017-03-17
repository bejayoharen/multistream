//
//  VideoList.swift
//  MultiStream
//
//  Created by Bjorn Roche on 3/17/17.
//  Copyright © 2017 multistream. All rights reserved.
//

import Foundation

class Video {
    let name:String
    let url:URL
    public init(name:String, url:URL) {
        self.name = name
        self.url = url
    }
}

class VideoList {
    private let urlString = "https://s3.amazonaws.com/livelike-webs/interviews/video_list.json"
    
    var videos = [Video]()
    private var onCompletion:((Error?) -> Void)? = nil
    
    public func reset() {
        videos.removeAll()
    }
    public func fetchVideos( onCompletion: ((Error?) -> Void)? ) {
        reset()
        
        // setup the oncompletion wrapper
        self.onCompletion = { (error:Error?) -> Void in
            DispatchQueue.main.async {
                onCompletion?(error)
            }
        }
        
        let url = URL(string: urlString)
        
        let task = URLSession.shared.dataTask(with: url!) {[weak self] (data, response, error) in
            guard let s = self else {
                return
            }
            if error != nil {
                s.onCompletion!(error)
                return
            }
            
            // check status code, and other basic errors:
            guard let hr = response as! HTTPURLResponse? else {
                print("Expected HTTPURLResponse, but got: \(response.self)")
                s.onCompletion!(MiscError(description:NSLocalizedString("Internal Error: Unexpected response type.", comment: "Internal Error: Unexpected response type.")))
                return
            }
            
            if( hr.statusCode >= 300 || hr.statusCode < 200 ) {
                print("Non-success status code: \(hr.statusCode)")
                print("Complete response: \(hr)\n\(data)")
                s.onCompletion!(MiscError(description:NSLocalizedString("Invalid response.", comment: "Invalid response.")))
                return
            }
            
            if data == nil || data!.count == 0 {
                s.onCompletion!(MiscError(description:NSLocalizedString("Invalid response (no data).", comment: "Invalid response (no data).")))
                return
            }
            
            s.videos.removeAll()

            //parse out the response
            // For now, we do this pretty manually, rather than creating objects for each item.
            // If this were not a demo project but something that might grow into something more complex,
            // it would be better to crete playlist and user and track objects and so on, and work from there.
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as? Dictionary<String, AnyObject>
                if json == nil {
                    s.onCompletion!(MiscError(description:NSLocalizedString("Invalid response(json dictionary).", comment: "Invalid response (json dictionary).")))
                    return
                }
                
                let vl = json!["videoList"] as? Array< Dictionary<String,AnyObject> >
                
                if vl == nil {
                    print("Complete response: \(json)")
                    s.onCompletion!(MiscError(description:NSLocalizedString("Invalid response (json dictionary).", comment: "Invalid response (json dictionary).")))
                    return
                }
                for v in vl! {
                    let nameU = v["name"];
                    let urlU = v["url"];
                    guard let urls = urlU as! String? else {
                        continue
                    }
                    guard let name = nameU as! String? else {
                        continue
                    }
                    let url = URL(string: urls)
                    if( url == nil ) {
                        continue
                    }
                    s.videos.append(Video(name:name,url:url!))
                }
            } catch _ {
                s.onCompletion!(MiscError(description:NSLocalizedString("Invalid response (json not understood).", comment: "Invalid response (json not understood).")))
                return
            }
            s.onCompletion!(nil)
        }
        
        task.resume()
    }
}
