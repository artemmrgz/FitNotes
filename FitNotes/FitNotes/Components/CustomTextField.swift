//
//  CustomTextField.swift
//  FitNotes
//
//  Created by Artem Marhaza on 06/07/2023.
//

import UIKit

protocol CustomTextFieldDelegate: AnyObject {
    func editingDidEnd(_ sender: CustomTextField)
}

class CustomTextField: UIView {

    typealias CustomValidation = (_ textValue: String?) -> (Bool, String)?

    let textAndEyeView = UIView()
    let textField = UITextField()
    var eyeButton: UIButton?
    let errorMessageLabel = UILabel()

    let placeholderText: String
    let fieldHeight: CGFloat
    let isPassword: Bool
    var customValidation: CustomValidation?
    weak var delegate: CustomTextFieldDelegate?

    var heightConstraint: NSLayoutConstraint!

    var text: String? {
        get { return textField.text}
        set { textField.text = newValue }
    }

    init(placeholderText: String, fieldHeight: CGFloat, isPassword: Bool = false) {
        self.placeholderText = placeholderText
        self.fieldHeight = fieldHeight
        self.isPassword = isPassword

        super.init(frame: .zero)

        style()
        layout()

        if isPassword {
            addEyeButton()
        } else {
            // text field takes up all the width
            NSLayoutConstraint.activate([
                textField.trailingAnchor.constraint(equalTo: textAndEyeView.trailingAnchor)
            ])
        }
    }

    override var intrinsicContentSize: CGSize {
            return CGSize(width: 400, height: fieldHeight)
        }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func style() {
        translatesAutoresizingMaskIntoConstraints = false

        textAndEyeView.translatesAutoresizingMaskIntoConstraints = false
        textAndEyeView.layer.borderWidth = 1
        textAndEyeView.layer.borderColor = Resources.Color.rosyBrown.cgColor
        textAndEyeView.layer.cornerRadius = fieldHeight * Resources.cornerRadiusCoefficient

        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.keyboardType = .asciiCapable
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText,
                                                            attributes: [NSAttributedString.Key.foregroundColor:
                                                                            UIColor.secondaryLabel])
        textField.setLeftPaddingPoints(16)
        textField.setRightPaddingPoints(16)

        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.text = "Field cannot be empty"
        errorMessageLabel.font = .preferredFont(forTextStyle: .footnote)
        errorMessageLabel.textColor = Resources.Color.darkRed
        errorMessageLabel.adjustsFontSizeToFitWidth = true
        errorMessageLabel.minimumScaleFactor = 0.8
        errorMessageLabel.isHidden = true
    }

    private func layout() {
        textAndEyeView.addSubview(textField)
        addSubview(textAndEyeView)
        addSubview(errorMessageLabel)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: textAndEyeView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: textAndEyeView.leadingAnchor),
            textField.bottomAnchor.constraint(equalTo: textAndEyeView.bottomAnchor),

            errorMessageLabel.topAnchor.constraint(equalTo: textAndEyeView.bottomAnchor, constant: 4),
            errorMessageLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorMessageLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            textAndEyeView.topAnchor.constraint(equalTo: topAnchor),
            textAndEyeView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textAndEyeView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textAndEyeView.heightAnchor.constraint(equalToConstant: fieldHeight)
        ])

        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)

        heightConstraint = heightAnchor.constraint(equalToConstant: fieldHeight)
        heightConstraint.isActive = true
    }

    private func addEyeButton() {
        eyeButton = UIButton(type: .custom)
        textField.isSecureTextEntry = true

        guard let eyeButton else { return }

        eyeButton.translatesAutoresizingMaskIntoConstraints = false
        eyeButton.setImage(UIImage(systemName: "eye.circle"), for: .normal)
        eyeButton.setImage(UIImage(systemName: "eye.slash.circle"), for: .selected)
        eyeButton.addTarget(self, action: #selector(togglePasswordTextField), for: .touchUpInside)
        eyeButton.tintColor = Resources.Color.darkBlue

        textAndEyeView.addSubview(eyeButton)
        NSLayoutConstraint.activate([
            textAndEyeView.trailingAnchor.constraint(equalToSystemSpacingAfter: eyeButton.trailingAnchor,
                                                     multiplier: 1),
            textAndEyeView.trailingAnchor.constraint(equalToSystemSpacingAfter: textField.trailingAnchor,
                                                     multiplier: 4),
            eyeButton.centerYAnchor.constraint(equalTo: textAndEyeView.centerYAnchor)
        ])

        eyeButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

    @objc func togglePasswordTextField() {
        guard let eyeButton else { return }

        textField.isSecureTextEntry.toggle()
        eyeButton.isSelected.toggle()
    }

    func validate() -> Bool {
        if let customValidation = customValidation,
           let customValidationResult = customValidation(text),
           customValidationResult.0 == false {
            showError(customValidationResult.1)
            return false
        }

        clearError()
        return true
    }

    private func showError(_ errorMessage: String) {
        errorMessageLabel.text = errorMessage
        errorMessageLabel.isHidden = false
        textAndEyeView.layer.borderColor = Resources.Color.darkRed.cgColor

        heightConstraint.constant = fieldHeight + 16
    }

    private func clearError() {
        errorMessageLabel.text = ""
        errorMessageLabel.isHidden = true

        textAndEyeView.layer.borderColor = Resources.Color.darkBlue.cgColor
        textField.textColor = Resources.Color.darkBlue

        heightConstraint.constant = fieldHeight
    }
}

extension CustomTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.endEditing(true)
            return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.editingDidEnd(self)
    }
}
