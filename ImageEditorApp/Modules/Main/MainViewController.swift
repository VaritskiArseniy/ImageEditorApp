//
//  ViewController.swift
//  ImageEditorApp
//
//  Created by Арсений Варицкий on 22.09.24.
//

import UIKit
import SnapKit

protocol MainViewControllerInterface: AnyObject { }

class MainViewController: UIViewController {
    
    private var viewModel: MainViewModel
    
    private enum Constants {
        static var backgroundColor = { R.color.cF7F7F7() }
        static var emptyImage = { UIImage(systemName: "photo") }
        static var addImage = { R.image.addImage() }
        static var titleText = { "Main" }
        static var saveText = { "Save" }
        static var saveTitle = { "Saved" }
        static var saveMessage = { "Image saved in your galary" }
        static var cancelText = { "Cancel" }
        static var chooseText = { "Select source" }
        static var cameraText = { "Camera" }
        static var galaryText = { "From Photos" }
        static var okText = { "OK" }
        static var errorText = { "Error" }
        static var switchText = { "Origin/BW" }
        static var saveErrorText = { "Empty" }
        static var saveErrorMesText = { "Нou have not added image" }
    }
    
    private var originalCenter: CGPoint?
    private var originalImage: UIImage?
    
    private lazy var emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = Constants.emptyImage()
        imageView.tintColor = .gray
        return imageView
    }()
    
    private lazy var framedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var imageFrameView: UIView = {
        let frameView = UIView()
        frameView.layer.borderWidth = 2
        frameView.layer.borderColor = UIColor.orange.cgColor
        frameView.clipsToBounds = true
        return frameView
    }()
    
    private lazy var addButton: UIButton = {
       let button = UIButton()
        button.setImage(Constants.addImage(), for: .normal)
        button.addTarget(self, action: #selector(addButtonPress), for: .touchUpInside)
        return button
    }()
    
    private lazy var filterStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var filterSwitch: UISwitch = {
       let switcher = UISwitch()
        switcher.addTarget(self, action: #selector(bwSwitchValueChanged), for: .valueChanged)
        return switcher
    }()
    
    private lazy var switchTitleLabel: UILabel = {
       let label = UILabel()
        label.text = Constants.switchText()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.backgroundColor = Constants.backgroundColor()
        setupNavigationBar()
        addPanGesture()
        addPinchGesture()
        imageFrameView.addSubview(framedImageView)
        filterStackView.addArrangedSubviews([switchTitleLabel, filterSwitch])
        view.addSubviews([imageFrameView, addButton, emptyImageView, filterStackView])
    }
    
    private func setupConstraints() {
        emptyImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().offset(150)
            $0.trailing.equalToSuperview().inset(150)
            $0.height.equalTo(framedImageView.snp.width).dividedBy(1.3)
        }
        
        addButton.snp.makeConstraints {
            $0.size.equalTo(100)
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        imageFrameView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(imageFrameView.snp.width)
        }
        
        framedImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(framedImageView.snp.width).dividedBy(1.3)
        }
        
        filterStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = Constants.titleText()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: Constants.saveText(),
            style: .done,
            target: self,
            action: #selector(saveButtonPress))
    }
    
    @objc
    private func addButtonPress() {
        let alertController = UIAlertController(
            title: Constants.chooseText(),
            message: nil,
            preferredStyle: .actionSheet
        )
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: Constants.cameraText(), style: .default) {_ in
                self.presentImagePicker(sourceType: .camera)
            }
            alertController.addAction(cameraAction)
        }
        
        let galeryAction = UIAlertAction(title: Constants.galaryText(), style: .default) { _ in
            self.presentImagePicker(sourceType: .photoLibrary)
        }
        alertController.addAction(galeryAction)
        
        let cancelAction = UIAlertAction(title: Constants.cancelText(), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true)
    }
    
    @objc
    private func saveButtonPress() {
        if framedImageView.image == nil {
            let alertController = UIAlertController(
                title: Constants.saveErrorText(),
                message: Constants.saveErrorMesText(),
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: Constants.okText(), style: .cancel, handler: nil)
            alertController.addAction(okAction)
            
            present(alertController, animated: true)
            return
        }
        guard let savingImage = captureImageFromView() else { return }
        UIImageWriteToSavedPhotosAlbum(savingImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    private func captureImageFromView() -> UIImage? {
        let inset: CGFloat = 2.0
        let size = CGSize(width: imageFrameView.bounds.width - 2 * inset,
                          height: imageFrameView.bounds.height - 2 * inset)
        
        UIGraphicsBeginImageContextWithOptions(size, imageFrameView.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        
        if let context = UIGraphicsGetCurrentContext() {
            context.translateBy(x: -inset, y: -inset)
            imageFrameView.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
    }
    
    @objc
    private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer?) {
        if let error = error {
            let alertController = UIAlertController(
                title: Constants.errorText(),
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: Constants.okText(), style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true)
        } else {
            let alertController = UIAlertController(
                title: Constants.saveTitle(),
                message: Constants.saveMessage(),
                preferredStyle: .alert
            )
            
            let cancelAction = UIAlertAction(title: Constants.okText(), style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            if let originalCenter = originalCenter {
                UIView.animate(withDuration: 0.3) {
                    self.framedImageView.center = originalCenter
                }
            }
            present(alertController, animated: true)
        }
    }
    
    private func addPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        framedImageView.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: imageFrameView)
        gesture.view?.center.x += translation.x
        gesture.view?.center.y += translation.y
        gesture.setTranslation(.zero, in: imageFrameView)
    }
    
    private func addPinchGesture() {
        let pitchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePitchGesture(_:)))
        framedImageView.addGestureRecognizer(pitchGesture)
    }
    
    @objc
    private func handlePitchGesture(_ gesture: UIPinchGestureRecognizer) {
        guard let view = gesture.view else { return }
        view.transform = view.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1
    }
    
    @objc private func bwSwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            framedImageView.image = framedImageView.image?.blackAndWhite()
        } else {
            framedImageView.image = originalImage
        }
    }
    
    @objc private func resetImageView() {
        framedImageView.removeFromSuperview()
        framedImageView.contentMode = .scaleAspectFill
        framedImageView.isUserInteractionEnabled = true
        framedImageView.transform = .identity

        addPanGesture()
        addPinchGesture()

        imageFrameView.addSubview(framedImageView)
        setupConstraints()
    }
}

extension MainViewController: MainViewControllerInterface { }

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        else { return }

        emptyImageView.isHidden = true
        originalImage = image

        resetImageView()
        framedImageView.image = image
        filterSwitch.isOn = false
    }
}
