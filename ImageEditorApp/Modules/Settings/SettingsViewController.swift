//
//  SettingsViewController.swift
//  ImageEditorApp
//
//  Created by Арсений Варицкий on 23.09.24.
//

import Foundation
import UIKit

protocol SettingsViewControllerInterface: AnyObject { }

class SettingsViewController: UIViewController {
    
    private var viewModel: SettingsViewModel
    
    private enum Constants {
        static var backgroundColor = { R.color.cF7F7F7() }
        static var titleText = { "Settings" }
        static var cellIdentifier = { "cellIdentifier" }
        static var cellHeight = { CGFloat(44) }
        static var aboutTitleText = { "About us" }
        static var aboutMessageText = { "Developed by Arseniy Varitski" }
        static var okText = { "OK" }
    }
    
    private lazy var tableView: UITableView = {
         let tableView = UITableView(frame: .zero, style: .grouped)
         tableView.backgroundColor = .clear
         tableView.delegate = self
         tableView.dataSource = self
        tableView.register(ProfileCellView.self, forCellReuseIdentifier: Constants.cellIdentifier())
         return tableView
     }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.backgroundColor = Constants.backgroundColor()
        setupNavigationBar()
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = Constants.titleText()
    }
    
    private func aboutCellViewTap() {
        let alertController = UIAlertController(
            title: Constants.aboutTitleText(),
            message: Constants.aboutMessageText(),
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: Constants.okText(), style: .cancel)
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.cellIdentifier(),
            for: indexPath
        ) as? ProfileCellView else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
        case 0:
            cell.configure(type: .about)
            
        default:
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            aboutCellViewTap()
            
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .zero
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
}

extension SettingsViewController: SettingsViewControllerInterface { }
