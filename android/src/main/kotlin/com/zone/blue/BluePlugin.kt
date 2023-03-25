package com.zone.blue

import android.bluetooth.*
import android.content.Context
import android.os.Build
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat.getSystemService
import io.flutter.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONArray
import org.json.JSONObject

/** BluePlugin */
class BluePlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "blue")
        channel.setMethodCallHandler(this)
    }



    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPairedDevices" -> {
                result.success(getPairedDevicesJson())
            }
            "getConnectedDevices" -> {
                result.success(getConnectedDevicesJson())
            }
            "isConnected" -> {
                result.success(call.argument<String>("address")?.let { isConnected(it) });
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }



    private fun getPairedDevicesJson(): String {
        val pairedDevices = getPairedDevices()
        return bluetoothDevicesToJson(pairedDevices)
    }
    private fun getConnectedDevicesJson(): String {
        val pairedDevices = getConnectedDevices()
        return bluetoothDevicesToJson(pairedDevices)
    }

    private fun getBluetoothAdaptor(): BluetoothAdapter? {
        val adaptor = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR2) {
            getSystemService(context, BluetoothManager::class.java)?.adapter
        } else {
            BluetoothAdapter.getDefaultAdapter();
        }
        return adaptor
    }

    private fun getPairedDevices(): Set<BluetoothDevice> {
        val adaptor = getBluetoothAdaptor()
        return adaptor?.bondedDevices ?: setOf()
    }
    private fun getConnectedDevices(): Set<BluetoothDevice> {
        val adaptor = getBluetoothAdaptor()
        return adaptor?.bondedDevices?.filter { isConnected(it) }?.toSet() ?: setOf()
    }
    private fun getBatteryLevel(device: BluetoothDevice): Int {
        /// DEVICE_TYPE_CLASSIC , DEVICE_TYPE_LE  DEVICE_TYPE_DUAL . DEVICE_TYPE_UNKNOWN  if it's not available
        try {
            val method = device::class.java.getMethod("getBatteryLevel")
            return method.invoke(device) as Int
        } catch (e: Exception) {
            throw IllegalStateException(e)
        }
    }

    private fun isConnected(device: BluetoothDevice): Boolean {
        try {
            val m = device.javaClass.getMethod("isConnected")
            return m.invoke(device) as Boolean

        } catch (e: Exception) {
            throw IllegalStateException(e)
        }
    }

    private fun getDeviceBy(address: String): BluetoothDevice? {

        for (device in getPairedDevices()) {
            if (device.address == address) return device
        }
        return null
    }

    private fun isConnected(address: String): Boolean {
        val device = getBluetoothAdaptor()?.getRemoteDevice(address) ?: return false
        return isConnected(device)
    }


    private fun bluetoothDeviceToJson(device: BluetoothDevice): String {
        val deviceMap = deviceToMap(device)
        return JSONObject(deviceMap).toString()
    }

    private fun bluetoothDevicesToJson(device: Iterable<BluetoothDevice>): String {
        val devicesMap = mutableListOf<Map<String, Any>>()
        device.forEach {
            val level = getBatteryLevel(it)
            val connected = isConnected(it)
            val deviceMap = deviceToMap(it)
            devicesMap.add(deviceMap)
        }
        val json = JSONArray(devicesMap)
        return json.toString()
    }

    private fun deviceToMap(device:BluetoothDevice):Map<String,Any>{
        val level = getBatteryLevel(device)
        val connected = isConnected(device)
        return mapOf(
            "address" to device.address,
            "name" to device.name,
            "connected" to connected,
            "battery_level" to level,
        )
    }
}
