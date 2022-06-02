package com.example.safebutton.safe_button;

import static com.example.safebutton.safe_button.Constants.PERMISSIONS;

import android.Manifest;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.telephony.SmsManager;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.minew.beaconplus.sdk.MTCentralManager;
import com.minew.beaconplus.sdk.MTFrameHandler;
import com.minew.beaconplus.sdk.MTPeripheral;
import com.minew.beaconplus.sdk.Utils.LogUtils;
import com.minew.beaconplus.sdk.enums.BluetoothState;
import com.minew.beaconplus.sdk.enums.ConnectionStatus;
import com.minew.beaconplus.sdk.enums.TriggerType;
import com.minew.beaconplus.sdk.exception.MTException;
import com.minew.beaconplus.sdk.frames.MinewFrame;
import com.minew.beaconplus.sdk.interfaces.ConnectionStatueListener;
import com.minew.beaconplus.sdk.interfaces.GetPasswordListener;
import com.minew.beaconplus.sdk.interfaces.MTCentralManagerListener;
import com.minew.beaconplus.sdk.interfaces.OnBluetoothStateChangedListener;

import java.util.ArrayList;
import java.util.List;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends FlutterActivity {
    MTCentralManager mtCentralManager = MTCentralManager.getInstance(this);
    private PermissionUtility permissionUtility;

    private static final String CHANNEL = "myChannel";
    private com.minew.beaconplus.sdk.MTConnectionHandler mMTConnectionHandler;
    public static MTPeripheral mtPeripheral;
    public static boolean smsSent = false;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine){
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if(call.method.equals("sendSms")){
                        sendSms("0509009714", "HELP", getContext());
                    }
                });
    }


    private void sendSms(String phoneNo, String msg, Context context) {
        try {
            SmsManager smsManager = SmsManager.getDefault();
            smsManager.sendTextMessage(phoneNo, null, msg, null, null);
            Toast.makeText(context, "Message Sent",
                    Toast.LENGTH_LONG).show();
        } catch (Exception ex) {
            Toast.makeText(context, ex.getMessage().toString(),
                    Toast.LENGTH_LONG).show();
            ex.printStackTrace();
        }
    }



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mtCentralManager.setBluetoothChangedListener(new OnBluetoothStateChangedListener() {
            @Override
            public void onStateChanged(BluetoothState state) {
                Log.i("SERVICE", state.toString());
            }
        });

        permissionUtility = new PermissionUtility(this, PERMISSIONS);
        if(permissionUtility.arePermissionsEnabled()){
            Log.d("TAG", "Permission granted 1");
            mtCentralManager.startService();
            mtCentralManager.startScan();
        } else {
            permissionUtility.requestMultiplePermissions();
        }


        mtCentralManager.setMTCentralManagerListener(getMTCentralMgrListener());
    }

    public MTCentralManagerListener getMTCentralMgrListener(){
        return new MTCentralManagerListener() {
            @Override
            public void onScanedPeripheral(final List<MTPeripheral> peripherals) {
                for (MTPeripheral mtPeripheral : peripherals) {
                    // get FrameHandler of a device.
                    MTFrameHandler mtFrameHandler = mtPeripheral.mMTFrameHandler;
                    MainActivity.mtPeripheral = mtPeripheral;
                    String mac = mtFrameHandler.getMac(); 		//mac address of device
                    String name = mtFrameHandler.getName();		// name of device
                    int battery = mtFrameHandler.getBattery();	//battery
                    int rssi = mtFrameHandler.getRssi();		//rssi
                    // all data frames of device（such as:iBeacon，UID，URL...）
                    ArrayList<MinewFrame> advFrames = mtFrameHandler.getAdvFrames();
                    if(mac.equals("AC:23:3F:E0:5E:E3")){
                        if(advFrames.size() > 0){
//                            mtCentralManager.stopScan();
                            checkFrameType(advFrames);
                        }
//                        mtCentralManager.connect(MainActivity.mtPeripheral, connectionStatueListener);
//
                    }

                }
            }
        };
    }

    private void checkFrameType(ArrayList<com.minew.beaconplus.sdk.frames.MinewFrame> advFrames) {

        for (MinewFrame minewFrame : advFrames) {
            com.minew.beaconplus.sdk.enums.FrameType frameType = minewFrame.getFrameType();
            switch (frameType) {
                case FrameiBeacon://iBeacon
                    com.minew.beaconplus.sdk.frames.IBeaconFrame iBeaconFrame = (com.minew.beaconplus.sdk.frames.IBeaconFrame) minewFrame;
                    Log.v("FrameiBeacon", iBeaconFrame.getUuid() + iBeaconFrame.getMajor() + iBeaconFrame.getMinor());
                    break;
                case FrameUID://uid
                    com.minew.beaconplus.sdk.frames.UidFrame uidFrame = (com.minew.beaconplus.sdk.frames.UidFrame) minewFrame;
                    Log.v("FrameUID", uidFrame.getNamespaceId() + uidFrame.getInstanceId());
                    break;
                case FrameAccSensor:
                    com.minew.beaconplus.sdk.frames.AccFrame accFrame = (com.minew.beaconplus.sdk.frames.AccFrame) minewFrame;//acc
//                    Log.v("beaconplus", accFrame.getXAxis() + accFrame.getYAxis() + accFrame.getZAxis());
                    break;
                case FrameHTSensor:
                    com.minew.beaconplus.sdk.frames.HTFrame htFrame = (com.minew.beaconplus.sdk.frames.HTFrame) minewFrame;//ht
//                    Log.v("beaconplus", htFrame.getTemperature() + htFrame.getHumidity());
                    break;
                case FrameTLM:
                    com.minew.beaconplus.sdk.frames.TlmFrame tlmFrame = (com.minew.beaconplus.sdk.frames.TlmFrame) minewFrame;//tlm
//                    Log.v("beaconplus", tlmFrame.getTemperature() + tlmFrame.getBatteryVol() + tlmFrame.getSecCount() + tlmFrame.getAdvCount());
                    break;
                case FrameURL:
                    com.minew.beaconplus.sdk.frames.UrlFrame urlFrame = (com.minew.beaconplus.sdk.frames.UrlFrame) minewFrame;//url
                    Log.v("FrameURL", "Link:" + urlFrame.getUrlString() + "Rssi @ 0m:" + urlFrame.getTxPower());
                    Context context = getActivity();
                    SharedPreferences sharedPref = context.getSharedPreferences(
                            "FlutterSharedPreferences", Context.MODE_PRIVATE);
                    if(!smsSent){
                        Log.v("Sending_SMS", "Number:" + sharedPref.getString("flutter.phoneNumber", ""));
                        sendSms(sharedPref.getString("flutter.phoneNumber", ""), "HELP", getContext());
                        smsSent = true;
//                        startScanAfterSmsSent();
                        mtCentralManager.stopScan();
                    }

//                    mtCentralManager.startScan();
                    break;
                default:
                    break;
            }
        }

    }


    private void startScanAfterSmsSent(){
        final Handler handler = new Handler(Looper.getMainLooper());
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                smsSent = false;
            }
        }, 20000);
    }

    private ConnectionStatueListener connectionStatueListener = new ConnectionStatueListener() {


        @Override
        public void onUpdateConnectionStatus(ConnectionStatus connectionStatus, GetPasswordListener getPasswordListener) {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    switch (connectionStatus) {

                        case PASSWORDVALIDATING:
                            String password = "minew123";
                            getPasswordListener.getPassword(password);
                            break;
                    }

                    switch (connectionStatus) {
                        case CONNECTING:
                            Log.e("minew_tag", ": CONNECTING");
                            break;
                        case CONNECTED:
                            Log.e("minew_tag", ": CONNECTED");
                            break;
                        case READINGINFO:
                            //Advanced exercise can be notified when reading firmware 								  information
                            Log.e("minew_tag", ": Read device firmware information");
                            break;
                        case DEVICEVALIDATING://After successfully verifying the device, 											write the verification key to the device
                            LogUtils.e("DEVICEVALIDATING");
                            break;
                        //If you need the connect password, will call back this state.
                        // !!!:Warnning: passwordRequire must not be NULL!!!
                        // the length of password string must be 8.
                        case PASSWORDVALIDATING:
                            String password = "minew123";
                            getPasswordListener.getPassword(password);
                            break;
                        case SYNCHRONIZINGTIME://Password verification completed
                            Log.e("minew_tag", ": SYNCHRONIZINGTIME");
                            break;
                        case READINGCONNECTABLE:
                            Log.e("minew_tag", ": Read device firmware information");
                            LogUtils.e("READINGCONNECTABLE");
                            break;
                        case READINGFEATURE:
                            LogUtils.e("READINGFEATURE");
                            break;
                        case READINGFRAMES:
                            LogUtils.e("READINGFRAMES");
                            break;
                        case READINGTRIGGERS:
                            LogUtils.e("READINGTRIGGERS");
                            break;
                        case READINGSENSORS:
                            LogUtils.e("READINGSENSORS");
                            break;
                        case COMPLETED:
                            Log.e("minew_tag", ": COMPLETED");
                            setTrigger();
                            break;
                    }
                }
            });
        }

        @Override
        public void onError(MTException e) {

        }
    };


    public void setTrigger(){
        com.minew.beaconplus.sdk.model.Trigger trigger = new com.minew.beaconplus.sdk.model.Trigger();
        trigger.setCurSlot(2);// Target slot：2
        trigger.setTriggerType(TriggerType.BTN_DTAP_EVT);// Triggering condition：temperature above
        trigger.setCondition(10);// value：10
        MainActivity.mtPeripheral.mMTConnectionHandler.setTriggerCondition(trigger,new com.minew.beaconplus.sdk.interfaces.SetTriggerListener() {
            @Override
            public void onSetTrigger(boolean success, MTException mtException) {
                if (success) {
                    Log.v("beaconplus","Success!");
                } else {
                    Log.v("beaconplus","Failed!");
                }
            }
        });
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if(permissionUtility.onRequestPermissionsResult(requestCode, permissions, grantResults)) {
            Log.d("TAG", "Permission granted 2");
            mtCentralManager.startScan();
        }
    }

    @Override
    protected void onRestart() {
        super.onRestart();
        mtCentralManager.setBluetoothChangedListener(new OnBluetoothStateChangedListener() {
            @Override
            public void onStateChanged(BluetoothState state) {
                Log.i("SERVICE", state.toString());
            }
        });
        mtCentralManager.startService();
        mtCentralManager.setMTCentralManagerListener(getMTCentralMgrListener());
        mtCentralManager.startScan();
    }

    @Override
    protected void onPause() {
        super.onPause();
        try{
            mtCentralManager.stopScan();
        } catch (Exception e){
            e.printStackTrace();
        }
        try{
            mtCentralManager.stopService();
        } catch (Exception e){
            e.printStackTrace();
        }
    }

    @Override
    protected void onStop() {
        super.onStop();
        try{
            mtCentralManager.stopScan();
        } catch (Exception e){
            e.printStackTrace();
        }
        try{
            mtCentralManager.stopService();
        } catch (Exception e){
            e.printStackTrace();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        try{
            mtCentralManager.stopScan();
        } catch (Exception e){
            e.printStackTrace();
        }
        try{
            mtCentralManager.stopService();
        } catch (Exception e){
            e.printStackTrace();
        }
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
    }
}


