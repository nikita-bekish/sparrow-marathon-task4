//
//  ViewController.swift
//  task4
//
//  Created by Nikita Bekish on 11.02.2024.
//

import UIKit

class ViewController: UITableViewController {
    
    // MARK: - Private properties
        
    private let cellReuseIdentifier = "cell"
    private lazy var dataSource = makeDataSource()
    
    private var characters = [String]()

    // MARK: - UITableViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...30 {
            characters.append("\(i)")
        }
        
        navigationItem.title = "Task 4"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Shuffle", style: .done, target: self, action: #selector(shuffle))
        tableView.register(CustomTableCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.rowHeight = 40
        update(with: characters)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? CustomTableCell
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = cell else { return }
        
        if cell.cellImage.image == nil {
            cell.cellImage.image = UIImage(systemName: "checkmark")

            let selectedRow = characters[indexPath.row]

            characters.remove(at: indexPath.row)
            characters.insert(selectedRow, at: 0)
           
            update(with: characters)
        } else {
            cell.cellImage.image = nil
        }
    }
}

extension ViewController {
    func makeDataSource() -> UITableViewDiffableDataSource<Section, String> {
        let reuseIdentifier = cellReuseIdentifier
        
        return UITableViewDiffableDataSource(tableView: tableView,
                                             cellProvider: { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CustomTableCell

            cell?.cellLabel.text = item
            return cell
        })
    }
    
    func update(with list: [String], animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        
        snapshot.appendSections([Section.default])
        
        snapshot.appendItems(list, toSection: .default)
                
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc func shuffle() {
        characters = characters.shuffled()
        update(with: characters)
    }
    
    enum Section {
        case `default`
    }
}

class CustomTableCell: UITableViewCell {
  
  var cellLabel: UILabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
  }()
  
  var cellImage: UIImageView = {
      let image = UIImageView()
      image.translatesAutoresizingMaskIntoConstraints = false
      return image
  }()
  
  var stackView: UIStackView = {
      let stack = UIStackView()
      stack.translatesAutoresizingMaskIntoConstraints = false
      stack.axis = .horizontal
      stack.distribution = .fillProportionally
      stack.alignment = .center
      return stack
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      
      setupUI()
  }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
  func setupUI() {
      stackView.addArrangedSubview(cellLabel)
      stackView.addArrangedSubview(cellImage)
      addSubview(stackView)
      
      NSLayoutConstraint.activate([
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
        stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
        stackView.topAnchor.constraint(equalTo: topAnchor),
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        
        cellImage.widthAnchor.constraint(equalToConstant: 30),
        cellImage.heightAnchor.constraint(equalToConstant: 30),
      ])
  }
}
