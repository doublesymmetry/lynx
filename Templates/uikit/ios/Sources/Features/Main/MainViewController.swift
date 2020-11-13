//
//  MainViewController.swift
//  Lynx
//
//  Created by David Chavez on 12.11.20.
//  Copyright © 2020 Double Symmetry UG. All rights reserved.
//

import UIKit
import shared

class MainViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var infoLabel: UILabel!

    // MARK: - Attributes

    private lazy var viewModel = MainViewModel()
    private lazy var log = KoinIOS().logger(tag: String(describing: type(of: self)))


    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        log.d { "viewDidLoad" }

        // Do any additional setup after loading the view.
        view.backgroundColor = .white

        viewModel.fact.addObserver { [weak self] fact in
            self?.infoLabel.text = fact as String?
        }

        viewModel.fetchFact()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
