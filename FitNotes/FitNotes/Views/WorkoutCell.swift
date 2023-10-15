//
//  WorkoutCell.swift
//  FitNotes
//
//  Created by Artem Marhaza on 25/09/2023.
//

import UIKit

class WorkoutCell: UITableViewCell {

    static let reuseID = "WorkoutCell"

    let exerciseName = UILabel()
    let exerciseStats = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        exerciseName.translatesAutoresizingMaskIntoConstraints = false
        exerciseName.numberOfLines = 2
        exerciseName.font = .systemFont(ofSize: 18)
        exerciseName.setContentHuggingPriority(.defaultLow, for: .horizontal)
        exerciseName.setContentHuggingPriority(.defaultHigh, for: .vertical)
        exerciseName.textColor = Resources.Color.beige

        exerciseStats.translatesAutoresizingMaskIntoConstraints = false
        exerciseStats.numberOfLines = 0
        exerciseStats.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        exerciseStats.setContentHuggingPriority(.defaultHigh, for: .vertical)

        exerciseStats.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        exerciseStats.textColor = Resources.Color.rosyBrown

        contentView.backgroundColor = Resources.Color.mediumPurple
    }

    private func layout() {
        contentView.addSubview(exerciseName)
        contentView.addSubview(exerciseStats)

        NSLayoutConstraint.activate([
            exerciseName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            exerciseName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            exerciseName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            exerciseName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            exerciseStats.leadingAnchor.constraint(equalTo: exerciseName.trailingAnchor, constant: 8),
            exerciseStats.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            exerciseStats.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            exerciseStats.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(name: String, statistics: [Statistics]) {
        exerciseName.text = name
        exerciseStats.text = prepareStatistics(statistics)
    }

    func prepareStatistics(_ statistics: [Statistics]) -> String {
        var statsStrings = [String]()

        for stats in statistics {
            var string = "\(stats.sets) sets x \(stats.repetitions) reps"

            if let weight = stats.weight {
                string += " x \(weight) kg"
            }
            statsStrings.append(string)
        }

        return statsStrings.joined(separator: "\n")
    }
}
