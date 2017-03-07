package org.techfusion.events {
	
	// Import default mx Classes
	import flash.events.Event;

	public class LoginViewEvent extends Event {
		
		public static const LOGIN:String		= "login";
		public static const DISCONNECT:String	= "disconnect";
		
		private var manageruser:String;
		private var managerpass:String;
		private var managerserv:String;
		
		public function LoginViewEvent(type:String, username:String = null, password:String = null, server:String = null) {
			
			super(type, bubbles, cancelable);
			
			this.manageruser = username;
			this.managerpass = password;
			this.managerserv = server;
		}
		
		public function getUsername():String {
			return manageruser;
		}
		
		public function getPassword():String {
			return managerpass;
		}
		
		public function getServer():String {
			return managerserv;
		}
		
		public override function clone():Event {
			return new LoginViewEvent(type, manageruser, managerpass, managerserv);
		}
	}
}