package com.stpass.imes.plugin.fphello;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationManager;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;

import com.stpass.imes.plugin.fphello.util.SoundPlayer;

import java.util.concurrent.TimeUnit;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

@SuppressWarnings("SpellCheckingInspection ")
public class FphelloPlugin implements FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
    private MethodChannel channel;

    private EventChannel stream;

    private EventChannel.EventSink sink;

    private Context context;

    private SoundPlayer soundPlayer;

    static final String TAG = "FpPlugin";

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "fp/method");
        channel.setMethodCallHandler(this);

        stream = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "fp/event");
        stream.setStreamHandler(this);

        context = flutterPluginBinding.getApplicationContext();
        soundPlayer = SoundPlayer.getInstance().init(context);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "getPlatformVersion":
                if (sink != null) sink.success("receiveVersion:" + android.os.Build.VERSION.RELEASE);
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;
            case "getLocation" :
                String loc = getLocation();
                sink.success("receiveLocation:" + loc);
                result.success(getLocation());
                break;
            case "soundPlay" :
                soundPlay();
                sink.success("receiveSoundPlay,finished");
                result.success("");
                break;
            default : result.notImplemented();
        }
        Log.d(TAG, "Get or not");
        sink.success("Over");
    }

    private void soundPlay(){
        try {
            soundPlayer.playRegged();
            TimeUnit.SECONDS.sleep(1L);
            soundPlayer.playSuccess();
            TimeUnit.SECONDS.sleep(1L);
            soundPlayer.playWarning();
            TimeUnit.SECONDS.sleep(1L);
            soundPlayer.playError();
            TimeUnit.SECONDS.sleep(1L);
            soundPlayer.playVibrator();
        } catch (InterruptedException e) {
            Log.d(TAG, "soundPlay: "+ e);
        }
    }

    private String getLocation() {
        soundPlayer.playRegged();
        if (ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) !=
                PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(context,
                Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED)
            return "permission denied in android";
        LocationManager locationManager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
        Location location = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
        if (location != null) {
            double latitude = location.getLatitude();
            double longitude = location.getLongitude();
            return String.format("lat=%s,lng=%s", latitude, longitude);
        } else {
            return "unKnow in android";
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        stream.setStreamHandler(null);
        soundPlayer = null;
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        sink = events;
    }

    @Override
    public void onCancel(Object arguments) {
        sink = null;
    }
}
