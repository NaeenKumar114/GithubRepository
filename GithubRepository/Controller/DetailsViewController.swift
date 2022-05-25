//
//  DetailsViewController.swift
//  GithubRepository
//
//  Created by Naveen Natrajan on 25/05/22.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var detailsTableView: UITableView!
    var repositoryData :GitHubRepoaitoryJSONElement?
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        detailsTableView.register(UINib(nibName: reuseNibIdentifier.detailsTableViewCell, bundle: nil), forCellReuseIdentifier: reuseCellIdentifier.detailsTableViewCell)
        detailsTableView.rowHeight = UITableView.automaticDimension
        detailsTableView.estimatedRowHeight = 60
        // Do any additional setup after loading the view.
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


extension DetailsViewController: UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailsTableView.dequeueReusableCell(withIdentifier: reuseCellIdentifier.detailsTableViewCell) as! DetailsTableViewCell
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Name"
            cell.detailsLabel.text = repositoryData?.name ?? ""
        case 1:
            cell.titleLabel.text = "Owner Name"
            cell.detailsLabel.text = repositoryData?.owner?.login ?? ""

        case 2:
            cell.titleLabel.text = "Full Name"
            cell.detailsLabel.text = repositoryData?.fullName ?? ""

        case 3:
            cell.titleLabel.text = "Description"
            cell.detailsLabel.text = repositoryData?.gitHubRepoaitoryJSONDescription ?? ""
        case 4:
            cell.titleLabel.text = "URL"
            cell.detailsLabel.text = repositoryData?.url ?? ""
        case 5:
            cell.titleLabel.text = "Node ID"
            cell.detailsLabel.text = repositoryData?.nodeID ?? ""

        default:
            print("error")
        }
        return cell
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailsTableView.deselectRow(at: indexPath, animated: true)
    }

}
