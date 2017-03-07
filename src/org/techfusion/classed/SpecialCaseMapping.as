package org.techfusion.classed {
	
	import flash.system.Capabilities;
	import mx.core.DPIClassification;
	import mx.core.RuntimeDPIProvider;
	
	public class SpecialCaseMapping extends RuntimeDPIProvider {
		
		public function SpecialCaseMapping() {
		}
		
		override public function get runtimeDPI():Number {
			
			if (Capabilities.screenDPI == 240 && 
				Capabilities.screenResolutionY == 1024 && 
				Capabilities.screenResolutionX == 600) {
				return DPIClassification.DPI_160;
			}
			
			if (Capabilities.screenDPI < 200)
				return DPIClassification.DPI_160;
			
			if (Capabilities.screenDPI <= 280)
				return DPIClassification.DPI_240;
			
			return DPIClassification.DPI_320; 
		}
	}
}