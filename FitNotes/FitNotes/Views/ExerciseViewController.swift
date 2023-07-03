//
//  ExerciseViewController.swift
//  FitNotes
//
//  Created by Artem Marhaza on 27/06/2023.
//

import UIKit

class ExerciseViewController: UIViewController {
    
    let exerciseVM = ExerciseViewModel.shared()
    let formatter = Formatter()
    
    let muscleGroupButton = UIButton()
    let nameTextField = UITextField()
    let existingExercisesButton = UIButton(type: .custom)
    let clockImageView = UIImageView(image: UIImage(systemName: "clock.arrow.circlepath"))
    //    let clockImageView = UIImageView(image: UIImage(systemName: "icloud.and.arrow.down"))
    //    let clockImageView = UIImageView(image: UIImage(systemName: "arrow.clockwise.icloud"))
    let textLabel = UILabel()
    let exerciseInfoLabel = UILabel()
    let addSetButton = UIButton(type: .custom)
    let repeatSetButton = UIButton(type: .custom)
    let saveButton = UIButton(type: .custom)
    
    let stackView = UIStackView()
    let exerciseStackView = UIStackView()
    let currentSetStackView = UIStackView()
    let buttonsStackView = UIStackView()
    
    let currentSetView = UIView()
    var currentSetsLabels = [UILabel]()
    
    let existingExercisesView: OptionsView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        return OptionsView(effect: blurEffect)
    }()
    
    let musclesGroupsView: OptionsView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        return OptionsView(effect: blurEffect)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Exercise"
        
        setupNavBar()
        setupBinders()
        setupOptionsViews()
        style()
        layout()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let existingExercisesViewInitialFrame = self.view.convert(self.existingExercisesButton.frame, from: self.exerciseStackView)
        existingExercisesView.initialFrame = existingExercisesViewInitialFrame
        
        let musclesGroupsViewInitialFrame = self.view.convert(self.muscleGroupButton.frame, from: self.stackView)
        musclesGroupsView.initialFrame = musclesGroupsViewInitialFrame
    }
    
    private func setupNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: Resources.Color.beige]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupBinders() {
        exerciseVM.exercisesLoaded.bind { [weak self] success in
            guard let self, success else { return }
            
            let dataSource = self.exerciseVM.exercises.map { $0.name }
            self.existingExercisesView.tableDataSource = dataSource
            self.existingExercisesView.show()
            
        }
        
        exerciseVM.newSetAdded.bind { [weak self] success in
            guard let self, !self.exerciseVM.statistics.isEmpty, success else { return }
            
            if !self.currentSetsLabels.isEmpty {
                self.updateLastSetLabel(asActive: false)
            }
            
            self.addNewSetLabel()
            self.updateLastSetLabel()
        }
        
        exerciseVM.setUpdated.bind { [weak self] success in
            guard let self, !self.exerciseVM.statistics.isEmpty, success else { return }
            
            self.updateLastSetLabel()
        }
    }
    
    private func setupOptionsViews() {
        existingExercisesView.translatesAutoresizingMaskIntoConstraints = false
        existingExercisesView.callback = { [weak self] indexPath in
            guard let self else { return }
            let exercise = self.exerciseVM.exercises[indexPath.row]
            self.exerciseVM.exerciseName = exercise.name
            
            self.nameTextField.text = exercise.name
            self.nameTextField.backgroundColor = Resources.Color.lavender
            self.nameTextField.textColor = Resources.Color.darkBlue
            
            self.exerciseInfoLabel.attributedText = self.formatter.makeAttributedExerciseInfo(date: exercise.date, sets: exercise.sets, reps: exercise.repetitions, weight: exercise.weight)
        }
        
        musclesGroupsView.translatesAutoresizingMaskIntoConstraints = false
        let musclesGroupsDataSource = MuscleGroup.allCases.map { $0.rawValue }
        musclesGroupsView.tableDataSource = musclesGroupsDataSource
        musclesGroupsView.callback = { [weak self] indexPath in
            guard let self else { return }
            
            let muscleGroup = musclesGroupsDataSource[indexPath.row]
            self.exerciseVM.muscleGroup = muscleGroup
            
            self.muscleGroupButton.setTitle(muscleGroup, for: .normal)
            self.muscleGroupButton.backgroundColor = Resources.Color.lavender
            self.muscleGroupButton.setTitleColor(Resources.Color.darkBlue, for: .normal)
        }
    }
    
    private func style() {
        view.backgroundColor = Resources.Color.mediumPurple
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        
        exerciseStackView.translatesAutoresizingMaskIntoConstraints = false
        exerciseStackView.spacing = 16
        
        currentSetStackView.translatesAutoresizingMaskIntoConstraints = false
        currentSetStackView.axis = .vertical
        currentSetStackView.spacing = 16
        
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.spacing = 8
        
        muscleGroupButton.translatesAutoresizingMaskIntoConstraints = false
        muscleGroupButton.setTitle("Muscle Group", for: .normal)
        muscleGroupButton.addTarget(self, action: #selector(muscleGroupTapped), for: .touchUpInside)
        muscleGroupButton.layer.borderColor = Resources.Color.lavender.cgColor
        muscleGroupButton.layer.borderWidth = 1
        muscleGroupButton.layer.cornerRadius = Resources.buttonHeight * Resources.cornerRadiusCoefficient
        muscleGroupButton.setTitleColor(Resources.Color.rosyBrown, for: .normal)
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.layer.borderColor = Resources.Color.lavender.cgColor
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.cornerRadius = Resources.buttonHeight * Resources.cornerRadiusCoefficient
        nameTextField.setLeftPaddingPoints(16)
        nameTextField.clearButtonMode = .whileEditing
        nameTextField.delegate = self
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Exercise name",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: Resources.Color.rosyBrown])
        nameTextField.textColor = Resources.Color.beige
        
        existingExercisesButton.translatesAutoresizingMaskIntoConstraints = false
        existingExercisesButton.layer.cornerRadius = Resources.buttonHeight * Resources.cornerRadiusCoefficient
        existingExercisesButton.addTarget(self, action: #selector(previouslyCreatedTapped), for: .touchUpInside)
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.backgroundColor = Resources.Color.darkBlue
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(Resources.Color.beige, for: .normal)
        saveButton.layer.cornerRadius = Resources.buttonHeight * Resources.cornerRadiusCoefficient
        
        clockImageView.translatesAutoresizingMaskIntoConstraints = false
        clockImageView.tintColor = Resources.Color.rosyBrown
        clockImageView.contentMode = .scaleAspectFill
        clockImageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = .systemFont(ofSize: 9, weight: .bold)
        textLabel.numberOfLines = 0
        textLabel.textColor = Resources.Color.rosyBrown
        textLabel.textAlignment = .center
        textLabel.text = "Choose Existing"
        textLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        exerciseInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        exerciseInfoLabel.numberOfLines = 0
        
        addSetButton.translatesAutoresizingMaskIntoConstraints = false
        addSetButton.setTitle("Add Set", for: .normal)
        addSetButton.setTitleColor(Resources.Color.darkBlue, for: .normal)
        addSetButton.backgroundColor = Resources.Color.rosyBrown
        addSetButton.layer.cornerRadius = Resources.buttonHeight * Resources.cornerRadiusCoefficient
        addSetButton.addTarget(self, action: #selector(addSetTapped), for: .touchUpInside)
        
        repeatSetButton.translatesAutoresizingMaskIntoConstraints = false
        repeatSetButton.setTitle("Repeat Set", for: .normal)
        repeatSetButton.setTitleColor(Resources.Color.darkBlue, for: .normal)
        repeatSetButton.backgroundColor = Resources.Color.rosyBrown
        repeatSetButton.layer.cornerRadius = Resources.buttonHeight * Resources.cornerRadiusCoefficient
        repeatSetButton.addTarget(self, action: #selector(repeatSetTapped), for: .touchUpInside)
        
        currentSetView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layout() {
        exerciseStackView.addArrangedSubview(nameTextField)
        existingExercisesButton.addSubview(clockImageView)
        existingExercisesButton.addSubview(textLabel)
        exerciseStackView.addArrangedSubview(existingExercisesButton)
        
        buttonsStackView.addArrangedSubview(addSetButton)
        buttonsStackView.addArrangedSubview(repeatSetButton)
        
        currentSetView.addSubview(currentSetStackView)
        
        stackView.addArrangedSubview(muscleGroupButton)
        stackView.addArrangedSubview(exerciseStackView)
        stackView.addArrangedSubview(exerciseInfoLabel)
        stackView.addArrangedSubview(currentSetView)
        stackView.addArrangedSubview(buttonsStackView)
        stackView.addArrangedSubview(saveButton)
        
        view.addSubview(stackView)
        view.addSubview(existingExercisesView)
        view.addSubview(musclesGroupsView)
        
        NSLayoutConstraint.activate([
            muscleGroupButton.heightAnchor.constraint(equalToConstant: Resources.buttonHeight),
            
            nameTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.7),
            existingExercisesButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.3, constant: -16),
            exerciseStackView.heightAnchor.constraint(equalToConstant: Resources.buttonHeight),
            
            addSetButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.7),
            repeatSetButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.3, constant: -8),
            buttonsStackView.heightAnchor.constraint(equalToConstant: Resources.buttonHeight),
            
            saveButton.heightAnchor.constraint(equalToConstant: Resources.buttonHeight),
            
            currentSetStackView.leadingAnchor.constraint(equalTo: currentSetView.leadingAnchor),
            currentSetStackView.trailingAnchor.constraint(equalTo: currentSetView.trailingAnchor),
            currentSetStackView.topAnchor.constraint(equalTo: currentSetView.topAnchor, constant: 32),
            currentSetStackView.bottomAnchor.constraint(equalTo: currentSetView.bottomAnchor, constant: -32),
            
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            clockImageView.topAnchor.constraint(equalTo: existingExercisesButton.topAnchor),
            clockImageView.widthAnchor.constraint(lessThanOrEqualTo: existingExercisesButton.widthAnchor, multiplier: 0.8),
            clockImageView.heightAnchor.constraint(equalTo: clockImageView.widthAnchor),
            clockImageView.centerXAnchor.constraint(equalTo: existingExercisesButton.centerXAnchor),
            clockImageView.bottomAnchor.constraint(equalTo: textLabel.topAnchor, constant: -4),
            
            textLabel.topAnchor.constraint(equalTo: clockImageView.bottomAnchor, constant: 4),
            textLabel.leadingAnchor.constraint(equalTo: existingExercisesButton.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: existingExercisesButton.trailingAnchor),
            textLabel.centerXAnchor.constraint(equalTo: existingExercisesButton.centerXAnchor),
            textLabel.bottomAnchor.constraint(equalTo: existingExercisesButton.bottomAnchor, constant: -4),
            
            existingExercisesView.topAnchor.constraint(equalTo: view.topAnchor),
            existingExercisesView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            existingExercisesView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            existingExercisesView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            musclesGroupsView.topAnchor.constraint(equalTo: view.topAnchor),
            musclesGroupsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            musclesGroupsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            musclesGroupsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func addNewSetLabel() {
        let setLabel = UILabel()
        setLabel.translatesAutoresizingMaskIntoConstraints = false
        setLabel.textAlignment = .center
        currentSetStackView.addArrangedSubview(setLabel)
        currentSetsLabels.append(setLabel)
    }
    
    private func updateLastSetLabel(asActive: Bool = true) {
        let lastIdx = self.currentSetsLabels.count - 1
        self.currentSetsLabels[lastIdx].attributedText = self.formatter.makeAttributedSetsInfo(
            sets: self.exerciseVM.statistics[lastIdx].sets,
            reps: self.exerciseVM.statistics[lastIdx].repetitions,
            weight: self.exerciseVM.statistics[lastIdx].weight, active: asActive)
    }
}

// MARK: Actions
extension ExerciseViewController {
    @objc func muscleGroupTapped() {
        musclesGroupsView.show()
    }
    
    @objc func previouslyCreatedTapped() {
        guard exerciseVM.muscleGroup != nil else {
            // TODO: display error
            return }
        
        exerciseVM.getSavedExercises()
    }
    
    @objc func addSetTapped() {
        exerciseVM.weight = nil
        let addSetNC = UINavigationController(rootViewController: AddSetViewController())
        present(addSetNC, animated: true)
    }
    
    @objc func repeatSetTapped() {
        exerciseVM.increaseSetNumber()
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
