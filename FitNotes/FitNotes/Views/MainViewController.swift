//
//  MainViewController.swift
//  FitNotes
//
//  Created by Artem Marhaza on 26/06/2023.
//

import UIKit

class MainViewController: UIViewController {

    let nameLabel = UILabel()
    let photoImageView = UIImageView(image: UIImage(named: "personIcon"))
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    let collectionViewPlaceholder = UIView()

    let addWorkoutButton = UIButton(type: .custom)
    let plusImageView = UIImageView(image: UIImage(systemName: "plus"))
    let textLabel = UILabel()

    let weatherView = UIView()
    let picImageView = UIImageView(image: UIImage(named: "pullUp"))

    let workoutTableView = UITableView()

    let calendarVM = CalendarViewModel()
    let userVM = UserViewModel()
    let workoutVM = WorkoutViewModel()

    var currentSelectedIndex = IndexPath(row: 0, section: 0)
    var previousSelectedIndex = IndexPath(row: 0, section: 0)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Resources.Color.mediumPurple

        currentSelectedIndex = IndexPath(row: calendarVM.days.count - 1, section: 0)
        setWorkoutDate(indexPath: currentSelectedIndex)

        userVM.loadUserInfo()
        setupBinders()
        setupCollectionView()
        setupWorkoutTableView()
        style()
        layout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        photoImageView.layer.cornerRadius = photoImageView.frame.size.width / 2
        collectionViewPlaceholder.layer.cornerRadius = collectionViewPlaceholder.frame.size.height *
        Resources.cornerRadiusCoefficient
        addWorkoutButton.layer.cornerRadius = addWorkoutButton.frame.size.height * Resources.cornerRadiusCoefficient
        picImageView.layer.cornerRadius = picImageView.frame.size.height / 2
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let index = IndexPath(row: calendarVM.days.count - 1, section: 0)
        collectionView.scrollToItem(at: index, at: .right, animated: true)
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.reuseID)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = Resources.Color.lavender
    }

    private func setupBinders() {
        userVM.userName.bind { [weak self] name in
            guard !name.isEmpty else { return }

            self?.nameLabel.text = "Hello, \(name.capitalized)!"
        }

        userVM.error.bind { [weak self] error in
            guard let error else { return }

            self?.present(error.alert, animated: true)
        }

        workoutVM.exercisesLoaded.bind { [weak self] success in
            guard let self, success else { return }

            if self.workoutVM.exerciseDetails.isEmpty {
                self.picImageView.isHidden = false
                self.workoutTableView.isHidden = true
            } else {
                self.workoutTableView.reloadData()
                self.workoutTableView.isHidden = false
                self.picImageView.isHidden = true
            }
        }
    }

    private func setWorkoutDate(indexPath: IndexPath) {
        let date = calendarVM.days[indexPath.row].dayAsDate

        ExerciseViewModel.shared().date = date
        workoutVM.getSavedExercises(date: date)
    }

    private func setupWorkoutTableView() {
        workoutTableView.delegate = self
        workoutTableView.dataSource = self
        workoutTableView.register(WorkoutCell.self, forCellReuseIdentifier: WorkoutCell.reuseID)

        workoutTableView.translatesAutoresizingMaskIntoConstraints = false
        workoutTableView.backgroundColor = .clear
        workoutTableView.separatorColor = Resources.Color.darkBlue
        workoutTableView.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        workoutTableView.sectionHeaderTopPadding = 0

        workoutTableView.estimatedRowHeight = 60
        workoutTableView.rowHeight = UITableView.automaticDimension
//        workoutTableView.rowHeight = 60
    }

    private func style() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 30, weight: .bold)
        nameLabel.numberOfLines = 0
        nameLabel.textColor = .white
        nameLabel.text = " "

        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.backgroundColor = .systemGray5

        collectionViewPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        collectionViewPlaceholder.backgroundColor = Resources.Color.lavender
        collectionViewPlaceholder.clipsToBounds = true

        addWorkoutButton.translatesAutoresizingMaskIntoConstraints = false
        addWorkoutButton.backgroundColor = Resources.Color.darkBlue
        addWorkoutButton.addTarget(self, action: #selector(addWorkoutTapped), for: .touchUpInside)

        plusImageView.translatesAutoresizingMaskIntoConstraints = false
        plusImageView.tintColor = Resources.Color.rosyBrown
        plusImageView.contentMode = .scaleAspectFill

        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = .systemFont(ofSize: 9, weight: .bold)
        textLabel.numberOfLines = 0
        textLabel.textColor = Resources.Color.rosyBrown
        textLabel.textAlignment = .center
        textLabel.text = "Add Workout"

        picImageView.translatesAutoresizingMaskIntoConstraints = false
        picImageView.contentMode = .scaleAspectFill
        picImageView.clipsToBounds = true
        picImageView.isHidden = true
    }

    private func layout() {
        view.addSubview(nameLabel)
        collectionViewPlaceholder.addSubview(collectionView)
        view.addSubview(collectionViewPlaceholder)
        view.addSubview(photoImageView)
        addWorkoutButton.addSubview(plusImageView)
        addWorkoutButton.addSubview(textLabel)
        view.addSubview(addWorkoutButton)
        view.addSubview(picImageView)
        view.addSubview(workoutTableView)

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),

            photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            photoImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            photoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.22),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor),

            collectionViewPlaceholder.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            collectionViewPlaceholder.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                               constant: 8),
            collectionViewPlaceholder.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                                constant: -8),
            collectionViewPlaceholder.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08),

            collectionView.topAnchor.constraint(equalTo: collectionViewPlaceholder.topAnchor, constant: 4),
            collectionView.bottomAnchor.constraint(equalTo: collectionViewPlaceholder.bottomAnchor, constant: -4),
            collectionView.trailingAnchor.constraint(equalTo: collectionViewPlaceholder.trailingAnchor, constant: -4),
            collectionView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),

            addWorkoutButton.topAnchor.constraint(equalTo: collectionViewPlaceholder.bottomAnchor, constant: 8),
            addWorkoutButton.leadingAnchor.constraint(equalTo: collectionViewPlaceholder.leadingAnchor),
            addWorkoutButton.heightAnchor.constraint(equalTo: collectionViewPlaceholder.heightAnchor, multiplier: 1.2),
            addWorkoutButton.widthAnchor.constraint(equalTo: addWorkoutButton.heightAnchor),

            plusImageView.topAnchor.constraint(equalTo: addWorkoutButton.topAnchor, constant: 4),
            plusImageView.widthAnchor.constraint(lessThanOrEqualTo: addWorkoutButton.widthAnchor, multiplier: 0.8),
            plusImageView.heightAnchor.constraint(equalTo: plusImageView.widthAnchor),
            plusImageView.centerXAnchor.constraint(equalTo: addWorkoutButton.centerXAnchor),
            plusImageView.bottomAnchor.constraint(equalTo: textLabel.topAnchor, constant: -4),

            textLabel.topAnchor.constraint(equalTo: plusImageView.bottomAnchor, constant: 4),
            textLabel.leadingAnchor.constraint(equalTo: plusImageView.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: plusImageView.trailingAnchor),
            textLabel.centerXAnchor.constraint(equalTo: addWorkoutButton.centerXAnchor),
            textLabel.bottomAnchor.constraint(equalTo: addWorkoutButton.bottomAnchor, constant: -4),

            picImageView.topAnchor.constraint(equalTo: addWorkoutButton.bottomAnchor, constant: 32),
            picImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            picImageView.heightAnchor.constraint(equalTo: picImageView.widthAnchor),
            picImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            workoutTableView.topAnchor.constraint(equalTo: addWorkoutButton.bottomAnchor, constant: 8),
            workoutTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            workoutTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            workoutTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc func addWorkoutTapped() {
        let exerciseVC = ExerciseViewController()
        self.navigationController?.pushViewController(exerciseVC, animated: true)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarVM.days.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard !calendarVM.days.isEmpty,
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCell.reuseID,
                                                          for: indexPath) as? CalendarCell
        else { return UICollectionViewCell() }

        let day = calendarVM.days[indexPath.row]
        cell.configureWith(dayOfMonth: day.dayOfMonth, dayOfWeek: day.dayOfWeek)

        if indexPath == currentSelectedIndex {
            cell.setSelectedStyle()
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !calendarVM.days.isEmpty else { return }

        previousSelectedIndex = currentSelectedIndex
        currentSelectedIndex = indexPath

        collectionView.reloadItems(at: [previousSelectedIndex])
        collectionView.reloadItems(at: [currentSelectedIndex])

        setWorkoutDate(indexPath: indexPath)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 7 - 2
        return CGSize(width: width, height: collectionView.bounds.size.height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        workoutVM.muscleGroups.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        workoutVM.exerciseDetails[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = workoutTableView.dequeueReusableCell(withIdentifier: WorkoutCell.reuseID) as? WorkoutCell
        else { return UITableViewCell() }

        let exercise = workoutVM.exerciseDetails[indexPath.section][indexPath.row]
        cell.configure(name: exercise.name, statistics: exercise.statistics)

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        view.backgroundColor = Resources.Color.darkBlue

        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        lbl.textColor = Resources.Color.beige
        lbl.text = workoutVM.muscleGroups[section]
        view.addSubview(lbl)

        lbl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            lbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            lbl.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
}
