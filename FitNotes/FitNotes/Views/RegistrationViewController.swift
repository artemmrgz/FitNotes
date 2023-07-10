//
//  RegistrationViewController.swift
//  FitNotes
//
//  Created by Artem Marhaza on 07/07/2023.
//

import UIKit

class RegistrationViewController: UIViewController {

    typealias CustomValidation = CustomTextField.CustomValidation

    let imageView = UIImageView(image: UIImage(named: "runner"))
    let nameTextField = CustomTextField(placeholderText: "First Name", fieldHeight: 50)
    let emailTextField = CustomTextField(placeholderText: "Email Address", fieldHeight: 50)
    let passwordTextField = CustomTextField(placeholderText: "Password", fieldHeight: 50, isPassword: true)
    let repeatPasswordTextField = CustomTextField(placeholderText: "Re-enter Password", fieldHeight: 50,
                                                  isPassword: true)

    let registerButton = LoadingButton()
    let stackView = UIStackView()
    let successLabel = SuccessLabel(withText: "Profile has been registered")

    var isValidFields: [CustomTextField: Bool]!
    let registrationVM = RegistrationViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Create Account"

        populateFieldsToCheck()
        style()
        layout()
        setupBindings()
        setupTextFields()
        setupDismissKeyboardGesture()
        setupKeyboardHiding()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        imageView.layer.cornerRadius = imageView.frame.size.height / 2
    }

    private func populateFieldsToCheck() {
        isValidFields = [
            nameTextField: false,
            emailTextField: false,
            passwordTextField: false,
            repeatPasswordTextField: false
        ]
    }

    private func style() {
        view.backgroundColor = Resources.Color.lavender

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(Resources.Color.beige, for: .normal)
        registerButton.backgroundColor = Resources.Color.darkBlue
        registerButton.layer.cornerRadius = Resources.buttonHeight * Resources.cornerRadiusCoefficient
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.axis = .vertical
    }

    private func layout() {
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(repeatPasswordTextField)
        stackView.addArrangedSubview(registerButton)
        view.addSubview(imageView)
        view.addSubview(stackView)

        successLabel.layout(onView: self.view)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor,
                                           multiplier: 4),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            stackView.topAnchor.constraint(equalToSystemSpacingBelow: imageView.bottomAnchor, multiplier: 4),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 4),

            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupBindings() {
        registrationVM.error.bind { [weak self] userErr in
            guard let self, let userErr else { return }

            self.present(userErr, animated: true)
        }

        registrationVM.didRegister.bind { [weak self] success in
            guard let self, success else { return }

            self.registerButton.hideLoading()
            self.view.layoutIfNeeded()
            self.successLabel.showFromBottom(toYCoordinate: self.view.bounds.height - 32 - Resources.buttonHeight)
            NotificationCenter.default.post(name: .login, object: nil)
        }
    }

    private func setupTextFields() {
        let nameValidation: CustomValidation = { text in
            guard let text = text, !text.isEmpty else {
                return (false, "Enter your name")
            }
            return (true, "")
        }
        nameTextField.customValidation = nameValidation
        nameTextField.delegate = self

        let emailValidation: CustomValidation = { text in
            guard let text = text, !text.isEmpty else {
                return (false, "Enter your email address")
            }

            guard NSPredicate(format: "SELF MATCHES %@",
                              "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: text) else {
                return (false, "Enter a valid email address")
            }
            return (true, "")
        }
        emailTextField.customValidation = emailValidation
        emailTextField.delegate = self

        let passwordValidation: CustomValidation = { text in
            guard let text = text, !text.isEmpty else {
                return (false, "Enter your password")
            }

            guard text.count >= 8 && text.count <= 32 else {
                return (false, "Password should be 8-32 characters long")
            }

            // Invalid characters
            let validChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,@:?!()$\\/#"
            let invalidSet = CharacterSet(charactersIn: validChars).inverted
            guard text.rangeOfCharacter(from: invalidSet) == nil else {
                return (false, "Enter valid special characters (.,@:?!()$\\/#) with no spaces")
            }
            return (true, "")
        }
        passwordTextField.customValidation = passwordValidation
        passwordTextField.delegate = self

        let repeatPasswordValidation: CustomValidation = { text in
            guard let text = text, !text.isEmpty else {
                return (false, "Enter your password")
            }

            guard text == self.passwordTextField.text else {
                return (false, "Password does not match")
            }
            return (true, "")
        }
        repeatPasswordTextField.customValidation = repeatPasswordValidation
        repeatPasswordTextField.delegate = self
    }

    private func setupDismissKeyboardGesture() {
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(dismissKeyboardTap)
    }

    private func setupKeyboardHiding() {
        let notificationCenter = NotificationCenter.default

        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow),
                                       name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide),
                                       name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension RegistrationViewController: CustomTextFieldDelegate {
    func editingDidEnd(_ sender: CustomTextField) {
        isValidFields[sender] = sender.validate()
    }
}

// MARK: Actions
extension RegistrationViewController {
    @objc func viewTapped() {
        view.endEditing(true)
    }

    @objc func keyboardWillShow(sender: NSNotification) {
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let currentTextField = UIResponder.currentFirst() as? UITextField else { return }

        // check if the top of the keyboard is above the bottom of the currently focused textbox
        let keyboardTopY = keyboardFrame.cgRectValue.origin.y

        let convertedTextFieldFrame = view.convert(currentTextField.frame, from: currentTextField.superview)

        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height
        if textFieldBottomY > keyboardTopY {

            let textBoxY = convertedTextFieldFrame.origin.y
            let newFrameY = (textBoxY - keyboardTopY / 2) * -1
            view.frame.origin.y = newFrameY
        }
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        view.frame.origin.y = 0
    }

    @objc func registerTapped() {
        let notValid = isValidFields.filter { !$0.value }

        guard notValid.isEmpty,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let name = nameTextField.text else { return }

        registrationVM.registerUser(email: email, password: password, name: name)
        registerButton.showLoading()
    }
}
