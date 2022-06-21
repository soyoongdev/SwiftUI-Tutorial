//
//  VideoPicker.swift
//  SwiftUI_Tutorial
//
//  Created by HauNguyen on 17/06/2022.
//

import SwiftUI
import AVKit
import LightCompressor
import PhotosUI


struct DemoVideoPickerView: View {
    @State var url: URL? = URL(string: "") ?? URL(string: noImage)!
    @State var isPresented: Bool = false
    @StateObject private var viewModel = VideoPickerViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                
                Group {
                    Text("URL: " + "\(self.url?.absoluteString ?? "")")

                    Text("Before size: " + "\(viewModel.originalSize)")
                    
                    Text("Alfter size: " + "\(viewModel.sizeAfterCompression)")
                    
                    Text("duration: " + "\(viewModel.duration)")
                    
                    Text("progress: " + "\(viewModel.progress)")
                    
                    Text("percent: " + "\(viewModel.percent)")
                    
                }
                                
                Button(action: {
                    self.isPresented = true
                }) {
                    Text("show")
                    
                }
                
            }
            .sheet(isPresented: $isPresented) {
                VideoPickerView(url: $url, viewModel: viewModel)
            }
            
        }
    }
}

struct VideoPickerView: View {
    // init
    @Binding var url: URL?
    @ObservedObject var viewModel : VideoPickerViewModel

    var body: some View {
        VideoPicker(url: $url, viewModel: viewModel)
            .animateProgressView(isPresented: $viewModel.isShowProgress, progress: $viewModel.progress, complete: complete, cancel: cancel)
    }
    
    func cancel() {
        self.viewModel.compression.cancel = true
        self.viewModel.isShowProgress = false
    }
    
    func complete() {
        print("Complete")
        self.viewModel.isShowProgress = false
    }
}

class VideoPickerViewModel: ObservableObject {
    @Published var currentState : CurrentState = .unknow
    
    enum CurrentState {
        case onStart
        case onSuccess
        case onFailure
        case onCancelled
        case unknow
    }
    
    @Published var isShowProgress: Bool = false
    
    @Published var originalSize: CGFloat = 0
    
    @Published var sizeAfterCompression: CGFloat = 0
    
    @Published var duration: CGFloat = 0
    
    @Published var progress: CGFloat = 0
    
    @Published var percent: CGFloat = 0
    
    @Published var thumbnailOfVideo: CGImage?
    
    @Published var compression: Compression = Compression()
}


struct VideoPicker: UIViewControllerRepresentable {
    @Binding var url: URL?

    @ObservedObject var viewModel: VideoPickerViewModel
    
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> ViewController { //Done 👈
        return ViewController(coordinator: context.coordinator)
    }
    
    func updateUIViewController(_ viewController: ViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - ViewController
    
    class ViewController: UIImagePickerController {
        init(coordinator: VideoPicker.Coordinator? = nil) {
            self.coordinator = coordinator
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        let coordinator: Coordinator?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.setup()
        }
        
        func setup() {
            let imagePickerController = self
                    
            imagePickerController.delegate = self.coordinator
            imagePickerController.dismiss(animated: true, completion: nil)
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.mediaTypes = ["public.movie"]
            imagePickerController.videoQuality = .typeHigh
            imagePickerController.videoExportPreset = AVAssetExportPresetPassthrough
            
        }
        
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        init(_ parent: VideoPicker? = nil) {
            self.parent = parent
        }
        
        var parent: VideoPicker?
        
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            // Get source video
            
            let videoToCompress = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerMediaURL")] as! URL
            
            let thumbnail = self.createThumbnailOfVideoFromFileURL(videoURL: videoToCompress.absoluteString)
            
            self.parent?.viewModel.thumbnailOfVideo = thumbnail!
            
            DispatchQueue.main.async { [unowned self] in
                self.parent?.viewModel.originalSize = CGFloat((videoToCompress.fileSizeInMB() as NSString).floatValue)
                print("OriginalSize: \(String(describing: self.parent?.viewModel.originalSize))")
            }
            
            // Declare destination path and remove anything exists in it
            let destinationPath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("compressed.mp4") as URL
            try? FileManager.default.removeItem(at: destinationPath)
            
            let startingPoint = Date()
            let videoCompressor = LightCompressor()
            
            self.parent?.viewModel.compression = videoCompressor.compressVideo(
                source: videoToCompress,
                destination: destinationPath,
                quality: .high,
                isMinBitRateEnabled: true,
                keepOriginalResolution: false,
                progressQueue: .main,
                progressHandler: { progress in
                    DispatchQueue.main.async { [unowned self] in
                        self.parent?.viewModel.progress = CGFloat(progress.fractionCompleted * 100)
                        print("\(String(describing: self.parent?.viewModel.progress))")
                    }
                },
                completion: { [weak self] result in
                    guard let `self` = self else { return }
                    
                    switch result {
                        
                    case .onSuccess(let path):
                        DispatchQueue.main.async { [unowned self] in
                            
                            self.parent?.viewModel.sizeAfterCompression = CGFloat((path.fileSizeInMB() as NSString).doubleValue)
                            
                            print("SizeAfterCompression: \(String(describing: self.parent?.viewModel.sizeAfterCompression))")
                            
                            self.parent?.viewModel.duration = CGFloat((String(format: "%.2f", startingPoint.timeIntervalSinceNow * -1) as NSString).floatValue)
                            
                            print("Duration: \(String(describing: self.parent?.viewModel.duration))")
                            
                            PHPhotoLibrary.shared().performChanges({
                                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: path)
                            })
                        }
                        
                        if let videoURL = info[UIImagePickerController.InfoKey.mediaURL]as? URL {
                            self.parent?.url = videoURL
                            
                            print("URL: \(videoURL.absoluteString)")
                        }
                        print("onSuccess: \(path.absoluteString)")
                        
                        self.parent?.presentationMode.wrappedValue.dismiss()
                        self.parent?.viewModel.currentState = .onSuccess
                        self.parent?.viewModel.isShowProgress = false
                        
                    case .onStart:
                        self.parent?.viewModel.currentState = .onStart
                        self.parent?.viewModel.isShowProgress = true
                        
                    case .onFailure(let error):
                        self.parent?.viewModel.currentState = .onFailure
                        self.parent?.presentationMode.wrappedValue.dismiss()
                        print("onFailure: \n")
                        print("Title: \(error.title)")
                        print("Description: \(String(describing: error.errorDescription))")
                        print("Reason: \(String(describing: error.failureReason))")
                        print("Help anchor: \(String(describing: error.helpAnchor))")
                        print("Suggestion: \(String(describing: error.recoverySuggestion))")
                        print("End...")
                        
                    case .onCancelled:
                        self.parent?.viewModel.currentState = .onCancelled
                        self.parent?.viewModel.isShowProgress = false
                        self.parent?.presentationMode.wrappedValue.dismiss()
                        print("---------------------------")
                        print("Cancelled")
                        print("---------------------------")
                        
                    }
                }
            )
        }
        
        
        
        func createThumbnailOfVideoFromFileURL(videoURL: String) -> CGImage? {
            let asset = AVAsset(url: URL(string: videoURL)!)
            let assetImgGenerate = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true
            let time = CMTimeMakeWithSeconds(Float64(1), preferredTimescale: 100)
            do {
                let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                return img
            } catch {
                return nil
            }
        }
    }
}
