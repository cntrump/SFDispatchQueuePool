# SFDispatchQueuePool [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

a simple thread pool.

support iOS and macOS.

very simple

```swift
for i in 0...1000 {
  SFDispatchQueuePool.shared.async {
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
```
