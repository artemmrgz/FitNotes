//
//  SuccessLabel.swift
//  FitNotes
//
//  Created by Artem Marhaza on 08/07/2023.
//

import UIKit

class SuccessLabel: UILabel {

    let height: CGFloat

    init(withText successText: String, height: CGFloat = Resources.buttonHeight) {
        self.height = height

        super.init(frame: .zero)

        text = successText
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 0
        textColor = Resources.Color.darkBlue
        textAlignment = .center
        backgroundColor = .systemGreen
        layer.cornerRadius = height * Resources.cornerRadiusCoefficient
        clipsToBounds = true
    }

    func layout(onView view: UIView) {
        view.addSubview(self)
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: trailingAnchor, multiplier: 2),
            heightAnchor.constraint(equalToConstant: height),
            // under the view on its initial position
            topAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func showFromBottom(toYCoordinate yCoordinate: CGFloat) {
        let initialFrame = self.frame
        let finalFrame = CGRect(origin: CGPoint(x: initialFrame.origin.x,
                                                y: yCoordinate),
                                size: initialFrame.size)

        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 4,
                       animations: { self.frame = finalFrame },
                       completion: { success in
            guard success else { return }
            UIView.animate(withDuration: 0.7, delay: 1.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 4) {
                    self.frame = initialFrame }
        })
    }
}
