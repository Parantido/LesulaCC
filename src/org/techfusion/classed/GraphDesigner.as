package org.techfusion.view.components.classed {
	
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.Screen;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.html.HTMLLoader;
	import flash.net.URLRequest;
	
	public class GraphDesigner {
		
		// Notification Root Window
		private var notification:HTMLLoader		= null;
		private var notificationBody:String		= null;
		private var notificationTitle:String	= null;
		private var notificationImage:String	= null;
		
		// Message Priority
		public static const INFO:String		= "info";
		public static const ERROR:String	= "error";
		public static const WARNING:String	= "warning";
		
		/**
		 * Class Constructor -- Nothing to see here
		 */
		public function GraphDesigner() {
		}
		
		/**
		 * Build a new air window and fill it with an html content
		 */
		public function displayNotification(title:String, message:String, severity:String):void {
			// Setup a new Window
			var options:NativeWindowInitOptions = new NativeWindowInitOptions();
			options.type			= NativeWindowType.LIGHTWEIGHT;
			options.transparent		= true;
			options.systemChrome	= NativeWindowSystemChrome.NONE;
			
			// Set Window Behaviour
			var bounds:Rectangle	= null;
			var screen:Rectangle	= Screen.mainScreen.visibleBounds;
			var windowHeight:int	= 150;
			var windowWidth:int		= 450;
			
			// Draw Window
			bounds = new Rectangle(
				screen.width  - windowWidth  - 40,
				screen.height - windowHeight - 50,
				windowWidth,
				windowHeight
			);
			
			// Load Growl Content
			notification = HTMLLoader.createRootWindow(true, options, false, bounds);
			
			// Setup Content Behaviour
			notification.paintsDefaultBackground = false;
			notification.stage.nativeWindow.alwaysInFront = true;
			notification.navigateInSystemBrowser = true;
			
			// Load Notifier Content Html Page
			var notifySourcePage:String = "/assets/graphs/growl.html";
			var urlRequest:URLRequest = new URLRequest(notifySourcePage);
			
			// Build Notification Content Behaviour
			notificationTitle = title;
			notificationBody  = message;
			
			switch(severity) {
				case INFO:
					notificationImage = "info.png";
					break;
				
				case ERROR:
					notificationImage = "error.png";
					break;
				
				case WARNING:
					notificationImage = "warning.png";
					break;
			}
			
			// Load Url Request Content
			notification.addEventListener(Event.COMPLETE, growlLoaded);
			notification.load(urlRequest);
		}
		
		protected function growlLoaded(event:Event):void {
			notification.window.notifyTitle  = notificationTitle;
			notification.window.contentTitle = "<h1>" + notificationTitle + "</h1>";
			notification.window.contentBody  = "<h2>" + notificationBody  + "</h2>";
			notification.window.contentImage = notificationImage;
			notification.window.customizePage();
		}
	}
}