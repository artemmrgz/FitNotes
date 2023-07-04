//
//  AddSetViewController.swift
//  FitNotes
//
//  Created by Artem Marhaza on 02/07/2023.
//

import UIKit

class AddSetViewController: UIViewController {
    
    let exerciseVM = ExerciseViewModel.shared()
    
    let repsView = ParameterView(name: "Number of Repetitions")
    let weightView = ParameterView(name: "Weight")
    let errorLabel = UILabel()
    let errorView = UIView()
    let addButton = UIButton(type: .custom)
    
    let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Set"
        
        repsView.callback = { self.exerciseVM.reps = $0 }
        weightView.callback = { self.exerciseVM.weight = $0 }
        
        setupNavBar()
        style()
        layout()
        hideKeyboardWhenTappedAround()
    }
    
    private func setupNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: Resources.Color.darkBlue]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.leftBarButtonItem?.tintColor = Resources.Color.mediumPurple
    }
    
    private func style() {
        view.backgroundColor = Resources.Color.lavender
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.layer.cornerRadius = Resources.buttonHeight * Resources.cornerRadiusCoefficient
        stackView.clipsToBounds = true
        stackView.backgroundColor = Resources.Color.mediumPurple
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.text = "Repetition field cannot be empty"
        errorLabel.textColor = Resources.Color.darkRed
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        addButton.backgroundColor = Resources.Color.darkBlue
        addButton.setTitle("Add", for: .normal)
        addButton.setTitleColor(Resources.Color.beige, for: .normal)
        addButton.layer.cornerRadius = Resources.buttonHeight * Resources.cornerRadiusCoefficient
        
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorView.isHidden = true
    }
    
    private func layout() {
        errorView.addSubview(errorLabel)
        
        stackView.addArrangedSubview(repsView)
        stackView.addArrangedSubview(errorView)
        stackView.addArrangedSubview(weightView)
        
        view.addSubview(stackView)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            repsView.heightAnchor.constraint(equalToConstant: Resources.buttonHeight),
            weightView.heightAnchor.constraint(equalToConstant: Resources.buttonHeight),
            
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            errorLabel.leadingAnchor.constraint(equalTo: errorView.leadingAnchor, constant: 16),
            errorLabel.topAnchor.constraint(equalTo: errorView.topAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: errorView.bottomAnchor),
            
            addButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            addButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            addButton.heightAnchor.constraint(equalToConstant: Resources.buttonHeight)
        ])
    }
    
    @objc func addTapped() {
        guard exerciseVM.reps != nil else {
            errorView.isHidden = false
            repsView.showError()
            return
        }
        
        exerciseVM.addNewSet()
        dismiss(animated: true)
    }
    
    @objc func cancelTapped() {
        dismiss(animated: true)
    }
}
