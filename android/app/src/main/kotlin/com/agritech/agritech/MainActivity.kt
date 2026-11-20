package com.agritech.agritech

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.ImageFormat
import android.graphics.Matrix
import android.hardware.camera2.CameraAccessException
import android.hardware.camera2.CameraCaptureSession
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraDevice
import android.hardware.camera2.CameraManager
import android.hardware.camera2.CaptureRequest
import android.media.ExifInterface
import android.media.ImageReader
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.HandlerThread
import android.view.Surface
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.TextureRegistry
import java.io.File
import java.io.FileOutputStream
import kotlin.math.min

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "com.agritech.agritech/diagnosis_media"
        private const val REQ_CAMERA_PERMISSION = 7001
        private const val REQ_PICK_GALLERY = 7002
    }

    private var pendingCameraResult: MethodChannel.Result? = null
    private var pendingGalleryResult: MethodChannel.Result? = null

    private var surfaceTextureEntry: TextureRegistry.SurfaceTextureEntry? = null
    private var cameraDevice: CameraDevice? = null
    private var captureSession: CameraCaptureSession? = null
    private var imageReader: ImageReader? = null
    private var backgroundThread: HandlerThread? = null
    private var backgroundHandler: Handler? = null
    private var sensorOrientationDegrees: Int = 90

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startCameraPreview" -> {
                    handleStartCameraPreview(flutterEngine, result)
                }
                "captureCameraPhoto" -> {
                    handleCaptureCameraPhoto(result)
                }
                "stopCameraPreview" -> {
                    closeCameraResources()
                    result.success(true)
                }
                "pickGalleryImage" -> {
                    handlePickGalleryImage(result)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun handleStartCameraPreview(
        flutterEngine: FlutterEngine,
        result: MethodChannel.Result
    ) {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA)
            != PackageManager.PERMISSION_GRANTED
        ) {
            pendingCameraResult = result
            ActivityCompat.requestPermissions(
                this,
                arrayOf(Manifest.permission.CAMERA),
                REQ_CAMERA_PERMISSION
            )
            return
        }
        openBackCameraPreview(flutterEngine, result)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == REQ_CAMERA_PERMISSION) {
            val res = pendingCameraResult
            pendingCameraResult = null
            if (res != null) {
                if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    val engine = flutterEngine
                    if (engine != null) {
                        openBackCameraPreview(engine, res)
                    } else {
                        res.error("NO_ENGINE", "FlutterEngine not ready", null)
                    }
                } else {
                    res.error(
                        "PERMISSION_DENIED",
                        "تم رفض إذن الكاميرا. يرجى السماح بالوصول إلى الكاميرا لتصوير ورقة البن.",
                        null
                    )
                }
            }
        }
    }

    private fun startBackgroundThread() {
        if (backgroundThread == null) {
            backgroundThread = HandlerThread("AgriTechCameraThread").also { it.start() }
            backgroundHandler = Handler(backgroundThread!!.looper)
        }
    }

    private fun stopBackgroundThread() {
        backgroundThread?.quitSafely()
        try {
            backgroundThread?.join(500)
        } catch (_: InterruptedException) {
        }
        backgroundThread = null
        backgroundHandler = null
    }

    private fun openBackCameraPreview(
        flutterEngine: FlutterEngine,
        result: MethodChannel.Result
    ) {
        try {
            closeCameraResources()
            startBackgroundThread()

            val manager = getSystemService(Context.CAMERA_SERVICE) as CameraManager
            var selectedCameraId: String? = null
            var previewWidth = 1280
            var previewHeight = 960

            for (cameraId in manager.cameraIdList) {
                val chars = manager.getCameraCharacteristics(cameraId)
                val facing = chars.get(CameraCharacteristics.LENS_FACING)
                if (facing == CameraCharacteristics.LENS_FACING_BACK) {
                    selectedCameraId = cameraId
                    sensorOrientationDegrees =
                        chars.get(CameraCharacteristics.SENSOR_ORIENTATION) ?: 90
                    val map = chars.get(CameraCharacteristics.SCALER_STREAM_CONFIGURATION_MAP)
                    val sizes = map?.getOutputSizes(android.graphics.SurfaceTexture::class.java)
                    if (!sizes.isNullOrEmpty()) {
                        val chosen = sizes.firstOrNull { it.width in 720..1920 && it.height in 720..1920 }
                            ?: sizes[0]
                        previewWidth = chosen.width
                        previewHeight = chosen.height
                    }
                    break
                }
            }

            if (selectedCameraId == null && manager.cameraIdList.isNotEmpty()) {
                selectedCameraId = manager.cameraIdList[0]
            }

            if (selectedCameraId == null) {
                result.error("NO_CAMERA", "لم يتم العثور على كاميرا متاحة في الجهاز.", null)
                return
            }

            val textureEntry = flutterEngine.renderer.createSurfaceTexture()
            surfaceTextureEntry = textureEntry
            val surfaceTexture = textureEntry.surfaceTexture()
            surfaceTexture.setDefaultBufferSize(previewWidth, previewHeight)
            val previewSurface = Surface(surfaceTexture)

            val reader = ImageReader.newInstance(
                previewWidth,
                previewHeight,
                ImageFormat.JPEG,
                2
            )
            imageReader = reader

            if (ActivityCompat.checkSelfPermission(this, Manifest.permission.CAMERA)
                != PackageManager.PERMISSION_GRANTED
            ) {
                result.error("PERMISSION_DENIED", "إذن الكاميرا غير ممنوح.", null)
                return
            }

            manager.openCamera(
                selectedCameraId,
                object : CameraDevice.StateCallback() {
                    override fun onOpened(camera: CameraDevice) {
                        cameraDevice = camera
                        try {
                            val reqBuilder =
                                camera.createCaptureRequest(CameraDevice.TEMPLATE_PREVIEW)
                            reqBuilder.addTarget(previewSurface)
                            reqBuilder.set(
                                CaptureRequest.CONTROL_AF_MODE,
                                CaptureRequest.CONTROL_AF_MODE_CONTINUOUS_PICTURE
                            )

                            @Suppress("DEPRECATION")
                            camera.createCaptureSession(
                                listOf(previewSurface, reader.surface),
                                object : CameraCaptureSession.StateCallback() {
                                    override fun onConfigured(session: CameraCaptureSession) {
                                        if (cameraDevice == null) return
                                        captureSession = session
                                        try {
                                            session.setRepeatingRequest(
                                                reqBuilder.build(),
                                                null,
                                                backgroundHandler
                                            )
                                            runOnUiThread {
                                                result.success(
                                                    mapOf(
                                                        "textureId" to textureEntry.id(),
                                                        "previewWidth" to previewWidth,
                                                        "previewHeight" to previewHeight
                                                    )
                                                )
                                            }
                                        } catch (e: Exception) {
                                            runOnUiThread {
                                                result.error(
                                                    "PREVIEW_ERROR",
                                                    "تعذر بدء معاينة الكاميرا: ${e.message}",
                                                    null
                                                )
                                            }
                                        }
                                    }

                                    override fun onConfigureFailed(session: CameraCaptureSession) {
                                        runOnUiThread {
                                            result.error(
                                                "CONFIGURE_FAILED",
                                                "فشل إعداد جلسة الكاميرا.",
                                                null
                                            )
                                        }
                                    }
                                },
                                backgroundHandler
                            )
                        } catch (e: Exception) {
                            runOnUiThread {
                                result.error("CAMERA_ERROR", e.message, null)
                            }
                        }
                    }

                    override fun onDisconnected(camera: CameraDevice) {
                        camera.close()
                        cameraDevice = null
                    }

                    override fun onError(camera: CameraDevice, error: Int) {
                        camera.close()
                        cameraDevice = null
                        runOnUiThread {
                            result.error("CAMERA_DEVICE_ERROR", "خطأ في تشغيل الكاميرا ($error)", null)
                        }
                    }
                },
                backgroundHandler
            )
        } catch (e: CameraAccessException) {
            result.error("CAMERA_ACCESS_ERROR", e.message, null)
        } catch (e: Exception) {
            result.error("UNKNOWN_CAMERA_ERROR", e.message, null)
        }
    }

    private fun handleCaptureCameraPhoto(result: MethodChannel.Result) {
        val device = cameraDevice
        val session = captureSession
        val reader = imageReader
        if (device == null || session == null || reader == null) {
            result.error("CAMERA_NOT_READY", "الكاميرا غير جاهزة لالتقاط الصورة.", null)
            return
        }

        try {
            var responded = false
            reader.setOnImageAvailableListener({ imgReader ->
                val image = imgReader.acquireLatestImage() ?: return@setOnImageAvailableListener
                if (responded) {
                    image.close()
                    return@setOnImageAvailableListener
                }
                responded = true
                try {
                    val buffer = image.planes[0].buffer
                    val bytes = ByteArray(buffer.remaining())
                    buffer.get(bytes)
                    image.close()

                    val savedMap = saveOriginalAndPreprocessedCopy(
                        bytes = bytes,
                        fallbackRotation = sensorOrientationDegrees,
                        prefix = "camera"
                    )
                    runOnUiThread {
                        result.success(savedMap)
                    }
                } catch (e: Exception) {
                    runOnUiThread {
                        result.error("CAPTURE_SAVE_ERROR", e.message, null)
                    }
                }
            }, backgroundHandler)

            val captureBuilder =
                device.createCaptureRequest(CameraDevice.TEMPLATE_STILL_CAPTURE).apply {
                    addTarget(reader.surface)
                    set(
                        CaptureRequest.CONTROL_AF_MODE,
                        CaptureRequest.CONTROL_AF_MODE_CONTINUOUS_PICTURE
                    )
                    set(CaptureRequest.JPEG_ORIENTATION, sensorOrientationDegrees)
                }

            session.capture(captureBuilder.build(), null, backgroundHandler)
        } catch (e: Exception) {
            result.error("CAPTURE_FAILED", e.message, null)
        }
    }

    private fun handlePickGalleryImage(result: MethodChannel.Result) {
        if (pendingGalleryResult != null) {
            result.error("BUSY", "عملية اختيار صورة قيد التنفيذ بالفعل.", null)
            return
        }
        pendingGalleryResult = result
        try {
            val intent = Intent(Intent.ACTION_GET_CONTENT).apply {
                type = "image/*"
                addCategory(Intent.CATEGORY_OPENABLE)
            }
            @Suppress("DEPRECATION")
            startActivityForResult(
                Intent.createChooser(intent, "اختر صورة ورقة البن"),
                REQ_PICK_GALLERY
            )
        } catch (e: Exception) {
            pendingGalleryResult = null
            result.error("GALLERY_ERROR", "تعذر فتح معرض الصور: ${e.message}", null)
        }
    }

    @Deprecated("Deprecated in Java")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQ_PICK_GALLERY) {
            val res = pendingGalleryResult
            pendingGalleryResult = null
            if (res == null) return

            if (resultCode != Activity.RESULT_OK || data?.data == null) {
                res.success(null)
                return
            }

            val uri: Uri = data.data!!
            try {
                val inputStream = contentResolver.openInputStream(uri)
                val bytes = inputStream?.use { it.readBytes() }
                if (bytes == null || bytes.isEmpty()) {
                    res.error("EMPTY_IMAGE", "تعذر قراءة الصورة المختارة من المعرض.", null)
                    return
                }
                val savedMap = saveOriginalAndPreprocessedCopy(
                    bytes = bytes,
                    fallbackRotation = 0,
                    prefix = "gallery"
                )
                res.success(savedMap)
            } catch (e: Exception) {
                res.error("GALLERY_READ_ERROR", "حدث خطأ أثناء معالجة الصورة: ${e.message}", null)
            }
        }
    }

    /**
     * Preserves the original image without distortion and creates a 1:1 square
     * center-cropped copy for future AI model preprocessing.
     */
    private fun saveOriginalAndPreprocessedCopy(
        bytes: ByteArray,
        fallbackRotation: Int,
        prefix: String
    ): Map<String, Any> {
        val ts = System.currentTimeMillis()
        val rawOriginalFile = File(cacheDir, "agritech_${prefix}_raw_$ts.jpg")
        FileOutputStream(rawOriginalFile).use { it.write(bytes) }

        // Read EXIF orientation so the image is upright and proportions are preserved
        val exifRotation = try {
            val exif = ExifInterface(rawOriginalFile.absolutePath)
            when (exif.getAttributeInt(
                ExifInterface.TAG_ORIENTATION,
                ExifInterface.ORIENTATION_UNDEFINED
            )) {
                ExifInterface.ORIENTATION_ROTATE_90 -> 90
                ExifInterface.ORIENTATION_ROTATE_180 -> 180
                ExifInterface.ORIENTATION_ROTATE_270 -> 270
                ExifInterface.ORIENTATION_NORMAL -> 0
                else -> fallbackRotation
            }
        } catch (_: Exception) {
            fallbackRotation
        }

        val decoded = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
            ?: throw IllegalStateException("تعذر فك ترميز ملف الصورة")

        val uprightBitmap = if (exifRotation != 0) {
            val matrix = Matrix().apply { postRotate(exifRotation.toFloat()) }
            Bitmap.createBitmap(decoded, 0, 0, decoded.width, decoded.height, matrix, true)
        } else {
            decoded
        }

        // 1. Save upright original image preserving full aspect ratio
        val originalFile = File(cacheDir, "agritech_${prefix}_original_$ts.jpg")
        FileOutputStream(originalFile).use { out ->
            uprightBitmap.compress(Bitmap.CompressFormat.JPEG, 95, out)
        }

        // 2. Create 1:1 center-cropped copy for AI model preprocessing without distortion
        val side = min(uprightBitmap.width, uprightBitmap.height)
        val offsetX = (uprightBitmap.width - side) / 2
        val offsetY = (uprightBitmap.height - side) / 2
        val squareBitmap = Bitmap.createBitmap(uprightBitmap, offsetX, offsetY, side, side)
        val preprocessedFile = File(cacheDir, "agritech_${prefix}_preprocessed_1x1_$ts.jpg")
        FileOutputStream(preprocessedFile).use { out ->
            squareBitmap.compress(Bitmap.CompressFormat.JPEG, 92, out)
        }

        rawOriginalFile.delete()

        return mapOf(
            "originalPath" to originalFile.absolutePath,
            "preprocessedPath" to preprocessedFile.absolutePath,
            "width" to uprightBitmap.width,
            "height" to uprightBitmap.height,
            "squareSize" to side
        )
    }

    private fun closeCameraResources() {
        try {
            captureSession?.close()
        } catch (_: Exception) {
        }
        captureSession = null

        try {
            cameraDevice?.close()
        } catch (_: Exception) {
        }
        cameraDevice = null

        try {
            imageReader?.close()
        } catch (_: Exception) {
        }
        imageReader = null

        try {
            surfaceTextureEntry?.release()
        } catch (_: Exception) {
        }
        surfaceTextureEntry = null

        stopBackgroundThread()
    }

    override fun onDestroy() {
        closeCameraResources()
        super.onDestroy()
    }
}
