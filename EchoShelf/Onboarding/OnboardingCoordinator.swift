//
//  OnboardingCoordinator.swift
//  EchoShelf
//
//  Created by Ibrahim Kolchi on 14.03.26.
//
import UIKit

final class OnboardingCoordinator: Coordinator {

    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = OnboardingViewController()
        vc.onFinish = { [weak self] in
            self?.finishOnboarding()
        }
        vc.onSignIn = { [weak self] in
            self?.finishOnboarding()
            self?.showSignIn()
        }
        navigationController.setViewControllers([vc], animated: false)
    }

    private func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        showAuth()
    }

    private func showAuth() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator.start()
    }

    private func showSignIn() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator.start()
    }
}
