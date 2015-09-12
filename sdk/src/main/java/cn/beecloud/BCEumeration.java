package cn.beecloud;

public class BCEumeration {
	public enum RESULT_TYPE {
		OK,
	    VALIDATION_ERROR,
	    RUNTIME_ERROR
	}

	public enum PAY_CHANNEL {
		WX,
		WX_APP,
		WX_NATIVE,
		WX_JSAPI,
		ALI,
		ALI_APP,
		ALI_WEB,
		ALI_WAP,
		ALI_QRCODE,
		ALI_OFFLINE_QRCODE,
		UN,
		UN_APP,
		UN_WEB,
		YEE,
		YEE_WEB,
		YEE_WAP,
		JD,
		JD_WEB,
		JD_WAP,
		KUAIQIAN,
		KUAIQIAN_WAP,
		KUAIQIAN_WEB,
		BD,
		BD_WEB,
		BD_WAP
	}

	public enum QR_PAY_MODE {
		MODE_BRIEF_FRONT,
		MODE_FRONT,
		MODE_MINI_FRONT
	}
}



