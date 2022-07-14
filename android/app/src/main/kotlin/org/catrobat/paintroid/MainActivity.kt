package org.catrobat.paintroid

import android.Manifest
import android.content.ContentValues
import android.content.pm.PackageManager
import android.os.Build
import android.provider.MediaStore
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.IOException

class MainActivity : FlutterActivity() {
    private val externalStorageRequestCode = 123
    private var photoLibraryChannel: MethodChannel? = null
    private var saveImageData: Pair<String, ByteArray>? = null

    private val hasWritePermission: Boolean
        get() = Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q ||
                ContextCompat.checkSelfPermission(
                    this@MainActivity,
                    Manifest.permission.WRITE_EXTERNAL_STORAGE
                ) == PackageManager.PERMISSION_GRANTED

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        photoLibraryChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, "org.catrobat.paintroid/photo_library"
        ).apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "saveToPhotos" -> {
                        saveImageData = extractImageData(call, result)
                            ?: return@setMethodCallHandler
                        if (!hasWritePermission) {
                            ActivityCompat.requestPermissions(
                                this@MainActivity,
                                arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE),
                                externalStorageRequestCode
                            )
                        } else {
                            saveImageToPictures()
                        }
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
        }
    }

    private fun saveImageToPictures() {
        saveImageData?.let {
            val (filename, data) = it
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
            photoLibraryChannel?.invokeMethod("saveToPhotosCallback", mapOf("success" to true))
            saveImageData = null
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        when (requestCode) {
            externalStorageRequestCode -> {
                if (!grantResults.contains(PackageManager.PERMISSION_DENIED)) {
                    saveImageToPictures()
                } else {
                    photoLibraryChannel?.invokeMethod(
                        "saveToPhotosCallback", mapOf(
                            "success" to false,
                            "error" to "Permission denied to save in external storage"
                        )
                    )
                }
            }
        }
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
