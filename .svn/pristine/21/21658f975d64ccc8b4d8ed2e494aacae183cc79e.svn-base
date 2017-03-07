package org.techfusion.view.mediators {
	
	// Import Local Package Libraryes
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.techfusion.events.AsteriskEvent;
	import org.techfusion.view.components.PopupDialog;
	
	public class PopupDialogMediator extends Mediator implements IMediator {
		
		public static const NAME:String = "PopupDialogMediator";
		
		// PopupDialog Mediator Constructor
		public function PopupDialogMediator(viewComponent:Object = null) {
			trace(NAME + " ==> Constructor");
			
			// Pass the viewComponent to the superclass where it will be stored in the inherited viewComponent property
			super(NAME, viewComponent);
		}
		
		private function get popup():PopupDialog {
			return viewComponent as PopupDialog;
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
		
		protected function actionHandle(event:AsteriskEvent):void {
			if(event.type)
				sendNotification(ApplicationFacade.ASTEVENT, event, event.type);
		}

		// Facade onRegister Mediators Events
		override public function onRegister():void {
			// Register Event Listeners
			popup.addEventListener(AsteriskEvent.TRANSFER, actionHandle);
			popup.addEventListener(AsteriskEvent.HANGUP, actionHandle);
			popup.addEventListener(AsteriskEvent.PARK, actionHandle);
			
			// Debug
			trace(NAME + " ==> Needed Mediators Registered");
		}
		
		override public function onRemove():void {
			// UnRegister Event Listeners
			popup.removeEventListener(AsteriskEvent.PARK, actionHandle);
			popup.removeEventListener(AsteriskEvent.HANGUP, actionHandle);
			popup.removeEventListener(AsteriskEvent.TRANSFER, actionHandle);
			
			// Debug
			trace(NAME + " ==> Needed Mediators Unregistered");
		}
		
	}
}