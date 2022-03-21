//
//  ViewController.swift
//  ExNotificationView
//
//  Created by Jake.K on 2022/03/21.
//

import UIKit

class ViewController: UIViewController {
  private lazy var notiButton: UIButton = {
    let button = UIButton()
    button.setTitle("노티 전송", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    button.setTitleColor(.blue, for: .highlighted)
    button.addTarget(self, action: #selector(didTapNotiButton), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(button)
    return button
  }()
  private lazy var cancelButton: UIButton = {
    let button = UIButton()
    button.setTitle("취소", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    button.setTitleColor(.blue, for: .highlighted)
    button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(button)
    return button
  }()
  
  private var notificationService: NotificationService?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.notificationService = NotificationServiceImpl()
    
    self.view.backgroundColor = .white
    
    NSLayoutConstraint.activate([
      self.notiButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
      self.notiButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
    ])
    NSLayoutConstraint.activate([
      self.cancelButton.topAnchor.constraint(equalTo: self.notiButton.bottomAnchor, constant: 16),
      self.cancelButton.centerXAnchor.constraint(equalTo: self.notiButton.centerXAnchor),
    ])
  }
  
  @objc private func didTapNotiButton() {
    self.notificationService?.show(title: "iOS앱 개발 알아가기", delay: 1) {
      print("노티 완료")
    }
  }
  
  @objc private func didTapCancelButton() {
    self.notificationService?.cancel()
  }
}

