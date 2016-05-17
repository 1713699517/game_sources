package com.ptola;

import java.util.Locale;

import com.haowan123.kof.qh.GameBox;

import org.cocos2dx.lib.Cocos2dxTypefaces;

import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Paint.Align;
import android.graphics.Typeface;

public class GameFontMetricMeasure
{
	public static Paint getFontPainter(String fontName, float fontSize, int alignment)
	{
		final Paint ret = new Paint();
		ret.setColor(Color.WHITE);
		ret.setTextSize(fontSize);
		ret.setAntiAlias(true);
		
		ret.setTextAlign(Align.LEFT);
		//font family
		if( fontName.toLowerCase(Locale.getDefault()).endsWith(".ttf") )
		{
			try
			{
				ret.setTypeface( Cocos2dxTypefaces.get(GameBox.getContext(), fontName) );
			}
			catch(final Exception e)
			{
				ret.setTypeface( Typeface.create(fontName, Typeface.NORMAL));
			}
		}
		else
		{
			ret.setTypeface(Typeface.create(fontName, Typeface.NORMAL));
		}
		return ret;
	}
	
	//public static 
}
