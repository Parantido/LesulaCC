package org.techfusion.view.mediators {
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.techfusion.view.components.RightQueuesView;
	
	public class RightQueuesViewMediator extends Mediator implements IMediator {
		
		// Mediator Name
		public static const NAME:String		= "RightQueuesViewMediator";
		
		public function RightQueuesViewMediator(viewComponent:Object = null) {
			// Debug
			trace("RightQueuesViewMediator ==> Constructor");
			
			// Pass the viewComponent to the superclass where it will be stored in the inherited viewComponent property
			super(NAME, viewComponent);
		}
		
		private function get rightQueuesView():RightQueuesView {
			return viewComponent as RightQueuesView;
		}
		
		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.QUEUE_JOIN,
				ApplicationFacade.QUEUE_LEAVE,
				ApplicationFacade.QUEUE_PAR,
				ApplicationFacade.QUEUE_SUM,
				ApplicationFacade.QUEUE_MEM,
				ApplicationFacade.DISCONNECT
			];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch (notification.getName()) {
				case ApplicationFacade.QUEUE_JOIN:
					handleJoinEvent(notification.getBody() as XML);
					break;
				case ApplicationFacade.QUEUE_LEAVE:
					handleLeaveEvent(notification.getBody() as XML);
					break;
				case ApplicationFacade.QUEUE_PAR:
					handleQueueParams(notification.getBody() as XML);
					break;
				case ApplicationFacade.QUEUE_SUM:
					handleQueueSummary(notification.getBody() as XML);
					break;
				case ApplicationFacade.QUEUE_MEM:
					handleQueueMemberEntry(notification.getBody() as XML);
					break;
				case ApplicationFacade.DISCONNECT:
					facade.removeMediator(NAME);
					break;
				default:
					//trace("Right Queue ==> Unhandled: " + notification.getName() + "");
					break;
			}
		}
		
		/**
		 * Notify View Creation Event
		 */
		private function handleViewCreated(event:Event):void {
			sendNotification(ApplicationFacade.QUEUE_VIEW_FNSHD, null, ApplicationFacade.QUEUE_VIEW_FNSHD);
		}
		
		/**
		 * Notify View Destruction Event
		 */
		private function handleViewRemoved(event:Event):void {
			sendNotification(ApplicationFacade.QUEUE_VIEW_REMVD, null, ApplicationFacade.QUEUE_VIEW_REMVD);
		}
		
		/**
		 * Add To Data Provider Queue Incoming Calls 
		 */
		private function handleJoinEvent(astEvent:XML):void {
			try {
				if(!rightQueuesView.callsIndex.hasOwnProperty(String(astEvent.Uniqueid))) {
					// Add Item to List Data Provider
					rightQueuesView.callsDataProvider.addItem(astEvent);
					// Index Added Queues
					rightQueuesView.callsIndex[String(astEvent.Uniqueid)] =
						(rightQueuesView.callsDataProvider.length - 1);
				} else {
					// Update Already Existent Item
					rightQueuesView.callsDataProvider.setItemAt(
						astEvent,
						rightQueuesView.callsIndex[String(astEvent.Uniqueid)]
					);
				}
			} catch (e:Error) {
				trace("RightQueuesViewMediator ==> Call Join Error: " + e.getStackTrace());
			}
		}
		
		/**
		 * Remove Call from Data Provider Queue 
		 */
		private function handleLeaveEvent(astEvent:XML):void {
			try {
				if(rightQueuesView.callsIndex.hasOwnProperty(String(astEvent.Uniqueid))) {
					if(rightQueuesView.callsDataProvider.getItemAt(rightQueuesView.callsIndex[String(astEvent.Uniqueid)])) {
						// Remove Item from Data Provider
						rightQueuesView.callsDataProvider.removeItemAt(
							rightQueuesView.callsIndex[String(astEvent.Uniqueid)]
						);
					}
					// Purge Item Index
					delete rightQueuesView.callsIndex[String(astEvent.Uniqueid)];
				}
			} catch (e:Error) {
				trace("RightQueuesViewMediator ==> Call Leave Error: " + e.getStackTrace());
			}
		}
		
		/**
		 * Populate Left View Queue Data Provider
		 */
		private function handleQueueParams(astEvent:XML):void {
			try {
				if(!rightQueuesView.queuesIndex.hasOwnProperty(String(astEvent.Queue))) {
					// Add Item to List Data Provider
					rightQueuesView.queuesDataProvider.list.addItem(astEvent);
					// Index Added Queues
					rightQueuesView.queuesIndex[String(astEvent.Queue)] =
						(rightQueuesView.queuesDataProvider.list.length - 1);
				} else {
					// Update Already Existent Item
					rightQueuesView.queuesDataProvider.list.setItemAt(
						astEvent,
						rightQueuesView.queuesIndex[String(astEvent.Queue)]
					);
				}
			} catch (e:Error) {
				trace("RightQueuesViewMediator ==> Handle Queue Params: " + e.getStackTrace());
			}
		}
		
		/**
		 * Update an already existing Queue object with
		 * number of logged agent information.
		 */
		private function handleQueueSummary(astEvent:XML):void {
			try {
				if(rightQueuesView.queuesIndex.hasOwnProperty(String(astEvent.Queue))) {
					// Get Item from Data Provider
					var object:XML = rightQueuesView.queuesDataProvider.list.getItemAt(
						rightQueuesView.queuesIndex[String(astEvent.Queue)]
					) as XML;
					// Add Needed Fields
					object.AgentsLoggedIn  = String(astEvent.LoggedIn);
					object.AgentsAvailable = String(astEvent.Available);
					// Update DataProvider
					rightQueuesView.queuesDataProvider.list.setItemAt(
						object,
						rightQueuesView.queuesIndex[String(astEvent.Queue)]
					);
				}
			} catch (e:Error) {
				trace("RightQueuesViewMediator ==> Handle Queue Summary: " + e.getStackTrace());
			}
		}
		
		/**
		 * Populating Queue Members Data Provider
		 */
		private function handleQueueMemberEntry(astEvent:XML):void {
			try {
				if(!rightQueuesView.queuesMemberIndex.hasOwnProperty(String(astEvent.Location))) {
					// Add Member to List Data Provider
					rightQueuesView.queuesMemberDataProvider.list.addItem(astEvent);
					// Index Added Queue Member
					rightQueuesView.queuesMemberIndex[String(astEvent.Location)] =
						(rightQueuesView.queuesMemberDataProvider.list.length - 1);
				} else {
					// Update Already Existent Member
					rightQueuesView.queuesMemberDataProvider.list.setItemAt(
						astEvent,
						rightQueuesView.queuesMemberIndex[String(astEvent.Queue)]
					);
				}
			} catch (e:Error) {
				trace("RightQueuesViewMediator ==> Handle Queue Member Entry: " + e.getStackTrace());
			}
		}
		
		override public function onRegister():void {			
			rightQueuesView.addEventListener(ApplicationFacade.CREATE, handleViewCreated);
			rightQueuesView.addEventListener(ApplicationFacade.DESTROY, handleViewRemoved);
			
			// Debug
			trace("RightQueuesViewMediator ==> RightQueuesViewMediator Registered");
		}
		
		override public function onRemove():void {
			rightQueuesView.removeEventListener(ApplicationFacade.DESTROY, handleViewRemoved);
			rightQueuesView.removeEventListener(ApplicationFacade.CREATE, handleViewCreated);
			
			// Debug
			trace("RightQueuesViewMediator ==> RightQueuesViewMediator Unregistered");
		}
		
	}
}
