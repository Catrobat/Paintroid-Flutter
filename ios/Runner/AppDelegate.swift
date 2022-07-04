import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let photoGalleryChannel = FlutterMethodChannel(name: "org.catrobat.paintroid/photo_gallery",
                                                       binaryMessenger: controller.binaryMessenger)
        photoGalleryChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            guard call.method == "saveToPhotos" else {
                result(FlutterMethodNotImplemented)
                return
            }
            if let imageData = self?.extractImageData(from: call, with: result) {
                guard let image = UIImage(data: imageData) else {
                    result(FlutterError(code: "INVALID_IMAGE",
                                        message: "Could not convert supplied data to UIImage",
                                        details: nil))
                    return
                }
                var result = result
                withUnsafeMutablePointer(to: &result) { ptr in
                    UIImageWriteToSavedPhotosAlbum(image, self, #selector(self?.image(_:didFinishSavingWithError:contextInfo:)), ptr)
                }
            }
        })
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    @objc func image(_ image: UIImage,
                     didFinishSavingWithError error: Error?,
                     contextInfo: UnsafeRawPointer) {
        if let error = error {
            let result = contextInfo.load(as: FlutterResult.self)
            result(FlutterError(code: "IMAGE_SAVE_ERROR",
                                message: "Could not save image to gallery. Could be because user denied permission to use photos",
                                details: error))
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
