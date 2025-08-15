//
//  NetworkManager.swift
//  Rajat_kasliwal_Stock_Demo
//
//  Created by Rajat Kasliwal on 15/08/25.
//

import Foundation

protocol NetworkRequestProtocol {
    var requestURLString: String { get }
}

protocol NetworkManagerDelegate : AnyObject {
    func didReceiveData(_ data: Data)
    func didFailWithError(_ error: Error)
}

class NetworkManager: NSObject {
    init(delegate: NetworkManagerDelegate?) {
        self.delegate = delegate
        super.init()
    }
    
    private var session: URLSession?
    private weak var delegate: NetworkManagerDelegate?
//    let urlFor =  "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/"
    func hitNetwork(for request: NetworkRequestProtocol) {
        
        guard let url = URL(string: request.requestURLString) else {
            print("Invalid URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        if session == nil {
            session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        }
        
        executeRequest(urlRequest)
        
    }
    
    func executeRequest(_ request: URLRequest) {
        let task = session?.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self, let data = data else { return }
            print("Received data: \(data)")
            delegate?.didReceiveData(data)

        }
        
        if let task = task {
            task.resume()
        } else {
            //TODO: Handle false response
        }
    }
}

extension NetworkManager: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        // Handle received data
        print("Received data: \(data)")
        
        delegate?.didReceiveData(data)
    }
}
