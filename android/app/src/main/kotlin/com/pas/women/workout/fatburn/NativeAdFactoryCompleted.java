package com.pas.women.workout.fatburn;

import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.google.android.gms.ads.OnPaidEventListener;
import com.google.android.gms.ads.nativead.NativeAd;
import com.google.android.gms.ads.nativead.NativeAdView;
import com.makeramen.roundedimageview.RoundedImageView;

import java.util.Map;

import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory;

class NativeAdFactoryCompleted implements NativeAdFactory {
    private final LayoutInflater layoutInflater;

    NativeAdFactoryCompleted(LayoutInflater layoutInflater) {
        this.layoutInflater = layoutInflater;
    }

    @Override
    public NativeAdView createNativeAd(
            NativeAd nativeAd, Map<String, Object> customOptions) {
        final NativeAdView adView = (NativeAdView) layoutInflater.inflate(R.layout.my_native_ad_completed, null);
        final TextView headlineView = adView.findViewById(R.id.ad_headline);
        final TextView bodyView = adView.findViewById(R.id.ad_body);
        final ImageView ad_imageview_full = adView.findViewById(R.id.ad_media);
        final RoundedImageView icon = adView.findViewById(R.id.icon);
        ImageView btnAction = adView.findViewById(R.id.ad_call_to_action);
        bodyView.setMaxLines(2);


        headlineView.setText(nativeAd.getHeadline());
        bodyView.setText(nativeAd.getBody());

        ad_imageview_full.setImageDrawable(nativeAd.getMediaContent().getMainImage());
        try{
            if(nativeAd.getIcon().getDrawable()!=null){
                icon.setImageDrawable(nativeAd.getIcon().getDrawable());
                icon.setCornerRadius(15);
                adView.setIconView(icon);
            }
        }catch (Exception e){

        }





       adView.setNativeAd(nativeAd);
       adView.setBodyView(bodyView);
       adView.setHeadlineView(headlineView);
        adView.setImageView(ad_imageview_full);
        adView.setImageView(btnAction);

        return adView;
    }
}