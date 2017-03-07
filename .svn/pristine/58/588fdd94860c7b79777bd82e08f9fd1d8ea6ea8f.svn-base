package org.techfusion.events {
	
	// Import default mx Classes
	import flash.events.Event;

	public class DatabaseViewEvent extends Event {
		
		public static const DB_INITIALIZED:String	= "db_initialized";
		public static const DB_GETCREDENTS:String	= "db_getcredents";
		public static const DB_SETCREDENTS:String	= "db_setcredents";
		public static const DB_DELCREDENTS:String	= "db_delcredents";
		public static const DB_QUERYRETURN:String	= "db_queryreturn";
		public static const DB_GETBOOKMARK:String	= "db_getbookmark";
		public static const DB_SETBOOKMARK:String	= "db_setbookmark";
		
		private var _data:Object;
		
		public function DatabaseViewEvent(type:String, data:Object = null) {
			
			super(type, bubbles, cancelable);
			
			this._data = data;
		}
		
		public function getData():Object {
			return this._data;
		}
		
		public override function clone():Event {
			return new DatabaseViewEvent(type, _data);
		}
	}
}