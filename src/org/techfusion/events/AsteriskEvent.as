package org.techfusion.events {
	
	// Import default mx Classes
	import flash.events.Event;

	public class AsteriskEvent extends Event {
		
		public static const GET_CHAN_STATUS:String	= "asterisk_getchanstatus";
		public static const GETCTXIDXS:String		= "asterisk_getctxidxs";
		public static const GETQUEUES:String		= "asterisk_getqueues";
		public static const GETCONFIG:String		= "asterisk_getconfig";
		public static const GETPEERS:String			= "asterisk_getpeers";
		public static const TRANSFER:String			= "asterisk_transfer";
		public static const GETCTXS:String			= "asterisk_getctxs";
		public static const CTXIDXS:String			= "asterisk_ctxidxs";
		public static const HANGUP:String			= "asterisk_hangup";
		public static const DOCONF:String			= "asterisk_doconf";
		public static const ASTEVENT:String			= "asterisk_event";
		public static const PARK:String				= "asterisk_park";
		public static const CTXS:String				= "asterisk_ctxs";
		
		private var _commandData:Object;
		
		public function AsteriskEvent(type:String, data:Object=null) {
			// Super Received Values
			super(type, true, cancelable);
			
			// Retrieve Event
			this._commandData = data;
		}
		
		public function getCommandData():Object {
			return _commandData;
		}
		
		public override function clone():Event {
			return new AsteriskEvent(type, _commandData);
		}
	}
}