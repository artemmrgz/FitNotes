//
//  Formatter.swift
//  FitNotes
//
//  Created by Artem Marhaza on 02/07/2023.
//

import UIKit

struct Formatter {
    func makeAttributedExerciseInfo(date: String, sets: Int, reps: Int, weight: Int) -> NSMutableAttributedString {
        let title = "Last Workout (\(date))"
        let text = "\(sets) sets \(reps) reps x \(weight)kg"
        
        let formattedTitle = makeAttributedString(title, color: Resources.Color.rosyBrown, font: UIFont.systemFont(ofSize: 12, weight: .bold))
        let formattedText = makeAttributedString(text, color: Resources.Color.rosyBrown, font: UIFont.systemFont(ofSize: 12))
        
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
    
    func makeAttributedSetsInfo(sets: Int = 0, reps: Int = 0, weight: Int? = nil) -> NSMutableAttributedString {
        let textFont = UIFont.systemFont(ofSize: 22)
        let numberFont = UIFont.systemFont(ofSize: 32, weight: .heavy)
        let color = Resources.Color.darkBlue
        
        
        let result = makeAttributedString(String(describing: sets), color: color, font: numberFont)
        let attrRepsNumber = makeAttributedString(String(describing: reps), color: color, font: numberFont)
        
        let attrSets = makeAttributedString(" sets ", color: color, font: textFont)
        let attrReps = makeAttributedString(" reps ", color: color, font: textFont)
        
        result.append(attrSets)
        result.append(attrRepsNumber)
        result.append(attrReps)
        
        if let weight {
            let attrX = makeAttributedString(" x ", color: color, font: textFont)
            let attrWeight = makeAttributedString(String(describing: weight), color: color, font: numberFont)
            let attrKg = makeAttributedString("kg", color: color, font: textFont)
            
            result.append(attrX)
            result.append(attrWeight)
            result.append(attrKg)
        }
        
        return result
    }
}
