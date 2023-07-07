//
//  LoginViewController.swift
//  FitNotes
//
//  Created by Artem Marhaza on 07/07/2023.
//

import UIKit

class LoginViewController: UIViewController {

    typealias CustomValidation = CustomTextField.CustomValidation

    let imageView = UIImageView(image: UIImage(named: "runner"))
    let emailTextField = CustomTextField(placeholderText: "Email Address", fieldHeight: 50)
    let passwordTextField = CustomTextField(placeholderText: "Password", fieldHeight: 50, isPassword: true)

    let loginButton = UIButton(type: .custom)
    let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        layout()
        setupTextFields()
        setupDismissKeyboardGesture()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        imageView.layer.cornerRadius = imageView.frame.size.height / 2
    }

    private func style() {
        view.backgroundColor = Resources.Color.lavender

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Log In", for: .normal)
        loginButton.setTitleColor(Resources.Color.beige, for: .normal)
        loginButton.backgroundColor = Resources.Color.darkBlue
        loginButton.layer.cornerRadius = Resources.buttonHeight * Resources.cornerRadiusCoefficient
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.axis = .vertical
    }

    private func layout() {
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(loginButton)
        view.addSubview(imageView)
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor,
                                           multiplier: 4),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            stackView.topAnchor.constraint(equalToSystemSpacingBelow: imageView.bottomAnchor, multiplier: 4),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 4),

            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupTextFields() {
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
    }

    private func setupDismissKeyboardGesture() {
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(dismissKeyboardTap)
    }
}

extension LoginViewController: CustomTextFieldDelegate {
    func editingDidEnd(_ sender: CustomTextField) {
        _ = sender.validate()
    }
}

// MARK: Actions
extension LoginViewController {
    @objc func viewTapped() {
        view.endEditing(true)
    }

    @objc func loginTapped() {
        // TODO: add login logic
    }
}
