package com.ptola;

import android.annotation.SuppressLint;
import java.util.UUID;


@SuppressLint("DefaultLocale")
public class GameUUID
{
	public static String create()
	{
		UUID uuid = UUID.randomUUID();
		return uuid.toString().toUpperCase();
	}
}
