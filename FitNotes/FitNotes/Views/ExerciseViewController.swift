//
//  ExerciseViewController.swift
//  FitNotes
//
//  Created by Artem Marhaza on 27/06/2023.
//

import UIKit

class ExerciseViewController: UIViewController {
    
    let muscleGroupButton = UIButton()
    let nameTextField = UITextField()
    let previouslyCreated = UIButton(type: .custom)
    let addSetButton = UIButton(type: .custom)
    let saveButton = UIButton(type: .custom)
    let setInfoLabel = UILabel()
    let textLabel = UILabel()
    let setsLabel = UILabel()
    
    let clockImageView = UIImageView(image: UIImage(systemName: "clock.arrow.circlepath"))
//    let clockImageView = UIImageView(image: UIImage(systemName: "icloud.and.arrow.down"))
//    let clockImageView = UIImageView(image: UIImage(systemName: "arrow.clockwise.icloud"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Exercise"
        
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: Resources.Color.beige]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = true
        
        hideKeyboardWhenTappedAround()
        
        style()
        layout()
    }
    
    private func style() {
        view.backgroundColor = Resources.Color.mediumPurple
        
        muscleGroupButton.translatesAutoresizingMaskIntoConstraints = false
        muscleGroupButton.setTitle("Muscle Group", for: .normal)
        muscleGroupButton.addTarget(self, action: #selector(muscleGroupTapped), for: .touchUpInside)
        muscleGroupButton.layer.borderColor = Resources.Color.lavender.cgColor
        muscleGroupButton.layer.borderWidth = 1
        muscleGroupButton.layer.cornerRadius = 60 * Resources.cornerRadiusCoefficient
        muscleGroupButton.setTitleColor(Resources.Color.rosyBrown, for: .normal)
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.layer.borderColor = Resources.Color.lavender.cgColor
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.cornerRadius = 60 * Resources.cornerRadiusCoefficient
        nameTextField.setLeftPaddingPoints(16)
        nameTextField.clearButtonMode = .whileEditing
        nameTextField.delegate = self
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Exercise name",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: Resources.Color.rosyBrown])
        nameTextField.textColor = Resources.Color.beige
        
        previouslyCreated.translatesAutoresizingMaskIntoConstraints = false
        previouslyCreated.layer.cornerRadius = 60 * Resources.cornerRadiusCoefficient
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.backgroundColor = Resources.Color.darkBlue
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(Resources.Color.beige, for: .normal)
        saveButton.layer.cornerRadius = 50 * Resources.cornerRadiusCoefficient
        
        clockImageView.translatesAutoresizingMaskIntoConstraints = false
        clockImageView.tintColor = Resources.Color.rosyBrown
        clockImageView.contentMode = .scaleAspectFill
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = .systemFont(ofSize: 9, weight: .bold)
        textLabel.numberOfLines = 0
        textLabel.textColor = Resources.Color.rosyBrown
        textLabel.textAlignment = .center
        textLabel.text = "Choose"
        
        setInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        setInfoLabel.numberOfLines = 0
        setInfoLabel.attributedText = makeAttributedInfo()

        addSetButton.translatesAutoresizingMaskIntoConstraints = false
        addSetButton.setTitle("Add Set", for: .normal)
        addSetButton.setTitleColor(Resources.Color.darkBlue, for: .normal)
        addSetButton.backgroundColor = Resources.Color.rosyBrown
        addSetButton.layer.cornerRadius = 50 * Resources.cornerRadiusCoefficient
        
        setsLabel.translatesAutoresizingMaskIntoConstraints = false
        setsLabel.attributedText = makeAttributedSetLabel(sets: "3", reps: "12", weight: "15")
        setsLabel.textAlignment = .center
    }

    private func layout() {
        view.addSubview(muscleGroupButton)
        view.addSubview(nameTextField)
        view.addSubview(previouslyCreated)
        previouslyCreated.addSubview(clockImageView)
        previouslyCreated.addSubview(textLabel)
        view.addSubview(saveButton)
        view.addSubview(setInfoLabel)
        view.addSubview(addSetButton)
        view.addSubview(setsLabel)
        
        NSLayoutConstraint.activate([
            muscleGroupButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            muscleGroupButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            muscleGroupButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            muscleGroupButton.heightAnchor.constraint(equalToConstant: 60),
            
            nameTextField.topAnchor.constraint(equalTo: muscleGroupButton.bottomAnchor, constant: 16),
            nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            nameTextField.heightAnchor.constraint(equalToConstant: 60),
            nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8, constant: -16),
            
            previouslyCreated.topAnchor.constraint(equalTo: muscleGroupButton.bottomAnchor, constant: 16),
            previouslyCreated.leadingAnchor.constraint(equalTo: nameTextField.trailingAnchor, constant: 8),
            previouslyCreated.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            previouslyCreated.heightAnchor.constraint(equalToConstant: 60),
            previouslyCreated.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2, constant: -8),
            
            saveButton.topAnchor.constraint(equalTo: addSetButton.bottomAnchor, constant: 16),
            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            clockImageView.topAnchor.constraint(equalTo: previouslyCreated.topAnchor, constant: 4),
            clockImageView.widthAnchor.constraint(lessThanOrEqualTo: previouslyCreated.widthAnchor, multiplier: 0.8),
            clockImageView.heightAnchor.constraint(equalTo: clockImageView.widthAnchor),
            clockImageView.centerXAnchor.constraint(equalTo: previouslyCreated.centerXAnchor),
            clockImageView.bottomAnchor.constraint(equalTo: textLabel.topAnchor, constant: -4),
            
            textLabel.topAnchor.constraint(equalTo: clockImageView.bottomAnchor, constant: 4),
            textLabel.leadingAnchor.constraint(equalTo: clockImageView.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: clockImageView.trailingAnchor),
            textLabel.centerXAnchor.constraint(equalTo: previouslyCreated.centerXAnchor),
            textLabel.bottomAnchor.constraint(equalTo: previouslyCreated.bottomAnchor, constant: -4),
            
            setInfoLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
            setInfoLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            setInfoLabel.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            
            addSetButton.topAnchor.constraint(equalTo: setsLabel.bottomAnchor, constant: 48),
            addSetButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            addSetButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            addSetButton.heightAnchor.constraint(equalToConstant: 50),
            
            setsLabel.topAnchor.constraint(equalTo: setInfoLabel.bottomAnchor, constant: 48),
            setsLabel.leadingAnchor.constraint(equalTo: muscleGroupButton.leadingAnchor),
            setsLabel.trailingAnchor.constraint(equalTo: muscleGroupButton.trailingAnchor),
            setsLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc func muscleGroupTapped() {
        let alert = UIAlertController(title: "Muscle Group", message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(createAction(title: "Abs"))
        alert.addAction(createAction(title: "Back"))
        alert.addAction(createAction(title: "Biceps"))
        alert.addAction(createAction(title: "Chest"))
        alert.addAction(createAction(title: "Legs"))
        alert.addAction(createAction(title: "Shoulders"))
        alert.addAction(createAction(title: "Triceps"))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    func createAction(title: String) -> UIAlertAction {
        return UIAlertAction(title: title, style: .default) {_ in
            self.muscleGroupButton.setTitle(title, for: .normal)
            self.muscleGroupButton.backgroundColor = Resources.Color.lavender
            self.muscleGroupButton.setTitleColor(Resources.Color.beige, for: .normal)
        }
    }
    
    func makeAttributedInfo() -> NSMutableAttributedString {
        let title = "Last Workout (11.06.2023)"
        var titleAttrString = [NSAttributedString.Key: Any]()
        titleAttrString[.font] = UIFont.systemFont(ofSize: 12, weight: .bold)
        titleAttrString[.foregroundColor] = Resources.Color.rosyBrown
        
        let text = "3 sets 12 x 12kg"
        var textAttrString = [NSAttributedString.Key: Any]()
        textAttrString[.font] = UIFont.systemFont(ofSize: 12)
        textAttrString[.foregroundColor] = Resources.Color.rosyBrown
        
        let res = NSMutableAttributedString(string: title, attributes: titleAttrString)
        res.append(NSAttributedString(string: "\n"))
        res.append(NSAttributedString(string: text, attributes: textAttrString))
        return res
    }
    
    func makeAttributedNumber(_ string: String) -> NSMutableAttributedString {
        var attrString = [NSAttributedString.Key: Any]()
        attrString[.font] = UIFont.systemFont(ofSize: 32, weight: .heavy)
        attrString[.foregroundColor] = Resources.Color.darkBlue
        
        return NSMutableAttributedString(string: string, attributes: attrString)
    }
    
    func makeAttributedSetLabel(sets: String, reps: String, weight: String?) -> NSMutableAttributedString {
        var attrString = [NSAttributedString.Key: Any]()
        attrString[.font] = UIFont.systemFont(ofSize: 22)
        attrString[.foregroundColor] = Resources.Color.darkBlue
        
        let attrSets = makeAttributedNumber(sets)
        attrSets.append(NSAttributedString(string: " sets ", attributes: attrString))
        attrSets.append(makeAttributedNumber(reps))
        attrSets.append(NSAttributedString(string: " reps", attributes: attrString))
        
        if let weight {
            attrSets.append(NSAttributedString(string: " x ", attributes: attrString))
            attrSets.append(makeAttributedNumber(weight))
            attrSets.append(NSAttributedString(string: "kg", attributes: attrString))
        }
        
        return attrSets
    }
}

// MARK: UITextFieldDelegate
extension ExerciseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return textField.hasText
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        nameTextField.backgroundColor = Resources.Color.lavender
        nameTextField.textColor = Resources.Color.beige
        
        // TODO: handle text
        print(text)
    }
}
