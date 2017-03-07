package org.techfusion.utils.enhancedDataGrid {
	// Import class
	import flash.events.Event;

	public class enhancedDataGridEvent extends Event {
		// Additionals Args
		public var arg:*;
		
		public function enhancedDataGridEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, ... a:*) {
			super(type, bubbles, cancelable);
			arg = a;
		}
		
		// Override clone
		override public function clone():Event{
			return new enhancedDataGridEvent(type, bubbles, cancelable, arg);
		};
	}
}