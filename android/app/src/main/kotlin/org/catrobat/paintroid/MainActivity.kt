package org.catrobat.paintroid

import android.Manifest
import android.content.ContentValues
import android.content.pm.PackageManager
import android.os.Build
import android.provider.MediaStore
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.IOException

class MainActivity : FlutterActivity() {
    private val hasWritePermission: Boolean
        get() = Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q ||
                ContextCompat.checkSelfPermission(
                    this@MainActivity,
                    Manifest.permission.WRITE_EXTERNAL_STORAGE
                ) == PackageManager.PERMISSION_GRANTED

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        setupPhotoLibraryChannel(flutterEngine)
        setupDeviceChannel(flutterEngine)
    }

    private fun setupDeviceChannel(flutterEngine: FlutterEngine) {
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, "org.catrobat.paintroid/device"
        ).apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "getHeightInPixels" -> {
                        val height = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                            windowManager.maximumWindowMetrics.bounds.height()
                        } else {
                            resources.displayMetrics.heightPixels
                        }
                        result.success(height.toDouble())
                    }
                    else -> result.notImplemented()
                }
            }
        }
    }

    private fun setupPhotoLibraryChannel(flutterEngine: FlutterEngine) {
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, "org.catrobat.paintroid/photo_library"
        ).apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "saveToPhotos" -> {
                        if (!hasWritePermission) {
                            result.error(
                                "PERMISSION_DENIED",
                                "User explicitly denied WRITE_EXTERNAL_STORAGE permission",
                                null
                            )
                            return@setMethodCallHandler
                        }
                        val (filename, imageData) = extractImageData(call, result)
                            ?: return@setMethodCallHandler
                        saveImageToPictures(filename, imageData)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
        }
    }

    private fun saveImageToPictures(filename: String, data: ByteArray) {
        val picturesUri = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            MediaStore.Images.Media.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
        } else {
            MediaStore.Images.Media.EXTERNAL_CONTENT_URI
        }
        val contentValues = ContentValues().apply {
            put(MediaStore.Images.Media.DISPLAY_NAME, filename)
            put(MediaStore.Images.Media.MIME_TYPE, "image/*")
        }
        contentResolver.insert(picturesUri, contentValues)?.also { uri ->
            contentResolver.openOutputStream(uri)?.use { outputStream ->
                outputStream.write(data)
            } ?: throw IOException("Could not open output stream for uri: $uri")
        } ?: throw IOException("Could not create image MediaStore entry")
    }

    private fun extractImageData(call: MethodCall, result: MethodChannel.Result): Pair<String, ByteArray>? {
        val filename = call.argument<String>("fileName") ?: run {
            result.error(
                "INVALID_FILENAME",
                "Image name is either not supplied or not of type String",
                null
            )
            return null
        }
        val imageData = call.argument<ByteArray>("data") ?: run {
            result.error(
                "INVALID_IMAGE_DATA",
                "Image data is either not supplied or not of type UInt8List",
                null
            )
            return null
        }
        return Pair(filename, imageData)
    }
}
