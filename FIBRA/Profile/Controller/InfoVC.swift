//
//  InfoVC.swift
//  FIBRA
//
//  Created by Muhammad Hassan Ilyas on 28/11/2020.
//

import UIKit
import MobileCoreServices
import SVProgressHUD

class InfoVC: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var phoneNoTF: UITextField!
    @IBOutlet weak var emailAdressTF: UITextField!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var mobileNoLabel: UILabel!
    
    @IBOutlet weak var btnBackGroundColorView: UIView!
    @IBOutlet weak var btnSaveChanges: UIButton!
    
    @IBOutlet weak var nameErrorView: UIView!
    @IBOutlet weak var mobileNoErrorView: UIView!

    @IBOutlet weak var nameErrorLineView: UIView!
    @IBOutlet weak var mobileNoErrorLineView: UIView!

    @IBOutlet weak var apiErrorView: UIView!
    @IBOutlet weak var apiErrorLabel: UILabel!


    
    var selectedAttachment: (name: String, extension: String, data: Data)!
    var viewModel: UpdateProfileViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.apiErrorView.isHidden = true
        self.nameLabel.isHidden = true
        self.emailAddressLabel.isHidden = true
        self.mobileNoLabel.isHidden = true
        self.btnSaveChanges.isEnabled = false
        
        self.btnBackGroundColorView.isHidden = true

        self.nameErrorView.isHidden = true
        self.mobileNoErrorView.isHidden = true
        viewModel = UpdateProfileViewModel(delegate: self, viewController: self)
        setData()
        self.userNameTF.addTarget(self, action: #selector(ChangePasswordVC.textFieldDidChange(_:)), for: .editingChanged)
        self.phoneNoTF.addTarget(self, action: #selector(ChangePasswordVC.textFieldDidChange(_:)), for: .editingChanged)
        self.emailAdressTF.addTarget(self, action: #selector(ChangePasswordVC.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == self.userNameTF{
            if textField.text != ""{
                self.nameLabel.isHidden = false
            }else{
                self.nameLabel.isHidden = true
            }
        }else if textField == self.phoneNoTF{
            if textField.text != ""{
                self.mobileNoLabel.isHidden = false
            }else{
                self.mobileNoLabel.isHidden = true
            }
        }
        else {
            if textField.text != ""{
                self.emailAddressLabel.isHidden = false
            }else{
                self.emailAddressLabel.isHidden = true
            }
        }
        if self.userNameTF.text != "" && self.phoneNoTF.text != "" && self.emailAdressTF.text != "" {
            self.btnBackGroundColorView.isHidden = false
            self.btnSaveChanges.backgroundColor = UIColor.clear
            self.btnSaveChanges.isEnabled = true

        }else{
            self.btnBackGroundColorView.isHidden = true
            self.btnSaveChanges.backgroundColor = UIColor.lightGray
            self.btnSaveChanges.isEnabled = false

        }
    }
    
    @IBAction func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onEditPhoto(_ sender: UIButton) {
//        let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { (action) in
//            self.chooseFromLibrary(presentFrom: sender)
//        }))
//        alert.addAction(UIAlertAction(title: "Capture", style: .default, handler: { (action) in
//            self.capturePhoto(presentFrom: sender)
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: .none))
//        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onDeletePhoto(_ sender: UIButton) {
        profileImageView.image = UIImage.init(named: "profileGreen")
//        selectedAttachment = nil
//        updateProfile()
        
    }
    
    @IBAction func onSaveChangings(_ sender: UIButton) {
        if isValidInput(){//self.userNameTF.isValidInput() && self.phoneNoTF.isValidInput() {
            SVProgressHUD.show()
            updateProfile()
        }
    }
    func updateProfile(){
        let param: [String: Any] = [
            "fullName": userNameTF.text ?? "",
            "phone": phoneNoTF.text ?? "",
            "address": "-",
        ]
        self.view.isUserInteractionEnabled = false

        viewModel.updateProfile(with: param, selectedImage: UIImage.init())
    }
}

extension InfoVC: UpdateProfileViewModelDelegate {
    func onFaild(with error: String) {
        SVProgressHUD.dismiss()
        self.view.isUserInteractionEnabled = true

        if error.count < 50{
            self.apiErrorLabel.text = "\(error)"
            self.apiErrorView.isHidden = false
        }else{
            self.apiErrorLabel.text = "Server is not responding, try again"
            self.apiErrorView.isHidden = false
        }
//        self.showAlertView(title: Constants.kErrorMessage, message: error)
    }
    
    func onSuccess() {
        SVProgressHUD.dismiss()
        self.apiErrorView.isHidden = true
        self.view.isUserInteractionEnabled = true
        LoginData.shared.fullName = userNameTF.text ?? ""
        LoginData.shared.phone = phoneNoTF.text ?? ""
        LoginData.shared.address = ""
        LoginData.shared.profileUrl = ""//Global.shared.profileUrl
        LoginData.shared.saveData()
        Global.shared.updatedStatus = true
//        self.showAlertView(title: Constants.kSuccessMessage, message: "Profile updated successfully.", successTitle: "OK", successCallback: {
            self.navigationController?.popViewController(animated: true)
//        })
    }
}

extension InfoVC {
    func setData() {
        userNameTF.text = LoginData.shared.fullName
        phoneNoTF.text = LoginData.shared.phone
        emailAdressTF.text = LoginData.shared.authDict.email
        if userNameTF.text != ""{
            self.nameLabel.isHidden = false
        }
        if phoneNoTF.text != ""{
            self.mobileNoLabel.isHidden = false
        }
        if emailAdressTF.text != ""{
            self.emailAddressLabel.isHidden = false
        }
//        if LoginData.shared.profileUrl != ""{
//            let url = URL.init(string: WebManager.shared.baseUrl+LoginData.shared.profileUrl)
//            self.profileImageView.kf.indicatorType = .activity
//            self.profileImageView.kf.setImage(with: url)
//        }else{
//            profileImageView.image = UIImage.init(named: "profileGreen")
//        }
    }
}

extension InfoVC {
    func isValidInput() -> Bool {
        var isError = true
        if !userNameTF.isValidInput() {
            self.nameErrorView.isHidden = false
            self.nameErrorLineView.backgroundColor = UIColor.init(hexString: "#D0021B")
            self.nameLabel.textColor = UIColor.init(hexString: "#D0021B")

//            self.showAlertView(title: "Error", message: "Please enter userName")
            isError = false
        }else{
            self.nameErrorView.isHidden = true
            self.nameErrorLineView.backgroundColor = UIColor.init(hexString: "#D2D2D2")


        }
        if !phoneNoTF.isValidInput(){
            self.mobileNoLabel.textColor = UIColor.init(hexString: "#D0021B")

            self.mobileNoErrorLineView.backgroundColor = UIColor.init(hexString: "#D0021B")
            self.mobileNoErrorView.isHidden = false
            isError = false
        }else{
            self.mobileNoErrorView.isHidden = true
            self.mobileNoErrorLineView.backgroundColor = UIColor.init(hexString: "#D2D2D2")
        }
        return isError
    }
}


extension InfoVC {
    
    func chooseFromLibrary(presentFrom sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.modalPresentationStyle = .formSheet
        present(imagePicker, animated: true, completion: nil)
    }
    
    func capturePhoto(presentFrom sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .formSheet
        present(imagePicker, animated: true, completion: nil)
    }
}

extension InfoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            if let imageData = image.jpegData(compressionQuality: 0.1) {
                profileImageView.image = image
                selectedAttachment = (name: UUID().uuidString, extension: "jpg", data: imageData)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
