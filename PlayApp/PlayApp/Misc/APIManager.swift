//
//  APIManager.swift
//  PlayApp
//
//  Created by ameethakkar on 8/3/18.
//  Copyright © 2018 ameethakkar. All rights reserved.
//

import Foundation

class APIManager {
    static let sharedInstance = APIManager()
    private var orgName = ""
    let baseURL = "https://api.github.com/users/"
    // set up the session
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    func makeGetCall(orgName: String,page:Int, completionHandler: @escaping (_ result:[Repository],_ error:String) -> Void) {
        // Set up the URL request
        if(orgName != ""){
            self.orgName = orgName
        }
        
        let todoEndpoint: String = baseURL + self.orgName + "/repos?page=\(page)&per_page=10&access_token=0fbc95a501f55414b06caf45daaa903c555a8ac3"
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET")
                print(error!)
                completionHandler([],error.debugDescription)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                completionHandler([],"Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let repos = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [NSDictionary] else {
                        print("error trying to convert data to JSON (1)")
                        completionHandler([],self.getError(result: responseData))
                        return
                }
                
                //To get the last page number and know when to stop the api calls
                print("##########################")
                if let link = (response as! HTTPURLResponse).allHeaderFields["Link"] as? String {
                    let query = link.split(separator: ",")[1].split(separator: ";")[0].split(separator: "?")[1].split(separator: "&")[0]
                    Utilies.page = Int(query.split(separator: "=")[1])!
                }
                print("##########################")
                
                completionHandler(self.getRepoObjects(result: repos),"")
                
            } catch  {
                print("error trying to convert data to JSON (2)")
                completionHandler([],"error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
    private func getRepoObjects(result:[NSDictionary]) -> [Repository] {
        var tempResults = [Repository]()
        for obj in result {
            tempResults.append(Repository(name: obj.value(forKey: "name") as? String, description: obj.value(forKey: "description") as? String, created_at: obj.value(forKey: "created_at") as? String, license: obj.value(forKey: "license") as? NSDictionary))
        }
        return tempResults
    }
    
    private func getError(result:Data) -> String {
        do{
            guard let error = try JSONSerialization.jsonObject(with: result, options: [])
                as? NSDictionary else{
                    return "error trying to convert data to JSON"
            }
            return error.value(forKey: "message") as! String
        }
        catch {
            return "Unknown Error"
        }
    }
}
