package org.techfusion.view.mediators {
	
	// Import Local Package Libraryes
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ApplicationMediator extends Mediator implements IMediator {
		
		public static const NAME:String = "ApplicationMediator";
		
		// Application Mediator Constructor
		public function ApplicationMediator(viewComponent:Object = null) {
			trace(NAME + " ==> Constructor");
			
			// Pass the viewComponent to the superclass where it will be stored in the inherited viewComponent property
			super(NAME, viewComponent);
		}
		
		private function get lesulacc():LesulaCC {
			return viewComponent as LesulaCC;
		}
		
		override public function listNotificationInterests():Array {
			return [
			];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch (notification.getName()) {
				default:
					break;
			}
		}
		
		/**
		 * Send DISCONNECT Action
		 */
		private function logoutAction(event:Event):void {
			// Rewind Views
			//lesulacc.navigator.popToFirstView();
			// Send Disconnect Notification
			sendNotification(ApplicationFacade.DISCONNECT);
		}
		
		// Facade onRegister Mediators Events
		override public function onRegister():void {
			// Register Event Listeners
			lesulacc.addEventListener(ApplicationFacade.DISCONNECT, logoutAction);
			
			// Debug
			trace(NAME + " ==> Needed Mediators Registered");
		}
		
		override public function onRemove():void {
			// UnRegister Event Listeners
			lesulacc.removeEventListener(ApplicationFacade.DISCONNECT, logoutAction);
			
			// Debug
			trace(NAME + " ==> Needed Mediators Unregistered");
		}
		
	}
}