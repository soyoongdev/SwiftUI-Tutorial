//
//  URLRequestApiExample.swift
//  Swiftui Tutorials
//
//  Created by Hau Nguyen on 19/09/2021.
//

import SwiftUI
import PartialSheet


class PromotionViewModel: ObservableObject {
    @Published var promotion: [Promotion] = []
    @Published var vendors: [Vendors] = []
}

// Create model
struct UploadJsonRequest: Codable {
    var filter: Filter
    var searchTerm: String
    var paginator: Paginator
    var sorting: Sorting
}

struct URLRequestApiExample: View {
    // Add data to the model
    let uploadDataModel = UploadJsonRequest(
        filter: Filter(),
        searchTerm: "",
        paginator: Paginator(),
        sorting: Sorting())
    
    @StateObject var promotion = PromotionViewModel()
    @State private var progress: Double = 0
    private let total: Double = 1
    @State private var dataTask: URLSessionDataTask?
    @State private var observation: NSKeyValueObservation?
    @State private var image: UIImage?
    @State var isSheetShown = false
    
    var body: some View {
        VStack {
            Button(action: {
                self.isSheetShown = true
            }, label: {
                Text("Display the ViewModifier sheet")
            })
            .partialSheet(isPresented: $isSheetShown) {
                Text("This is a Partial Sheet")
            }
        }
        .onAppear(){
            postMethod()
            getVendors()
        }
        
    }
    
    func loadingImage(urlImage: String) {
        guard let url = URL(string: urlImage) else { return }
        
        dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            self.observation?.invalidate()
            
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
        
        observation = dataTask?.progress.observe(\.fractionCompleted) {observationProgress , _ in
            DispatchQueue.main.async {
                self.progress = observationProgress.fractionCompleted
            }
        }
        dataTask?.resume()
    }
    
    func postMethod() {
        guard let url = URL(string: "https://api.thietthach.maytech.vn/api/products/find") else {
            print("Error: cannot create URL")
            return
        }
        
        // Convert model to JSON data
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(uploadDataModel)
        
//        print(String(data: data, encoding: .utf8) ?? "default value")
        
        guard let jsonData = try? JSONEncoder().encode(uploadDataModel) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        // Create the url request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
        request.httpBody = jsonData
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling POST")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    print("Error: Couldn't print JSON in String")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let result: QueryResponse<Promotion> = try decoder.decode(QueryResponse<Promotion>.self, from: prettyJsonData)
                    result.items.forEach{ product in
                        DispatchQueue.main.async {
                            self.promotion.promotion.append(product)
                        }
                    }
//                    print("Result: \(result.items)")
                }
                catch let jsonError {
                    print("Erorr GetList at:>>> \(jsonError.localizedDescription)")
                }
                
                
//                print(prettyPrintedJson)
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
    
    func getVendors() {
        guard let url = URL(string: "https://api.thietthach.maytech.vn/api/vendors") else { fatalError("Missing URL") }

        let urlRequest = URLRequest(url: url)

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedVendors = try JSONDecoder().decode([Vendors].self, from: data)
                        
                        DispatchQueue.main.async {
                            self.promotion.vendors = decodedVendors
                            print("Vendors: \(self.promotion.vendors)")
                        }
                        
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }

        dataTask.resume()
    }
}

struct ResponseModel: Codable {
    public var items: [Promotion]
    public var total : Int32 = 0
    public var errorCode : String?
    public var errorMessage : String?
}

public struct QueryResponse<T : Codable> : Codable {
    public var items = [] as [T]
    public var total : Int32 = 0
    public var errorCode : String?
    public var errorMessage : String?
}

struct Filter: Codable {
    var status: Int64 = -1
    var vendorId: Int64 = -1
    var price: Int64 = -1
    var expiredDate: String? // "null"
}


struct Paginator: Codable {
    var page: Int64 = 1
    var pageSize: Int64 = 10
}

struct Sorting: Codable {
    var column: String = "id"
    var direction: String = "asc"
}

public struct Promotion: Codable {
//    public var id = UUID().uuidString
    public var productId: Int
    public var postId: Int
    public var vendorId: Int
    public var productName: String
    public var productStatus: Int
    public var voucherType: Int
    public var quantity: Int
    public var price: Int
    public var expiredDate: String
    public var vendorName: String
    public var postContent: String
    public var postFeaturedImage: String
    public var postFeaturedImageId: Int
    public var usedQuantity: Int
}

public struct Vendors: Codable {
    public var id: Int? { return vendorId }
    public init(){}
    
    public var vendorId: Int? = 0
    public var vendorName: String? = "vendorName"
    public var vendorStatus: Int? = 0
    public var featuredImageId: Int? = 0
    public var featuredImage: String? = "featuredImage"
    public var content: String? = "content"
}



struct URLRequestApiExample_Previews: PreviewProvider {
    static var previews: some View {
        URLRequestApiExample(promotion: PromotionViewModel())
    }
}
