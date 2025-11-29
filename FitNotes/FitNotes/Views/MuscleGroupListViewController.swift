//
//  MuscleGroupListViewController.swift
//  FitNotes
//
//  Created by Artem Marhaza on 27/11/2025.
//

import UIKit

class MuscleGroupListViewController: UIViewController {
    let tableView = UITableView()
    let muscleGroups = MuscleGroup.allCases

    let viewModel: MuscleGroupsViewModel

    init(viewModel: MuscleGroupsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        style()
        layout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MuscleGroupCell.self, forCellReuseIdentifier: MuscleGroupCell.reuseID)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .red
    }

    func style() {
        view.backgroundColor = .red

    }

    func layout() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension MuscleGroupListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = viewModel.muscleGroup(at: indexPath.row)
        
        print(group.rawValue)
    }
}

extension MuscleGroupListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfMuscleGroups()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MuscleGroupCell.reuseID, for: indexPath) as? MuscleGroupCell else { return UITableViewCell() }

        let group = viewModel.muscleGroup(at: indexPath.row)
        cell.configure(with: group)

        return cell
    }
}
