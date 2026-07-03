//
//  ChatFileDownloader.swift
//  DKImagePickerController
//
//  Created by Saksham Gupta on 03/10/23.
//

import Foundation

class ChatFileDownloader {
    static func enqueue(documentURL: URL, fileName: String?) {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documentsDirectory.appendingPathComponent(fileName ?? documentURL.lastPathComponent)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        var request = URLRequest(url: documentURL)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    if let data = data {
                        try? data.write(to: destinationURL)
                    } else {
                        print("Error while downloading file: \(error)")
                    }
                }
            }
        })
        task.resume()
    }
}
