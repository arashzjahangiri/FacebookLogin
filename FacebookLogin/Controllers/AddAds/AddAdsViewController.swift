//
//  CategorySelectionViewController.swift
//  FacebookLogin
//
//  Created by Arash Z. Jahangiri on 08/08/16.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

import UIKit

class AddAdsViewController: BaseViewController {
  
  var categories: [Category] = []
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadCategories()
  }
  
  func loadCategories() {
    Api.sharedInstance.getCategories { categories in
      if categories != nil {
        self.categories = categories!
        self.tableView.reloadData()
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

extension AddAdsViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Select Category Cell", for: indexPath)
    
    let category = categories[(indexPath as NSIndexPath).row]
    
    cell.textLabel?.text = category.name
    cell.imageView?.image = UIImage(named: "cat_\((indexPath as NSIndexPath).row+1)")
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
