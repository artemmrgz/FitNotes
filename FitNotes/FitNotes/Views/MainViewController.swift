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

    let calendarVM = CalendarViewModel()
    let userVM = UserViewModel()

    var currentSelectedIndex = IndexPath(row: 0, section: 0)
    var previousSelectedIndex = IndexPath(row: 0, section: 0)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Resources.Color.mediumPurple

        currentSelectedIndex = IndexPath(row: calendarVM.days.count - 1, section: 0)
        setExerciseDate(indexPath: currentSelectedIndex)

        userVM.loadUserInfo()
        setupBinders()
        setupCollectionView()
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

        userVM.error.bind { [weak self] errorAlert in
            guard let errorAlert else { return }

            self?.present(errorAlert, animated: true)
        }
    }

    private func setExerciseDate(indexPath: IndexPath) {
        ExerciseViewModel.shared().date = calendarVM.days[indexPath.row].dayAsDate
    }

    private func style() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 30, weight: .bold)
        nameLabel.numberOfLines = 0
        nameLabel.textColor = .white
        nameLabel.text = ""

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
            picImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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

        setExerciseDate(indexPath: indexPath)
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
