//
//  ViewController.swift
//  NetworkingWithGenerics
//
//  Created by Paresh on 11/1/18.
//  Copyright © 2018 Paresh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchGenericData(urlstring: "https://api.letsbuildthatapp.com/youtube/home_feed") { (homeFeed: HomeFeed) in
            homeFeed.videos.forEach({ print($0.name) })
        }
        
        fetchGenericData(urlstring: "https://api.letsbuildthatapp.com/youtube/course_detail?id=1") {(courseDetails: [CourseDetails]) in
            courseDetails.forEach({ print($0.name, $0.duration) })
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func fetchGenericData<T: Decodable>(urlstring: String, completionHandler completion: @escaping (T) -> ()) {
        
        let url = URL(string: urlstring)
        
        URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if error != nil {
                print(error?.localizedDescription ?? "error")
            }else {
                
                guard let data = data else { return }
                
                do
                {
                    let objc = try JSONDecoder().decode(T.self, from: data)
                    completion(objc)
                }catch (let error){
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
}


struct CourseDetails: Decodable {
    let name: String
    let duration: String
}

struct HomeFeed: Decodable {
    let videos: [Video]
}

struct Video: Decodable {
    let id: Int
    let name: String
}
