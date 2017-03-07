package  {
	
	import flash.system.Capabilities;
	
	import mx.core.DPIClassification;
	import mx.core.RuntimeDPIProvider;
	
	public class customizedRuntimeDPIProvider extends RuntimeDPIProvider {
		
		public function customizedRuntimeDPIProvider() {}
		
		// Return Different DPI Mapping
		override public function get runtimeDPI():Number {
			
			// Retrieving Device Capabilities
			var os:String = Capabilities.os;
			var screenX:Number = Capabilities.screenResolutionX;
			var screenY:Number = Capabilities.screenResolutionY;
			var pixelCheck:Number = screenX * screenY;
			var pixels:Number = (screenX*screenX) + (screenY*screenY);
			var screenSize:Number = Math.sqrt(pixels)/Capabilities.screenDPI;
			
			// Debug
			trace("Customized Runtime DPI Provider ==> Found device os: " + os);
			trace("ScreenSize: " + screenSize + " PixelCheck: " + pixelCheck + " ScreenDPI: " + Capabilities.screenDPI);
			
			// Handle iPad Devices
			if(os.indexOf("iPad") != -1) {
				if(Capabilities.screenResolutionX > 2000 || Capabilities.screenResolutionY > 2000) {
					trace("Customized Runtime DPI Provider ==> DPI Forced to 320 (iOS)");
					return DPIClassification.DPI_320;
				} else {
					trace("Customized Runtime DPI Provider ==> DPI Forced to 160 (iOS iPad)");
					return DPIClassification.DPI_160;
				}
			// } else if(os.indexOf("iPhone") != -1) {
			// Handle Other Devices
			} else if(Capabilities.screenDPI > 326) {
				trace("Customized Runtime DPI Provider ==> Too many DPI, locking to 320");
				return DPIClassification.DPI_320;
			} else if (screenSize > 4.3 && pixelCheck > 510000 && pixelCheck < 921601 && Capabilities.screenDPI < 240 && pixelCheck != 1296000) {
				trace("Customized Runtime DPI Provider ==> DPI Forced to 240");
				return DPIClassification.DPI_240;
			} else if (screenSize > 6.9 && screenSize < 11 && pixelCheck > 610000 && pixelCheck < 1920000 && pixelCheck != 1296000) {
				trace("Customized Runtime DPI Provider ==> DPI Forced to 240 (Tablet)");
				return DPIClassification.DPI_240; 
			} else {
				trace("Customized Runtime DPI Provider ==> Nothing done!!! Screen DPI: " + Capabilities.screenDPI);
				return Capabilities.screenDPI;
			}
		}
	}
}