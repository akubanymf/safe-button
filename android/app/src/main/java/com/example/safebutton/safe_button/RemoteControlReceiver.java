package com.example.safebutton.safe_button;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.view.KeyEvent;

public class RemoteControlReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        final KeyEvent event = intent.getParcelableExtra(Intent.EXTRA_KEY_EVENT);
        context.sendBroadcast(new Intent("EVENT"));


    }


}