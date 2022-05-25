//
//  ViewController.swift
//  GithubRepository
//
//  Created by Naveen Natrajan on 25/05/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableViewPage: UIPageControl!
    @IBOutlet weak var repositoryTableView: UITableView!
    var repositoriesData : GitHubRepoaitoryJSON?
    let loaderSpinView = SpinnerViewController()
    var refreshControl = UIRefreshControl()
    var noOfPages : Int?
    var currentPage = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewDidLoad()
        repositoryTableView.delegate = self
        repositoryTableView.dataSource = self
        repositoryTableView.register(UINib(nibName: reuseNibIdentifier.repositoriesTableViewCell, bundle: nil), forCellReuseIdentifier: reuseCellIdentifier.repositoriesTableViewCell)
        createSpinnerView()
        makePostCallGithubRepository()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refreshRepositoryData), for: .valueChanged)
        repositoryTableView.addSubview(refreshControl)
        tableViewPage.numberOfPages = 8
    }
   
    @IBAction func nextButtonPressed(_ sender: Any) {
        if noOfPages != nil
        {
         
        if currentPage < noOfPages! - 1
        {
        currentPage = currentPage + 1
        tableViewPage.currentPage = currentPage - 1
            repositoryTableView.reloadData()

        }
        }
    }
    
    @IBAction func previousButtonPressed(_ sender: Any) {
        if noOfPages != nil
        {
       
        if currentPage > 1
        {
            print("j")
        currentPage = currentPage - 1
        tableViewPage.currentPage = currentPage - 1
            repositoryTableView.reloadData()
        }
        }

    }
    @objc func refreshRepositoryData() {
        refreshControl.endRefreshing()
        makePostCallGithubRepository()
        createSpinnerView()
    }
    func createSpinnerView() {
        addChild(loaderSpinView)
        loaderSpinView.view.frame = view.frame
        view.addSubview(loaderSpinView.view)
        loaderSpinView.didMove(toParent: self)
    }
    func removeSpinnerView()
    {
        loaderSpinView.willMove(toParent: nil)
        loaderSpinView.view.removeFromSuperview()
        loaderSpinView.removeFromParent()
    }
    func makePostCallGithubRepository() {
     
        let decoder = JSONDecoder()
        if let url = URL(string: "\(ConstantsUsedInProject.baseUrl)")
        {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                guard error == nil && data != nil else {
                    print("error=\(String(describing: error))")
                    return
                }
                do {
                    let jsonResponse = try? decoder.decode(GitHubRepoaitoryJSON.self, from: data!)
                    
                    DispatchQueue.main.async { [self] in
                            repositoriesData = jsonResponse
                            print(jsonResponse as Any)
                            removeSpinnerView()
                            calculatePage()
                       
                    }
                }
            }
            task.resume()
        }
    }
    func calculatePage()
    {
        let noOfItems = repositoriesData!.count
        print(noOfItems)
        let pages = noOfItems / 10
        if noOfItems % 10 == 0
        {
            noOfPages = pages
        }
        else
        {
            noOfPages = pages + 1
        }
        
        repositoryTableView.reloadData()

        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifiers.mainViewToDetailView
        {
            let destinationVC = segue.destination as! DetailsViewController
            let row = sender as! Int
            if let repository = repositoriesData?[row]
            {
                destinationVC.repositoryData = repository
            }
        }
    }

}



extension ViewController: UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = repositoryTableView.dequeueReusableCell(withIdentifier: reuseCellIdentifier.repositoriesTableViewCell) as! RepositoriesTableViewCell
        let itemNumber = currentPage * 10 + indexPath.row
        if let repositoryData = repositoriesData?[itemNumber]
        {
            cell.repositoryNameLabel.text = repositoryData.name ?? ""
            cell.repositoryOwnerName.text = repositoryData.owner?.login ?? ""
            if let imageUrl = repositoryData.owner?.avatarURL
            {
            let urlStr = imageUrl
                let url = URL(string: urlStr)
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!)
                    DispatchQueue.main.async {
                        cell.avatarImageVIew.image = UIImage(data: data!)
                        cell.avatarImageVIew.contentMode = .scaleAspectFit
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueIdentifiers.mainViewToDetailView, sender: indexPath.row)

        repositoryTableView.deselectRow(at: indexPath, animated: true)
    }
  

}
