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
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                
                Button(action: {
                    self.isPresented = true
                }) {
                    Text("show")
                    
                }
                
            }
            .sheet(isPresented: $isPresented) {
                VideoPickerView(url: $url)
            }
            
        }
    }
}

struct VideoPickerView: UIViewControllerRepresentable {
    init(url: Binding<URL?>) {
        self._url = url
    }
    @Binding private var url: URL?
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController { //Done 👈
        
        let imagePickerController = UIImagePickerController()
                
        imagePickerController.delegate = context.coordinator
        imagePickerController.dismiss(animated: true, completion: nil)
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = ["public.movie"]
        imagePickerController.videoQuality = .typeHigh
        imagePickerController.videoExportPreset = AVAssetExportPresetPassthrough
        
        return imagePickerController
    }
    
    func updateUIViewController(_ viewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        init(_ parent: VideoPickerView) {
            self.parent = parent
        }
        
        var parent: VideoPickerView
        
        var compression: Compression?
        
        var onStart: (() -> Void)?
        
        var onSuccess: ((URL) -> Void)?
        
        var onFailure: ((CompressionError) -> Void)?
        
        var onCancelled: (() -> Void)?
        
        var originalSize: CGFloat = 0
        
        var sizeAfterCompression: CGFloat = 0
        
        var duration: CGFloat = 0
        
        var progress: CGFloat = 0
        
        var percent: CGFloat = 0
                
        var thumbnailOfVideo: UIImage = UIImage()
        
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            // Get source video
            
            let videoToCompress = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerMediaURL")] as! URL
            
            let thumbnail = self.createThumbnailOfVideoFromFileURL(videoURL: videoToCompress.absoluteString)
            
            self.thumbnailOfVideo = UIImage(cgImage: thumbnail!)
            
            DispatchQueue.main.async { [unowned self] in
                self.originalSize = CGFloat((videoToCompress.fileSizeInMB() as NSString).floatValue)
                print("OriginalSize: \(self.originalSize)")
            }
            
            // Declare destination path and remove anything exists in it
            let destinationPath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("compressed.mp4") as URL
            try? FileManager.default.removeItem(at: destinationPath)
            
            let videoCompressor = LightCompressor()
                        
            self.compression = videoCompressor.compressVideo(
                source: videoToCompress,
                destination: destinationPath,
                quality: .high,
                isMinBitRateEnabled: true,
                keepOriginalResolution: false,
                progressQueue: .main,
                progressHandler: { progress in
                    DispatchQueue.main.async { [unowned self] in
                        let progress = CGFloat(progress.fractionCompleted * 100)
                        self.progress = progress
                        print("Progress: \(progress)")
                    }
                },
                completion: { [weak self] result in
                    guard let `self` = self else { return }
                    
                    switch result {
                        
                    case .onSuccess(let path):
                        DispatchQueue.main.async { [unowned self] in
                            let sizeAfterCompression = CGFloat((path.fileSizeInMB() as NSString).doubleValue)
                            let duration = CGFloat(Date().timeIntervalSinceNow * -1)
                            
                            self.sizeAfterCompression = sizeAfterCompression
                            
                            print("SizeAfterCompression: \(sizeAfterCompression)")
                            
                            self.duration = duration
                            
                            print("Duration: \(duration)")
                            
                            PHPhotoLibrary.shared().performChanges({
                                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: path)
                            })
                            
                            self.onSuccess?(path)
                        }
                        
                        if let videoURL = info[UIImagePickerController.InfoKey.mediaURL]as? URL {
                            self.parent.url = videoURL
                            
                            print("URL: \(videoURL.absoluteString)")
                        }
                        print("onSuccess: \(path.absoluteString)")
                        
                        self.parent.presentationMode.wrappedValue.dismiss()
                        
                    case .onStart:
                        print("onStart")
                        self.onStart?()
                        
                    case .onFailure(let error):
                        self.onFailure?(error)
                        print("onFailure: \n")
                        print("Title: \(error.title)")
                        print("Description: \(String(describing: error.errorDescription))")
                        print("Reason: \(String(describing: error.failureReason))")
                        print("Help anchor: \(String(describing: error.helpAnchor))")
                        print("Suggestion: \(String(describing: error.recoverySuggestion))")
                        print("End...")
                        
                    case .onCancelled:
                        self.onCancelled?()
                        print("---------------------------")
                        print("Cancelled")
                        print("---------------------------")
                        
                    }
                }
            )
            
            //self.imagePickerController.dismiss(animated: true, completion: nil)

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

