package com.eecs451.ftibtif.fragment;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.util.Locale;

import com.eecs451.ftibtif.R;

import android.app.Fragment;
import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Bundle;
import android.os.Environment;
import android.text.format.Time;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

public class Measure extends Fragment implements SensorEventListener {
	private Time currTime;
	private boolean mInitialized;
	private SensorManager mSensorManager;
    private Sensor mAccelerometer;
    private String fname;
    
    private float c_g;
    
    private int bad_step;
    private int bad_step_high;
    
    private int sample_num;
    private int avg_step;
    private int avg_step_high;
    private float[] short_list;
    private int short_list_count;
    private float[] long_list;
    private int long_list_count;
    
    BufferedOutputStream fos;
    FileWriter fWriter;
    File mfile;
    private long initTime;
    long oldTimestamp;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
        View mainView = inflater.inflate(R.layout.measure_frag, container, false);
        mInitialized = false;
        mSensorManager = (SensorManager)  getActivity().getSystemService(Context.SENSOR_SERVICE);
        mAccelerometer = mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
        mSensorManager.registerListener(this, mAccelerometer , SensorManager.SENSOR_DELAY_FASTEST);
        initTime = 0;
        oldTimestamp = 0;
        bad_step = 0;
        bad_step_high = 0;
        
        sample_num = 0;
        avg_step = 0;
        avg_step_high = 0;
        short_list = new float[100];
        for (int i = 0; i < 100; i++)
		{
			short_list[i] = 0;
		}
        short_list_count = 0;
        
        long_list = new float[2000];
        for (int i = 0; i < 2000; i++)
		{
			long_list[i] = 0;
		}
        long_list_count = 0;
        
        currTime = new Time();
        currTime.setToNow();
        
        c_g = (float) Math.pow(9.81, 2);

        fname = Environment.getExternalStorageDirectory().getPath() + "/451/log_";
        fname += String.format("%d%d%d_", currTime.year, currTime.month, currTime.monthDay);
        fname += String.format("%d%d%d", currTime.hour, currTime.minute, currTime.second);
        fname += ".txt";
        mfile = new File(fname);
        Log.d("DERPASTIC", mfile.getPath());
        try{
            mfile.createNewFile();
            fos = new BufferedOutputStream(new FileOutputStream(mfile, true));
        }catch(Exception e){
        	e.printStackTrace();
        }
        
        return mainView;
    }
    
    public void onResume() {
        super.onResume();
        mSensorManager.registerListener(this, mAccelerometer, SensorManager.SENSOR_DELAY_FASTEST);
    }
    
    public void onPause() {
        super.onPause();
        mSensorManager.unregisterListener(this);
        try{
            fos.flush();
        }catch(Exception e){
        	e.printStackTrace();
        }
    }
    
	public void onAccuracyChanged(Sensor sensor, int accuracy) {
		// can be safely ignored for this demo
	}
	
	public void onSensorChanged(SensorEvent event) {
		TextView tvX= (TextView) getView().findViewById(R.id.x_axis);
		TextView tvY= (TextView) getView().findViewById(R.id.y_axis);
		TextView tvZ= (TextView) getView().findViewById(R.id.z_axis);
		TextView tvtimestamp= (TextView) getView().findViewById(R.id.timestamp);
		TextView bad_stepcount = (TextView) getView().findViewById(R.id.bad_pedometer);
		TextView avg_stepcount = (TextView) getView().findViewById(R.id.avg_pedometer);
		TextView tv_fname = (TextView) getView().findViewById(R.id.fname);
//		TextView tv_d1 = (TextView) getView().findViewById(R.id.debug_1);
//		TextView tv_d2 = (TextView) getView().findViewById(R.id.debug_2);
		
		long timestamp = event.timestamp;
		float x = event.values[0];
		float y = event.values[1];
		float z = event.values[2];
		float mag = (float) (Math.pow(x, 2) + Math.pow(y, 2) + Math.pow(z, 2));
		
		float long_average = 0;
		float short_average = 0;
		
		if (!mInitialized) {
			initTime = timestamp;
			mInitialized = true;
		}
		
		//Bad stepcounter
		if ( (mag > 2.0 * c_g) && (bad_step_high == 0) )
		{
			bad_step_high = 1;
			bad_step ++;
		}
		if ( (mag < 0.25 * c_g) && (bad_step_high == 1) )
		{
			bad_step_high = 0;
		}

		//Average stepcounter
		short_list[short_list_count] = mag;
		long_list[long_list_count] = mag;
		sample_num++;
		short_list_count++;
		if (short_list_count > 99)
		{
			short_list_count = 0;
		}
		long_list_count++;
		if (long_list_count > 1999)
		{
			long_list_count = 0;
		}
		for (int i = 0; i < 100; i++)
		{
			short_average += short_list[i];
		}
		for (int i = 0; i < 2000; i++)
		{
			long_average += long_list[i];
		}
		if (sample_num < 100) {
			short_average /= sample_num;
		} else {
			short_average /= 100;
		}
		if (sample_num < 2000) {
			long_average /= sample_num;
		} else {
			long_average /= 2000;
		}
		if ( (short_average > long_average * 1.1) && (avg_step_high == 0) )
		{
			avg_step_high = 1;
			avg_step++;
		}
		if ( (short_average < long_average * 0.9) && (avg_step_high == 1) )
		{
			avg_step_high = 0;
		}
		
		
		//Writes to file
		try{
            String s = String.format(Locale.US, "ACC %dus %f %f %f\n\n", (timestamp - initTime)/1000, x, y, z);
            fos.write(s.getBytes());
//            String s1 = String.format(Locale.US, "magnitude %dus %f\n\n", (timestamp - initTime)/1000, mag);
//            fos.write(s1.getBytes());
        }catch(Exception e){
        	e.printStackTrace();
        }
		
		//Displays values on screen
		if ( ((timestamp - oldTimestamp)/1000) > 1000000)
		{
			tvX.setText(String.format("%.3f", x));
			tvY.setText(String.format("%.3f", y));
			tvZ.setText(String.format("%.3f", z));
			tvtimestamp.setText(String.format("%d s", (timestamp - initTime)/1000000000));
			bad_stepcount.setText(String.format("%d Steps", bad_step));
			avg_stepcount.setText(String.format("%d Steps", avg_step));
			tv_fname.setText(fname);
//			tv_d1.setText(String.format("%.3f", short_average));
//			tv_d2.setText(String.format("%.3f", long_average));
			
			oldTimestamp = timestamp;
		}

	}
    
}
