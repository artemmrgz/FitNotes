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

    let loginButton = LoadingButton()
    let stackView = UIStackView()

    let loginVM = LoginViewModel()

    var isValidFields: [CustomTextField: Bool]!

    override func viewDidLoad() {
        super.viewDidLoad()

        populateFieldsToCheck()
        setupNavBar()
        style()
        layout()
        setupBinders()
        setupTextFields()
        setupDismissKeyboardGesture()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        imageView.layer.cornerRadius = imageView.frame.size.height / 2
    }

    private func populateFieldsToCheck() {
        isValidFields = [
            emailTextField: false,
            passwordTextField: false
        ]
    }

    private func setupNavBar() {
        title = "Log In"

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .plain,
                                                            target: self, action: #selector(registerBtnTapped))

        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: Resources.Color.beige]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.tintColor = Resources.Color.mediumPurple
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

    private func setupBinders() {
        loginVM.error.bind { [weak self] loginErr in
            guard let self, let loginErr else {
                NotificationCenter.default.post(name: .login, object: nil)
                return }

            self.present(loginErr, animated: true)
        }
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
        isValidFields[sender] = sender.validate()
    }
}

// MARK: Actions
extension LoginViewController {
    @objc func viewTapped() {
        view.endEditing(true)
    }

    @objc func loginTapped() {
        let notValid = isValidFields.filter { !$0.value }

        guard notValid.isEmpty,
              let email = emailTextField.text,
              let password = passwordTextField.text else { return }

        loginVM.signInUser(email: email, password: password)
    }

    @objc func registerBtnTapped() {
        navigationController?.pushViewController(RegistrationViewController(), animated: true)
    }
}
