//
//  RemindersViewController.swift
//  GeoReminders
//
//  Created by Developer on 15/03/2025.
//

import UIKit
import CoreData

class RemindersViewController: UITableViewController {
    private let viewModel = RemindersViewModel()
    private var fetchedResultsController: NSFetchedResultsController<Reminder>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.allowsSelection = false
        navigationItem.title = "Reminders"
    }
    
    private func setupFetchedResultsController() {
        let request: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: viewModel.context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let reminder = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = "\(reminder.name ?? "") - Radius: \(Int(reminder.radius))m - \(reminder.note ?? "")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let reminder = fetchedResultsController.object(at: indexPath)
            viewModel.deleteReminder(reminder)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
