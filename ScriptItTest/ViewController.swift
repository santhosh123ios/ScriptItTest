//
//  ViewController.swift
//  ScriptItTest
//
//  Created by santhosh thalil on 12/05/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    struct ListItem {
        let name: String
        let description: String
    }
    
    @IBOutlet weak var tableView: UITableView!
    var collectionView: UICollectionView!

    let searchBar = UISearchBar()

    var images: [UIImage] = []
    var allItems: [[ListItem]] = []
    var filteredItems: [ListItem] = []
    var selectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let nibName = UINib(nibName: "TableItemCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "TableItemCell")
        
        
        setupData()
        setupTableView()
        setupCarouselHeader()
        setupFloatingButton()
        searchBar.placeholder = "Search"
    }
    
    func setupFloatingButton(){
        let fabButton: UIButton = {
            let button = UIButton(type: .custom)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .systemBlue
            button.tintColor = .white
            button.setImage(UIImage(systemName: "chart.bar.fill"), for: .normal)
            button.layer.cornerRadius = 30
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOpacity = 0.3
            button.layer.shadowOffset = CGSize(width: 0, height: 5)
            return button
        }()
        
        view.addSubview(fabButton)
        NSLayoutConstraint.activate([
            fabButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            fabButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            fabButton.widthAnchor.constraint(equalToConstant: 60),
            fabButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        fabButton.addTarget(self, action: #selector(showStats), for: .touchUpInside)
    }
    
    @objc func showStats() {
        let currentItems = allItems[selectedIndex]
        var characterCounts: [Character: Int] = [:]

        for item in currentItems {
            let allCharacters = item.name.lowercased().filter { $0.isLetter }
            for char in allCharacters {
                characterCounts[char, default: 0] += 1
            }
        }

        let sortedChars = characterCounts.sorted { $0.value > $1.value }.prefix(3)

        let statText = """
        List \(selectedIndex + 1) (\(currentItems.count) items)
        \(sortedChars.map { "\($0.key) = \($0.value)" }.joined(separator: "\n"))
        """

        let bottomSheet = UIView(frame: CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 200))
        bottomSheet.backgroundColor = .systemGray6
        bottomSheet.layer.cornerRadius = 20
        bottomSheet.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        let label = UILabel(frame: CGRect(x: 20, y: 20, width: bottomSheet.frame.width - 40, height: 160))
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.monospacedSystemFont(ofSize: 16, weight: .medium)
        label.text = statText

        bottomSheet.addSubview(label)
        view.addSubview(bottomSheet)

        UIView.animate(withDuration: 0.3) {
            bottomSheet.frame.origin.y = self.view.frame.height - 200
        }

        // Tap to dismiss
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissSheet(_:)))
        view.addGestureRecognizer(tap)
        bottomSheet.tag = 2025
    }

    @objc func dismissSheet(_ sender: UITapGestureRecognizer) {
        if let sheet = view.viewWithTag(2025) {
            UIView.animate(withDuration: 0.3, animations: {
                sheet.frame.origin.y = self.view.frame.height
            }, completion: { _ in
                sheet.removeFromSuperview()
            })
        }
    }

    func setupData() {
        images = [UIImage(named: "img1")!, UIImage(named: "img2")!,UIImage(named: "img3")!, UIImage(named: "img4")!, UIImage(named: "img5")!]
        allItems = [
            [ // Category 1: Fruits
                ListItem(name: "Apple", description: "A tasty red fruit rich in fiber."),
                ListItem(name: "Banana", description: "A yellow fruit high in potassium."),
                ListItem(name: "Cherry", description: "Small, round, and sweet."),
                ListItem(name: "Date", description: "A sweet fruit from the desert."),
                ListItem(name: "Elderberry", description: "Used in syrups and medicinal remedies."),
                ListItem(name: "Fig", description: "A fruit with a chewy texture and seeds."),
                ListItem(name: "Grapes", description: "Juicy fruits used in wine and snacks."),
                ListItem(name: "Honeydew", description: "A sweet green melon."),
                ListItem(name: "Indian Fig", description: "Also known as prickly pear."),
                ListItem(name: "Jackfruit", description: "A large tropical fruit with sweet flesh.")
            ],
            [ // Category 2: Animals
                ListItem(name: "Elephant", description: "The largest land animal."),
                ListItem(name: "Frog", description: "An amphibian that hops."),
                ListItem(name: "Giraffe", description: "Tall animal with a long neck."),
                ListItem(name: "Horse", description: "Used for riding and racing."),
                ListItem(name: "Iguana", description: "A large herbivorous lizard."),
                ListItem(name: "Jaguar", description: "A powerful big cat from the Americas."),
                ListItem(name: "Kangaroo", description: "A marsupial that hops and carries young."),
                ListItem(name: "Lion", description: "Known as the king of the jungle."),
                ListItem(name: "Monkey", description: "A playful primate."),
                ListItem(name: "Narwhal", description: "A whale with a long spiral tusk.")
            ],
            [ // Category 3: Gadgets
                ListItem(name: "Laptop", description: "Used for computing and coding."),
                ListItem(name: "Smartphone", description: "A device for communication and media."),
                ListItem(name: "Tablet", description: "A touch-based computing device."),
                ListItem(name: "Smartwatch", description: "A wearable tech accessory."),
                ListItem(name: "Camera", description: "Used for taking photos and videos."),
                ListItem(name: "Headphones", description: "Audio device worn on ears."),
                ListItem(name: "Drone", description: "A flying gadget with a camera."),
                ListItem(name: "VR Headset", description: "Used for virtual reality experiences."),
                ListItem(name: "Game Console", description: "Used for video gaming."),
                ListItem(name: "Bluetooth Speaker", description: "Wireless sound device.")
            ],
            [ // Category 4: Vehicles
                ListItem(name: "Car", description: "Used for traveling long distances."),
                ListItem(name: "Bike", description: "Two-wheeled vehicle powered by pedaling."),
                ListItem(name: "Truck", description: "Heavy-duty vehicle for transporting goods."),
                ListItem(name: "Bus", description: "Public transportation for many passengers."),
                ListItem(name: "Scooter", description: "Small vehicle for city commutes."),
                ListItem(name: "Motorcycle", description: "Two-wheeled motor vehicle."),
                ListItem(name: "Tram", description: "Electric streetcar system."),
                ListItem(name: "Airplane", description: "Used for flying across countries."),
                ListItem(name: "Boat", description: "Used for travel on water."),
                ListItem(name: "Helicopter", description: "A flying vehicle that hovers.")
            ],
            [ // Category 5: Space & Nature
                ListItem(name: "Sun", description: "The star at the center of our solar system."),
                ListItem(name: "Moon", description: "Earth’s natural satellite."),
                ListItem(name: "Star", description: "A glowing ball of gas in space."),
                ListItem(name: "Planet", description: "Orbits a star in a solar system."),
                ListItem(name: "Galaxy", description: "A massive system of stars."),
                ListItem(name: "Meteor", description: "A rock from space that burns in atmosphere."),
                ListItem(name: "Comet", description: "An icy space body with a glowing tail."),
                ListItem(name: "Nebula", description: "A cloud of gas and dust in space."),
                ListItem(name: "Black Hole", description: "A region in space with extreme gravity."),
                ListItem(name: "Aurora", description: "Natural light display in the sky.")
            ]
        ]
           filteredItems = allItems[0]
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ??
                   UITableViewCell(style: .subtitle, reuseIdentifier: "cell")

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    func setupCarouselHeader() {
        let headerHeight: CGFloat = 220

        // Container view for carousel + page control
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: headerHeight))

        // Set up collection view
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width, height: 200)
        layout.minimumLineSpacing = 0

        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200), collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "carouselCell")

        headerView.addSubview(collectionView)

        // Page control (dots)
        let pageControl = UIPageControl(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 40))
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.tag = 999 // use tag to access it later
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        headerView.addSubview(pageControl)

        tableView.tableHeaderView = headerView
    }

    // MARK: - TableView DataSource

    func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        searchBar.delegate = self
        return searchBar
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return 87
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableItemCell", for: indexPath) as! TableItemCell
        let item = filteredItems[indexPath.row]
        cell.titleLabel?.text = item.name
        cell.detailLabel?.text = item.description
        cell.titleLabel?.font = .boldSystemFont(ofSize: 16)
        cell.detailLabel?.font = .systemFont(ofSize: 13)
        cell.imgView.layer.cornerRadius = 10
        if let url = URL(string: "https://picsum.photos/seed/\(item.name)/60") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.imgView?.image = image
                    }
                }
            }.resume()
        }
        cell.selectionStyle = .none
        cell.bgView.backgroundColor = #colorLiteral(red: 0.8235294118, green: 0.9058823529, blue: 0.8823529412, alpha: 1)
        cell.bgView.layer.cornerRadius = 10
        return cell
    }

    // MARK: - CollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carouselCell", for: indexPath)
        let imageView = UIImageView(image: images[indexPath.item])
        imageView.frame = cell.contentView.bounds
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.contentView.addSubview(imageView)
        return cell
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
            selectedIndex = page

            // Update page control
            if let pageControl = tableView.tableHeaderView?.viewWithTag(999) as? UIPageControl {
                pageControl.currentPage = page
            }

            filterContent(for: searchBar.text)
        }
    }

    // MARK: - Search Filtering

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContent(for: searchText)
    }

    func filterContent(for text: String?) {
        guard let text = text, !text.isEmpty else {
            filteredItems = allItems[selectedIndex]
            tableView.reloadData()
            return
        }

        filteredItems = allItems[selectedIndex].filter {
            $0.name.lowercased().contains(text.lowercased()) ||
            $0.description.lowercased().contains(text.lowercased())
        }

        tableView.reloadData()
    }
}
