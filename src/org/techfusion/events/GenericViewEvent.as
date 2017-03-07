package org.techfusion.events {
	
	// Import default mx Classes
	import flash.events.Event;

	public class GenericViewEvent extends Event {
		
		// Event Type
		public static const INFO_MESSAGE:String			= "info_message";
		public static const INFO_MESSAGE_OK:String		= "info_message_ok";
		public static const INFO_MESSAGE_KO:String		= "info_message_ko";
		public static const INFO_MESSAGE_FLT:String		= "info_message_flt";
		
		// Internal Parameters
		private var _objDP:Object;
		
		public function GenericViewEvent(type:String, objectDataProvider:Object=null) {
			// Super Received Values
			super(type, bubbles, cancelable);
			
			// Store Parameter Locally
			this._objDP = objectDataProvider;
		}
		
		public function getData():Object {
			return _objDP;
		}
		
		public override function clone():Event {
			return new GenericViewEvent(type, _objDP);
		}
	}
}