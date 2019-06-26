//
//  ViewController.swift
//  example
//
//  Created by vvveiii on 2019/6/3.
//  Copyright © 2019 lvv. All rights reserved.
//

import UIKit
import SFDispatchQueuePool

class ViewController: UIViewController {
    let session = URLSession(configuration: .default)
    let sharedPool = SFDispatchQueuePool.pool()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        for i in 0...1000 {
            sharedPool.async {
                NSLog("task: \(i), enter queue")

                let lock = DispatchSemaphore(value: 0)
                let task = URLSession.shared.dataTask(with: URL(string: "https://github.com")!) {data, response, error in
                    NSLog("task: \(i), error: \(String(describing: error))")

                    lock.signal()
                }

                task.resume()
                lock.wait()
                
                NSLog("task: \(i), quit queue")
            }
        }
    }
}

