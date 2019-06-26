//
//  SFDispatchQueuePool.swift
//  SFDispatchQueuePool
//
//  Created by vvveiii on 2019/6/3.
//  Copyright © 2019 lvv. All rights reserved.
//

import Foundation

public class SFDispatchQueuePool : NSObject {
    private lazy var executionQueue = DispatchQueue(label: "queue.exec.SFDispatchQueuePool", attributes: .concurrent)
    private lazy var waitingQueue = DispatchQueue(label: "queue.wait.SFDispatchQueuePool")
    private var maximumQueueSemaphore: DispatchSemaphore!

    @objc public class func pool() -> Self {
        return self.init()
    }

    @objc public required override init() {
        super.init()
        maximumQueueSemaphore = DispatchSemaphore(value: max(ProcessInfo.processInfo.processorCount * 2, 4))
    }

    @objc public required init(value: Int) {
        super.init()
        maximumQueueSemaphore = DispatchSemaphore(value: max(1, value))
    }

    @objc(asyncExecute:)
    public func async(execute work: @escaping @convention(block) () -> Void) {
        waitingQueue.async { [weak self] in
            self?.maximumQueueSemaphore.wait()
            self?.executionQueue.async {
                work()
                self?.maximumQueueSemaphore.signal()
            }
        }
    }
}
