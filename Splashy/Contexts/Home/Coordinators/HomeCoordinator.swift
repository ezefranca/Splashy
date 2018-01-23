//
//  HomeCoordinator.swift
//  Splashy
//
//  Created by Pedro Carrasco on 23/01/18.
//  Copyright © 2018 Pedro Carrasco. All rights reserved.
//

import UIKit

class HomeCoordinator: Coordinator {

   // MARK: - PROPERTIES
   weak var coordinatorDelegate: CoordinatorDelegate?
   private let navigationController: UINavigationController
   internal var coordinators: [Coordinator]

   // MARK: - INITIALIZATION
   init(navigationController: UINavigationController) {
      self.navigationController = navigationController
      self.coordinators = []
   }

   // MARK: - FUNCTIONS
   func start() {
      let viewController = HomeViewController(
         nibName: HomeViewController.name,
         bundle: nil
      )

      let viewModel = HomeViewModel()
      viewController.viewModel = viewModel
      viewController.navigationDelegate = self
      
      navigationController.pushViewController(
         viewController, animated: true
      )
   }
}

extension HomeCoordinator: HomeViewNavigationDelegate {
   func homeViewControllerDidPressPlay(_ homeViewController: HomeViewController) {

   }
}

extension HomeCoordinator: CoordinatorDelegate {
   func coordinatorDidStart(_ coordinator: Coordinator) {
      coordinators.append(coordinator)
   }

   func coordinatorDidEnd(_ coordinator: Coordinator) {
      coordinators = coordinators.filter { $0 !== coordinator }
   }
}
