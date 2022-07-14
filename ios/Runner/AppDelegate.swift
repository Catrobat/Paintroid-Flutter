import UIKit
import Flutter
import Photos

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        FlutterMethodChannel(name: "org.catrobat.paintroid/photo_library",
                             binaryMessenger: controller.binaryMessenger)
        .setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch(call.method) {
            case "saveToPhotos":
                if let (filename, imageData) = self?.extractImageData(from: call, with: result) {
                    let access: PHAuthorizationStatus
                    if #available(iOS 14, *) {
                        access = PHPhotoLibrary.authorizationStatus(for: .addOnly)
                    } else {
                        access = PHPhotoLibrary.authorizationStatus()
                    }
                    switch(access) {
                    case .authorized, .notDetermined:
                        self?.saveImageToPhotos(imageData, filename, result)
                    default:
                        result(FlutterError(code: "PERMISSION_DENIED",
                                            message: "User explicitly denied access to add photos",
                                            details: nil))
                    }
                }
            default: result(FlutterMethodNotImplemented)
            }
        })
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func saveImageToPhotos(_ image: Data, _ name: String, _ result: @escaping FlutterResult) {
        PHPhotoLibrary.shared().performChanges {
            let options = PHAssetResourceCreationOptions()
            options.originalFilename = name
            let request = PHAssetCreationRequest.forAsset()
            request.addResource(with: .photo, data: image, options: options)
        } completionHandler: { success, error in
            if success {
                result(nil)
            } else {
                result(FlutterError(code: "SAVE_FAILED", message: "Could not save image to photo library.", details: error))
            }
        }
    }
    
    private func extractImageData(from call: FlutterMethodCall, with result: FlutterResult) -> (String, Data)? {
        guard let args = call.arguments as? [String:Any] else {
            result(FlutterError(code: "INVALID_ARGS",
                                message: "Arguments must be in a dictionary format with the key as String and value as dynamic",
                                details: call.arguments))
            return nil
        }
        guard let filename = args["fileName"] as? String else {
            result(FlutterError(code: "INVALID_FILE_NAME",
                                message: "File name is either not supplied or not of type String",
                                details: args["data"]))
            return nil
        }
        guard let imageBytes = args["data"] as? FlutterStandardTypedData else {
            result(FlutterError(code: "INVALID_IMAGE_DATA",
                                message: "Image data is either not supplied or not of type UInt8List",
                                details: args["data"]))
            return nil
        }
        return (filename, imageBytes.data)
    }
}
