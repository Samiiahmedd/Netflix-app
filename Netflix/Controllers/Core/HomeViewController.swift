//
//  HomeViewController.swift
//  Netflix
//
//  Created by Sami Ahmed on 25/10/2023.
//
import UIKit

enum sections : Int {

    case TrendingMovies = 0
    case TrendingTv = 1
    case Populars = 2
    case Upcoming = 3
    case TopRates = 4
}
    

class HomeViewController: UIViewController {
    
    let sectionTitles: [String] = ["Trending Movies",
                                   "Trending Tv",
                                   "Populars",
                                   "Upcoming Movies",
                                   "Top rated"]
    
    private let homeFeedTable : UITableView = {
        
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.dataSource = self
        homeFeedTable.delegate = self
        
        configureNavbar()
        
        let headerView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        homeFeedTable.tableHeaderView = headerView
        APICaller.shared.getMovie(with: "Harry potter") { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    
    private func configureNavbar() {
        
//        #warning("items not added to nav bar")
//        #warning("logo not added to left of navbar")
        
        
        var image = UIImage(named:"NetflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(named:"person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(named: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    

}


extension HomeViewController : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        switch indexPath.section{
            
        case sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { result in
                switch result{
                case.success(let titles):
                    cell.configure(with: titles)
                case.failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
            
        case sections.TrendingTv.rawValue:
            
            APICaller.shared.getTrendingTvs { result in
                switch result{
                case.success(let titles):
                    cell.configure(with: titles)
                case.failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
        case sections.Populars.rawValue:
            
            APICaller.shared.getPopulars { result in
                switch result{
                case.success(let titles):
                    cell.configure(with: titles)
                case.failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
        case sections.Upcoming.rawValue:
            
            APICaller.shared.getUpcomingMovies { result in
                switch result{
                case.success(let titles):
                    cell.configure(with: titles)
                case.failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
        case sections.TopRates.rawValue:
            
            APICaller.shared.getTopRated { result in
                switch result{
                case.success(let titles):
                    cell.configure(with: titles)
                case.failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
            
            
        default:
            return UITableViewCell()
        }
        return cell
    }
        
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            200
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            40
        }
        
        func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
            guard let header = view as? UITableViewHeaderFooterView else {return}
            header.textLabel?.font = .systemFont(ofSize: 18,weight: .semibold)
            header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
            header.textLabel?.textColor = .label
            header.textLabel?.text = header.textLabel?.text?.capatalizedFirstLetter()
        }
        
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let defultOffset = view.safeAreaInsets.top
            let offset = scrollView.contentOffset.y + defultOffset
            navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
        }
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return sectionTitles[section]
        }
        
        
    }

    
    

