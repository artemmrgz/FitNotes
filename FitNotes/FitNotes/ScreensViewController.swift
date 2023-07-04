//
//  ScreensViewController.swift
//  FitNotes
//
//  Created by Artem Marhaza on 27/06/2023.
//

import UIKit

class ScreensViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupTabBar()
    }

    private func setupViews() {
        let mainVC = MainViewController()
        let statisticVC = StatisticViewController()
        let profileVC = ProfileViewController()

        mainVC.setTabBarImage(imageName: "list.dash.header.rectangle", title: "Main", tag: 0)
        statisticVC.setTabBarImage(imageName: "chart.bar.xaxis", title: "Statistic", tag: 1)
        profileVC.setTabBarImage(imageName: "person.crop.circle", title: "Profile", tag: 2)

        let mainNC = UINavigationController(rootViewController: mainVC)
        let statisticNC = UINavigationController(rootViewController: statisticVC)
        let profileNC = UINavigationController(rootViewController: profileVC)

        viewControllers = [mainNC, statisticNC, profileNC]
    }

    private func setupTabBar() {
        tabBar.tintColor = Resources.Color.darkBlue
        tabBar.unselectedItemTintColor = Resources.Color.beige
        tabBar.backgroundColor = Resources.Color.lavender
    }
}

class StatisticViewController: UIViewController {

}

class ProfileViewController: UIViewController {

}
