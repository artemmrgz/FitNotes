//
//  MuscleGroupCell.swift
//  FitNotes
//
//  Created by Artem Marhaza on 27/11/2025.
//

import UIKit

class MuscleGroupCell: UITableViewCell {
    static let reuseID = "MuscleGroupCell"

    let padding: CGFloat = 16
    let imageHeight: CGFloat = 80

    let iconImageView = UIImageView()
    let titleLabel = UILabel()
    let chevronImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        iconImageView.layer.cornerRadius = iconImageView.bounds.width * Resources.cornerRadiusCoefficient
    }

    func setup() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.clipsToBounds = true
        iconImageView.contentMode = .scaleAspectFill

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 18)

        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        let chevronImage = UIImage(systemName: "chevron.right")!.withTintColor(Resources.Color.lavender, renderingMode: .alwaysOriginal)
        chevronImageView.image = chevronImage
        chevronImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

    }

    func layout() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(chevronImageView)

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            iconImageView.heightAnchor.constraint(equalToConstant: imageHeight),
            iconImageView.widthAnchor.constraint(equalToConstant: imageHeight),

            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: padding),
//            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            chevronImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: padding),
            chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(with group: MuscleGroup) {
        iconImageView.image = UIImage(named: group.imageName)
        titleLabel.text = group.title
    }
}
