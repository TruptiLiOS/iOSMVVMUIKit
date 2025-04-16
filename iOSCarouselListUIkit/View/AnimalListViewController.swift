import Foundation
import UIKit

class AnimalListViewController: UIViewController {
    
    let viewModel = AnimalViewModel()
    let tableView = UITableView()
    let searchBar = UISearchBar()
    let carouselCollectionView: UICollectionView
    let pageControl = UIPageControl()
    static let storyboardID = "MyViewController"
    static let carouselCellID = "carouselCell"
    static let tvCellIdentifier = "cell"

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
        layout.minimumLineSpacing = 0
        carouselCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
        setupHeaderView()
        bindViewModel()
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: AnimalListViewController.tvCellIdentifier)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupHeaderView() {
        let headerHeight: CGFloat = 280 // Carousel (200) + PageControl (20) + SearchBar (60)
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: headerHeight))

        // Setup Carousel
        carouselCollectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        carouselCollectionView.isPagingEnabled = true
        carouselCollectionView.showsHorizontalScrollIndicator = false
        carouselCollectionView.delegate = self
        carouselCollectionView.dataSource = self
        carouselCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: AnimalListViewController.carouselCellID)
        headerView.addSubview(carouselCollectionView)

        // PageControl
        pageControl.frame = CGRect(x: 0, y: 200, width: view.frame.width, height: 20)
        pageControl.numberOfPages = viewModel.allCategories.count
        headerView.addSubview(pageControl)

        // SearchBar
        searchBar.frame = CGRect(x: 0, y: 220, width: view.frame.width, height: 60)
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        headerView.addSubview(searchBar)

        tableView.tableHeaderView = headerView
    }

    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension AnimalListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.allCategories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnimalListViewController.carouselCellID, for: indexPath)
        let category = viewModel.allCategories[indexPath.item]
        let imageView = UIImageView(image: UIImage(named: category.imageName))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.frame = cell.contentView.bounds

        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.contentView.addSubview(imageView)

        return cell
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = page
        viewModel.selectedCategory = viewModel.allCategories[page]
    }
}

extension AnimalListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.currentList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AnimalListViewController.tvCellIdentifier) ??
            UITableViewCell(style: .default, reuseIdentifier: AnimalListViewController.tvCellIdentifier)

        
        var content = cell.defaultContentConfiguration()
        content.text = viewModel.currentList[indexPath.row]
        content.secondaryText = viewModel.selectedCategory.listItemsSubTitle[indexPath.row]
        content.image = UIImage(named: viewModel.selectedCategory.listItemsImageNames[indexPath.row])
        content.imageProperties.maximumSize = CGSize(width: 40, height: 40)
        content.imageProperties.cornerRadius = 8
        content.imageProperties.reservedLayoutSize = CGSize(width: 44, height: 44)

        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator

        return cell

    }
}

extension AnimalListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchQuery = searchText
    }
}
