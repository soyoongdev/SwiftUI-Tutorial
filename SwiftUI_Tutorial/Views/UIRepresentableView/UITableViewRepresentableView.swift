//
//  UITableViewRepresentable.swift
//  ThietThachClient
//
//  Created by HauNguyen on 23/04/2022.
//

import SwiftUI
import UIKit
import Combine


final class HostingCell<Content: View>: UITableViewCell {
    var hostingController = UIHostingController<Content?>(rootView: nil)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        hostingController.view.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func settup(with view: Content, parentController: UIViewController) {
        self.hostingController.rootView = view
        self.hostingController.view.invalidateIntrinsicContentSize()

        let requiresControllerMove = hostingController.parent != parentController
        if requiresControllerMove {
            parentController.addChild(hostingController)
        }

        if !self.contentView.subviews.contains(hostingController.view) {
            self.contentView.addSubview(hostingController.view)
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            hostingController.view.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
            hostingController.view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
            hostingController.view.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
            hostingController.view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        }

        if requiresControllerMove {
            hostingController.didMove(toParent: parentController)
        }
    }
}

struct UITableViewRepresentable<Data, RowContent: View>: UIViewControllerRepresentable {
    let content: (Data) -> RowContent
    let data: [Data]
    let loadMore: () -> Void
    public var tableViewController = UITableViewController()
    
    init(_ data: [Data], _ loadMore: @escaping () -> Void, _ content: @escaping (Data) -> RowContent) {
        self.data = data
        self.loadMore = loadMore
        self.content = content
    }
    
    func makeUIViewController(context: Context) -> UITableViewController {
//        let tableViewController = UITableViewController()
        tableViewController.tableView.register(HostingCell<RowContent>.self, forCellReuseIdentifier: "Cell")
        tableViewController.tableView.translatesAutoresizingMaskIntoConstraints = false
        tableViewController.tableView.dataSource = context.coordinator
        tableViewController.tableView.delegate = context.coordinator
        tableViewController.tableView.separatorStyle = .none
        return tableViewController
    }
    
    func updateUIViewController(_ controller: UITableViewController, context: Context) {
        context.coordinator.data.append(contentsOf: self.data)
        controller.tableView.reloadData()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(data, loadMore, content, tableViewController)
    }
    
    class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {
        init(_ data: [Data], _ loadMore: (() -> Void)? = nil, @ViewBuilder _ content: @escaping (Data) -> RowContent, _ tableViewController : UITableViewController) {
            self.data = data
            self.loadMore = loadMore
            self.content = content
            self.tableViewController = tableViewController
        }
        
        private var content: (Data) -> RowContent
        public var data : [Data]
        private let loadMore : (() -> Void)?
        private let tableViewController: UITableViewController
        
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.data.count
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return self.data.count
        }
        
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? HostingCell<RowContent> else {
                return UITableViewCell()
            }
            let data = self.data[indexPath.row]
            let view = content(data)
            DispatchQueue.global(qos: .background).async {
                if indexPath.row == self.data.count - 1 {
                    self.loadMore?()
                }
            }
            tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
            tableViewCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            tableViewCell.settup(with: view, parentController: self.tableViewController)
            return tableViewCell
        }
        
        
    }
    
    
//    private class HostingCell<Content: View>: UITableViewCell {
//        var host: UIHostingController<Content>?
//
//        func setup(with view: Content) {
//            if host == nil {
//                let controller = UIHostingController(rootView: view)
//                host = controller
//
//                guard let content = controller.view else { return }
//                content.translatesAutoresizingMaskIntoConstraints = false
//                contentView.addSubview(content)
//
//                content.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//                content.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
//                content.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//                content.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
//            } else {
//                host?.rootView = view
//            }
//            setNeedsLayout()
//        }
//    }
}

struct DemoUITableViewRepresentable: View {
    @State var numbers = [Int]()
    
    var body: some View {
        UITableViewRepresentable(numbers, loadMore) { number in
            HStack {
                Text("This is number \(number)")
                Spacer()
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color.gray.opacity(0.5)))
            .padding()
        }
        .onAppear() {
            self.numbers = listNumbers
        }
    }
    
    func loadMore() {
        self.numbers.append(contentsOf: listNumbers)
    }
}

private var listNumbers: [Int] = [Int(0), Int(1), Int(2), Int(3), Int(4), Int(5), Int(6), Int(7), Int(8), Int(9), Int(10)]


struct UITableViewRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        DemoUITableViewRepresentable()
    }
}
