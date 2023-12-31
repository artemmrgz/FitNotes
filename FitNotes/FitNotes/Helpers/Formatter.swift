//
//  Formatter.swift
//  FitNotes
//
//  Created by Artem Marhaza on 02/07/2023.
//

import UIKit

struct Formatter {
    func makeAttributedExerciseInfo(date: String, stats: [Statistics]) -> NSMutableAttributedString {
        let title = "Last Workout (\(date))"
        var text = ""

        for stat in stats {
            if !text.isEmpty {
                text += "\n"
            }
            text += "\(stat.sets) sets x \(stat.repetitions) reps"
            if let weight = stat.weight {
                text += " x \(weight) kg"
            }
        }

        let formattedTitle = makeAttributedString(title, color: Resources.Color.rosyBrown,
                                                  font: UIFont.systemFont(ofSize: 12, weight: .bold))
        let formattedText = makeAttributedString(text, color: Resources.Color.rosyBrown,
                                                 font: UIFont.systemFont(ofSize: 12))

        formattedTitle.append(NSAttributedString(string: "\n"))
        formattedTitle.append(formattedText)

        return formattedTitle
    }

    private func makeAttributedString(_ text: String, color: UIColor, font: UIFont) -> NSMutableAttributedString {
        var attrString = [NSAttributedString.Key: Any]()
        attrString[.font] = font
        attrString[.foregroundColor] = color

        return NSMutableAttributedString(string: text, attributes: attrString)
    }

    func makeAttributedSetsInfo(sets: Int, reps: Int, weight: Int? = nil, active: Bool) -> NSMutableAttributedString {
        let color = Resources.Color.darkBlue
        let numberFont: UIFont
        let textFont: UIFont

        if active {
            numberFont = UIFont.systemFont(ofSize: 32, weight: .heavy)
            textFont = UIFont.systemFont(ofSize: 22)
        } else {
            numberFont = UIFont.systemFont(ofSize: 24, weight: .heavy)
            textFont = UIFont.systemFont(ofSize: 16.5)
        }

        let result = makeAttributedString(String(describing: sets), color: color, font: numberFont)
        let attrRepsNumber = makeAttributedString(String(describing: reps), color: color, font: numberFont)

        let attrSets = makeAttributedString(" sets ", color: color, font: textFont)
        let attrReps = makeAttributedString(" reps ", color: color, font: textFont)
        let attrX = makeAttributedString(" x  ", color: color, font: textFont)

        for elem in [attrSets, attrX, attrRepsNumber, attrReps] {
            result.append(elem)
        }

        if let weight {
            let attrWeight = makeAttributedString(String(describing: weight), color: color, font: numberFont)
            let attrKg = makeAttributedString(" kg", color: color, font: textFont)

            for elem in [attrX, attrX, attrWeight, attrKg] {
                result.append(elem)
            }
        }
        return result
    }
}
