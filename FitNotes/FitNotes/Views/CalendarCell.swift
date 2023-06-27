//
//  CalendarCell.swift
//  FitNotes
//
//  Created by Artem Marhaza on 26/06/2023.
//

import UIKit

class CalendarCell: UICollectionViewCell {

    static let reuseID = "CalendarCell"

    let dayOfMonthLabel = UILabel()
    let dayOfWeekLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
        layout()
        setDefaultStyle()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.layer.cornerRadius = contentView.bounds.width * Resources.cornerRadiusCoefficient
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        dayOfMonthLabel.translatesAutoresizingMaskIntoConstraints = false
        dayOfMonthLabel.numberOfLines = 0
        dayOfMonthLabel.textAlignment = .center
        dayOfMonthLabel.font = .systemFont(ofSize: 15, weight: .bold)

        dayOfWeekLabel.translatesAutoresizingMaskIntoConstraints = false
        dayOfWeekLabel.numberOfLines = 0
        dayOfWeekLabel.textAlignment = .center
        dayOfWeekLabel.font = .systemFont(ofSize: 13)
    }

    private func layout() {
        contentView.addSubview(dayOfMonthLabel)
        contentView.addSubview(dayOfWeekLabel)

        NSLayoutConstraint.activate([
            dayOfMonthLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            dayOfMonthLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            dayOfWeekLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            dayOfWeekLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }

    func configureWith(dayOfMonth: String, dayOfWeek: String) {
        self.dayOfMonthLabel.text = dayOfMonth
        self.dayOfWeekLabel.text = dayOfWeek
    }
    
    func setSelectedStyle() {
        contentView.backgroundColor = Resources.Color.darkBlue
        dayOfMonthLabel.textColor = Resources.Color.rosyBrown
        dayOfWeekLabel.textColor = Resources.Color.rosyBrown
    }
    
    func setDefaultStyle() {
        contentView.backgroundColor = Resources.Color.lavender
        dayOfMonthLabel.textColor = Resources.Color.beige
        dayOfWeekLabel.textColor = Resources.Color.beige
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        setDefaultStyle()
    }
}

