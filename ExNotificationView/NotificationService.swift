//
//  NotificationService.swift
//  ExNotificationView
//
//  Created by Jake.K on 2022/03/21.
//

import UIKit

protocol NotificationService {
  func show(title: String, delay: UInt32, completion: @escaping () -> Void)
  func cancel()
  func suspend(enabled: Bool)
}

final class NotificationServiceImpl: NotificationService {
  private let operationQueue = OperationQueue()
  
  func show(title: String, delay: UInt32, completion: @escaping () -> Void) {
    let operation = NotificationOperation(title: title, delay: delay, completion: completion)
    self.operationQueue.addOperation(operation)
  }
  func cancel() {
    self.operationQueue.cancelAllOperations()
  }
  func suspend(enabled: Bool) {
    self.operationQueue.isSuspended = !enabled
  }
}

private class NotificationOperation: Operation {
  private let title: String
  private let delay: UInt32
  private let completion: () -> Void
  
  init(title: String, delay: UInt32, completion: @escaping () -> Void) {
    self.title = title
    self.delay = delay
    self.completion = completion
  }
  
  override func main() {
    sleep(self.delay)
    
    DispatchQueue.main.async {
      let notificationView = NotificationView(title: self.title)
      notificationView.alpha = 0
      notificationView.translatesAutoresizingMaskIntoConstraints = false
      guard let window = UIApplication.shared.windows.first else { return }
      
      window.addSubview(notificationView)
      NSLayoutConstraint.activate([
        notificationView.leftAnchor.constraint(equalTo: window.safeAreaLayoutGuide.leftAnchor),
        notificationView.rightAnchor.constraint(equalTo: window.safeAreaLayoutGuide.rightAnchor),
        notificationView.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor),
        notificationView.heightAnchor.constraint(equalToConstant: 80)
      ])
      
      UIView.animate(
        withDuration: 1,
        delay: 0,
        options: .curveEaseOut,
        animations: { notificationView.alpha = 1 },
        completion: { _ in
          
          UIView.animate(
            withDuration: 1,
            delay: 1,
            options: .curveEaseIn,
            animations: { notificationView.alpha = 0 },
            completion: { _ in
              notificationView.removeFromSuperview()
              if !self.isCancelled {
                self.completion()
              }
            }
          )
        }
      )
    }
  }
}

private class NotificationView: UIView {
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 22)
    label.numberOfLines = 2
    label.lineBreakMode = .byTruncatingTail
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(label)
    return label
  }()
  
  init(title: String) {
    super.init(frame: .zero)
    self.backgroundColor = .systemGray3
    self.titleLabel.text = title
    NSLayoutConstraint.activate([
      self.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor, constant: 12),
      self.rightAnchor.constraint(equalTo: self.titleLabel.rightAnchor, constant: -12),
      self.bottomAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: -12),
      self.topAnchor.constraint(equalTo: self.titleLabel.topAnchor, constant: 12),
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
