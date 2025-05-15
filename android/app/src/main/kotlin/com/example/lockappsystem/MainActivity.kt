package com.example.lockappsystem
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "device_lock"

    //  override fun onCreate(savedInstanceState: Bundle?) {
    //     super.onCreate(savedInstanceState)

    //     MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
    //         call, result ->
    //         when (call.method) {
    //             "startKioskMode" -> {
    //                 val dpm = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
    //                 val component = ComponentName(this, MyDeviceAdminReceiver::class.java)

    //                 if (dpm.isDeviceOwnerApp(packageName)) {
    //                     dpm.setLockTaskPackages(component, arrayOf(packageName))
    //                     startLockTask()
    //                     result.success("Kiosk mode started")
    //                 } else {
    //                     result.error("NOT_OWNER", "App is not Device Owner", null)
    //                 }
    //             }
    //             else -> result.notImplemented()
    //         }
    //     }
    // }
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            when (call.method) {
                "lockDevice" -> {
                    val dpm = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
                    val componentName = ComponentName(this, MyDeviceAdminReceiver::class.java)

                    if (dpm.isAdminActive(componentName)) {
                        dpm.lockNow()
                        result.success(null)
                    } else {
                        result.error("NO_ADMIN", "Device Admin not enabled", null)
                    }
                }

                "requestAdmin" -> {
                    requestDeviceAdminPermission()
                    result.success(null)
                }
                "disableCamera" -> {
                    val dpm = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
                    val component = ComponentName(this, MyDeviceAdminReceiver::class.java)

                        if (dpm.isAdminActive(component)) {
                            dpm.setCameraDisabled(component, true)
                            result.success(null)
                        } else {
                            result.error("NO_ADMIN", "Device Admin not enabled", null)
                        }
                }
                 "startKioskMode" -> {
                    val dpm = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
                    val component = ComponentName(this, MyDeviceAdminReceiver::class.java)
                    
                    if (dpm.isDeviceOwnerApp(packageName)) {
                        dpm.setLockTaskPackages(component, arrayOf(packageName))
                        startLockTask()
                        result.success("Kiosk mode started")
                    } else {
                        result.error("NOT_OWNER", "App is not Device Owner", null)
                    }
                }

                "stopKioskMode" -> {
                    stopLockTask()
                    result.success("Kiosk mode stopped")
                }
                "blockUninstall" -> {
                   val dpm = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
                    val component = ComponentName(this, MyDeviceAdminReceiver::class.java)

                    if (dpm.isDeviceOwnerApp(packageName)) {
                        dpm.setUninstallBlocked(component, packageName, true) 
                    }
                                    }
               "unblockUninstall" -> {
                    try {
                        val dpm = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
                        val component = ComponentName(this, MyDeviceAdminReceiver::class.java)
                        
                        if (dpm.isDeviceOwnerApp(packageName)) {
                            dpm.setUninstallBlocked(component, packageName, false) // Unblock uninstall
                            result.success("App uninstalled successfully unblocked")
                        } else {
                            result.error("NOT_OWNER", "App is not Device Owner", null)
                        }
                    } catch (e: Exception) {
                        result.error("ERROR", "Failed to unblock uninstall: ${e.message}", null)
                    }
                    }

                else -> result.notImplemented()
            }
        }
    }
//     override fun onDestroy() {
//     super.onDestroy()
//     val restartIntent = Intent(this, MainActivity::class.java)
//     restartIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
//     startActivity(restartIntent)
// }
    private fun requestDeviceAdminPermission() {
        val componentName = ComponentName(this, MyDeviceAdminReceiver::class.java)
        val intent = Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN)
        intent.putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, componentName)
        intent.putExtra(DevicePolicyManager.EXTRA_ADD_EXPLANATION, "This app needs permission to lock the screen.")
        startActivity(intent)
    }
}


