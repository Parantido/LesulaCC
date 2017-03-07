package org.techfusion.view.mediators {
	
	// Import default mx Classes
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.techfusion.events.AsteriskEvent;
	import org.techfusion.view.components.QueuesView;
	
	public class QueuesViewMediator extends Mediator implements IMediator {
	
		private var view_count:int			= 0;
		public  static const NAME:String	= "QueuesViewMediator";
		
		public function QueuesViewMediator(viewComponent:Object = null) {
			// Debug
			trace("QueuesViewMediator ==> Constructor");
			
			// Pass the viewComponent to the superclass where it will be stored in the inherited viewComponent property
			super(NAME, viewComponent);
		}
		
		private function get queuesView():QueuesView {
			return viewComponent as QueuesView;
		}
		
		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.QUEUE_VIEW_FNSHD,
				ApplicationFacade.DISCONNECT
			];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch (notification.getName()) {
				
				case ApplicationFacade.QUEUE_VIEW_FNSHD:
					// Do Initial View Request
					doInitialRequest();
					break;
				
				case ApplicationFacade.DISCONNECT:
					facade.removeMediator(NAME);
					break;
				
				default:
					break;
			}
		}
		
		override public function onRegister():void {
			// Debug
			trace("QueuesViewMediator ==> QueuesViewMediator Registered");
		}
		
		override public function onRemove():void {
			// Debug
			trace("QueuesViewMediator ==> QueuesViewMediator Unregistered");
		}
		
		/****************************
		 * Begin of Custom Functions 
		 * 
		 ****************************/
		
		/**
		 * Executed only after all subview was created
		 */
		private function doInitialRequest():void {
			// Increment View Count
			view_count++;
			
			// Check for correct number of view to finish
			if(view_count == 2) {
				// Request For Queues List
				sendNotification(ApplicationFacade.ASTEVENT, null, AsteriskEvent.GETQUEUES);
			}
		}
		
		/**
		 * Executed only after all subview was destroyed
		 */
		private function doFinalRequest():void {
			// Decrement View Count
			view_count--;
		}
	}
}
