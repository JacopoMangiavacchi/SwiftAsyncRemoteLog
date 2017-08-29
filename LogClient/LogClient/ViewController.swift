//
//  ViewController.swift
//  LogClient
//
//  Created by Jacopo Mangiavacchi on 8/26/17.
//  Copyright © 2017 Jacopo. All rights reserved.
//

import UIKit
import Disk

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func log(_ sender: Any) {
        
        let config = URLSessionConfiguration.background(withIdentifier: "LogServer")
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        
        var request = URLRequest(url: URL(string: "https://pwwdczqnhn.localtunnel.me/hello")!) //http://localhost:8080/hello  //https://wkfktmfipc.localtunnel.me/hello
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        struct Message: Codable {
            let title: String
            let body: String
        }
        
        let message = Message(title: "Hello", body: "from iOS")
        
        try! Disk.save(message, to: .caches, as: "message.json")
        
        let url = try! Disk.getURL(for: "message.json", in: .caches)
        
        let task = session.uploadTask(with: request, fromFile: url)
        
        task.earliestBeginDate = Date()
        task.countOfBytesClientExpectsToSend = NSURLSessionTransferSizeUnknown
        task.countOfBytesClientExpectsToReceive = NSURLSessionTransferSizeUnknown
        
        task.resume()
    }

}


extension ViewController : URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print("didBecomeInvalidWithError")
    }
    
//    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
//        print("didReceive challenge")
//    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print("urlSessionDidFinishEvents")
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, willBeginDelayedRequest request: URLRequest, completionHandler: @escaping (URLSession.DelayedRequestDisposition, URLRequest?) -> Swift.Void) {
        print("willBeginDelayedRequest")
        completionHandler(.continueLoading, nil)
    }
    
    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        print("taskIsWaitingForConnectivity")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Swift.Void) {
        print("willPerformHTTPRedirection")
    }
    
//    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
//        print("didReceive")
//    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Swift.Void) {
        print("needNewBodyStream")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        print("didSendBodyData")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        print("didFinishCollecting")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("didCompleteWithError: \(error)")
    }
}
