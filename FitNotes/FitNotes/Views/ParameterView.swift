//
//  ParameterView.swift
//  FitNotes
//
//  Created by Artem Marhaza on 02/07/2023.
//

import UIKit

class ParameterView: UIView {
    
    private let nameLabel = UILabel()
    private let inputTextField = UITextField()
    
    var callback: (Int) -> Void = { _ in }
    
    init(name: String) {
        super.init(frame: .zero)
        
        nameLabel.text = name
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        inputTextField.layer.cornerRadius = inputTextField.frame.height * Resources.cornerRadiusCoefficient
    }
    
    private func setup() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 0
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        nameLabel.textColor = Resources.Color.beige
        
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.layer.borderColor = Resources.Color.lavender.cgColor
        inputTextField.layer.borderWidth = 1
        inputTextField.setLeftPaddingPoints(8)
        inputTextField.textColor = Resources.Color.beige
        inputTextField.delegate = self
        inputTextField.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        inputTextField.textAlignment = .center
        
        addSubview(nameLabel)
        addSubview(inputTextField)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: inputTextField.leadingAnchor, constant: -8),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            inputTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            inputTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2, constant: -8),
            inputTextField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func showError() {
        inputTextField.layer.borderColor = Resources.Color.darkRed.cgColor
    }
}

extension ParameterView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string))
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, let asNumber = Int(text) else { return }
        
        callback(asNumber)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        inputTextField.layer.borderColor = Resources.Color.lavender.cgColor
    }
}
