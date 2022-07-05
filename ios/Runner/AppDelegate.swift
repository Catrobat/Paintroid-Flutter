import UIKit
import Flutter
import Photos

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var photoLibraryChannel: FlutterMethodChannel? = nil
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        photoLibraryChannel = FlutterMethodChannel(name: "org.catrobat.paintroid/photo_library",
                                                   binaryMessenger: controller.binaryMessenger)
        photoLibraryChannel?.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch(call.method) {
            case "saveToPhotos":
                if let imageData = self?.extractImageData(from: call, with: result) {
                    guard let image = UIImage(data: imageData) else {
                        result(FlutterError(code: "INVALID_IMAGE",
                                            message: "Could not convert supplied data to UIImage",
                                            details: nil))
                        return
                    }
                    let access: PHAuthorizationStatus
                    if #available(iOS 14, *) {
                        access = PHPhotoLibrary.authorizationStatus(for: .addOnly)
                    } else {
                        access = PHPhotoLibrary.authorizationStatus()
                    }
                    switch(access) {
                    case .denied:
                        result(FlutterError(code: "ACCESS_DENIED",
                                            message: "User explicitly denied access to add photos",
                                            details: nil))
                    case .authorized, .notDetermined:
                        self?.saveImageToPhotos(image)
                    default:
                        result(FlutterError(code: "UNKNOWN_ACCESS",
                                            message: "Don't have appropriate access to add photos",
                                            details: access))
                    }
                }
            default: result(FlutterMethodNotImplemented)
            }
        })
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func saveImageToPhotos(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage,
                     didFinishSavingWithError error: Error?,
                     contextInfo: UnsafeRawPointer) {
        if let error = error {
            photoLibraryChannel?.invokeMethod("saveToPhotosCallback", arguments: [
                "success": false,
                "error": "Could not save image to gallery. \nDETAIL - \(error)",
            ])
        } else {
            photoLibraryChannel?.invokeMethod("saveToPhotosCallback", arguments: ["success": true])
        }
    }
    
    private func extractImageData(from call: FlutterMethodCall, with result: FlutterResult) -> Data? {
        guard let args = call.arguments as? [String:Any] else {
            result(FlutterError(code: "INVALID_ARGS",
                                message: "Arguments must be in a dictionary format with the key as String and value as dynamic",
                                details: call.arguments))
            return nil
        }
        guard let imageBytes = args["data"] as? FlutterStandardTypedData else {
            result(FlutterError(code: "INVALID_IMAGE_DATA",
                                message: "Image data is either not supplied or not of type UInt8List",
                                details: args["data"]))
            return nil
        }
        return imageBytes.data
    }
}
