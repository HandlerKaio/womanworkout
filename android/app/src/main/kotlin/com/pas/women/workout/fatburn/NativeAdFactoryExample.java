package com.pas.women.workout.fatburn;

import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.MediaController;
import android.widget.RatingBar;
import android.widget.TextView;

import com.google.android.gms.ads.nativead.MediaView;
import com.google.android.gms.ads.nativead.NativeAd;
import com.google.android.gms.ads.nativead.NativeAdView;
import com.makeramen.roundedimageview.RoundedImageView;

import java.util.Map;

import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory;

class NativeAdFactoryExample implements NativeAdFactory {
    private final LayoutInflater layoutInflater;

    NativeAdFactoryExample(LayoutInflater layoutInflater) {
        this.layoutInflater = layoutInflater;
    }

    @Override
    public NativeAdView createNativeAd(
            NativeAd nativeAd, Map<String, Object> customOptions) {
        final NativeAdView adView = (NativeAdView) layoutInflater.inflate(R.layout.my_native_ad, null);
        final TextView headlineView = adView.findViewById(R.id.ad_headline);
        final TextView bodyView = adView.findViewById(R.id.ad_body);
        final RoundedImageView icon = adView.findViewById(R.id.icon);
        ImageView btnAction = adView.findViewById(R.id.ad_call_to_action);
        ImageView mediaView = adView.findViewById(R.id.ad_media);

        headlineView.setText(nativeAd.getHeadline());
        bodyView.setText(nativeAd.getBody());
        bodyView.setMaxLines(2);


        try{
            if(nativeAd.getIcon().getDrawable()!=null){
                icon.setImageDrawable(nativeAd.getIcon().getDrawable());
                icon.setCornerRadius(15);
                adView.setIconView(icon);
            }
        }catch (Exception e){

        }
        try{
            if(nativeAd.getMediaContent()!=null){
                mediaView.setImageDrawable(nativeAd.getMediaContent().getMainImage());
                adView.setImageView(mediaView);
            }
        }catch (Exception e){

        }


        btnAction.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

            }
        });


        adView.setNativeAd(nativeAd);
        adView.setBodyView(bodyView);
        adView.setHeadlineView(headlineView);

        adView.setImageView(btnAction);

        return adView;
    }
}