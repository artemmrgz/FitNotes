//
//  OptionsView.swift
//  FitNotes
//
//  Created by Artem Marhaza on 02/07/2023.
//

import UIKit

class OptionsView: UIVisualEffectView {

    var tableDataSource: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    let tableView = UITableView()
    let cancelButton = UIButton(type: .custom)

    var initialFrame: CGRect = .zero
    let tableCellHeight: CGFloat = 60

    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)

        setupView()
        setupTable()
    }

    var callback: (IndexPath) -> Void = { _ in }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        alpha = 0
        isHidden = true

        tableView.alpha = 0
        cancelButton.alpha = 0

        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        cancelButton.backgroundColor = Resources.Color.darkBlue
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(Resources.Color.beige, for: .normal)
        cancelButton.layer.cornerRadius = tableCellHeight * Resources.cornerRadiusCoefficient

        contentView.addSubview(tableView)
        contentView.addSubview(cancelButton)
    }

    @objc func cancelTapped() {
        hideBlurView()
    }

    func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Exercise Cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = tableCellHeight
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 60 * Resources.cornerRadiusCoefficient
        tableView.separatorColor = Resources.Color.darkBlue
    }

    func hideBlurView() {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 4, animations: ({

            self.tableView.frame = self.initialFrame
            self.cancelButton.frame = self.initialFrame
            self.tableView.alpha = 0
            self.cancelButton.alpha = 0
        }))

        UIView.animate(withDuration: 0.6, delay: 0.2, usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 4, animations: ({
            self.alpha = 0
        })) { _ in
            self.isHidden = true
        }
    }

    func show() {
        let width: CGFloat = frame.width * 0.9

        let actualTableHeight: CGFloat = tableView.rowHeight * CGFloat(tableDataSource.count)
        let maxTableHeight: CGFloat = tableCellHeight * 8 // max 8 rows
        let resultTableHeight = actualTableHeight < maxTableHeight ? actualTableHeight : maxTableHeight

        let finalFrame = CGRect(x: 0, y: 0, width: width, height: resultTableHeight)

        tableView.frame = initialFrame
        cancelButton.frame = initialFrame

        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 4) {
            self.isHidden = false
            self.alpha = 1
        }

        UIView.animate(withDuration: 0.6, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 4) {
            self.tableView.frame = finalFrame
            self.tableView.center = self.center
            self.tableView.alpha = 1

            self.cancelButton.frame = CGRect(x: self.tableView.frame.origin.x,
                                                     y: self.tableView.frame.origin.y + resultTableHeight + 16,
                                                     width: self.tableView.frame.width,
                                                     height: 60)
            self.cancelButton.alpha = 1
        }
    }
}

extension OptionsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !tableDataSource.isEmpty else {
            return UITableViewCell() }

        let title = tableDataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Exercise Cell", for: indexPath)

        var content = cell.defaultContentConfiguration()

        content.text = title
        content.textProperties.color = Resources.Color.beige
        cell.contentConfiguration = content

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        callback(indexPath)
        hideBlurView()
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = Resources.Color.mediumPurple
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}
