//
//  SettingsTableViewCell.swift
//  ImageEditorApp
//
//  Created by Арсений Варицкий on 24.09.24.
//

import Foundation
import UIKit

class ProfileCellView: UITableViewCell {

    private enum Constants {
        static var arrowImage = { R.image.arrowImage() }
    }

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.arrowImage()
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        contentView.addSubviews([iconImageView, arrowImageView, titleLabel])
    }
    
    private func setupConstraints() {
        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(30)
        }
        
        arrowImageView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
            $0.height.equalToSuperview()
            $0.trailing.equalTo(arrowImageView.snp.leading)
        }
    }
    
    func configure(type: ProfileCellType) {
        iconImageView.image = type.icon
        titleLabel.text = type.label
    }
}
