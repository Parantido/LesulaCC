package org.techfusion.view.mediators {
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.techfusion.events.AsteriskEvent;
	import org.techfusion.events.DatabaseViewEvent;
	import org.techfusion.events.GenericViewEvent;
	import org.techfusion.view.renderers.PeerRenderer;
	
	public class PeerCalloutViewMediator extends Mediator implements IMediator {
		
		// Mediator Name
		public static const NAME:String		= "PeerCalloutViewMediator";
		
		// Local BookMark Object
		private  var bookmark:Object		= ApplicationFacade.getInstance()._credentials;
		
		public function PeerCalloutViewMediator(viewComponent:Object = null) {
			// Pass the viewComponent to the superclass where it
			// will be stored in the inherited viewComponent property
			super(NAME, viewComponent);
			
			// Debug
			trace("PeerCalloutViewMediator ==> Constructor");
		}
		
		private function get peer():PeerRenderer {
			return viewComponent as PeerRenderer;
		}
		
		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.CTXS,
				ApplicationFacade.DB_SETBOOKMARK_OK
			];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch (notification.getName()) {
				case ApplicationFacade.CTXS:
					// Update Context Data Provider
					peer.contextDataProvider = new ArrayCollection()
					peer.contextDataProvider = notification.getBody() as ArrayCollection;
					break;
				case ApplicationFacade.DB_SETBOOKMARK_OK:
					// Notify Bookmark Status
					sendNotification(
						ApplicationFacade.INFO_MESSAGE_OK,
						new GenericViewEvent(GenericViewEvent.INFO_MESSAGE_OK, "Bookmark successfully modified"),
						GenericViewEvent.INFO_MESSAGE_OK
					);
					// Newly Require Bookmark Data
					sendNotification(ApplicationFacade.DBCMD, bookmark, DatabaseViewEvent.DB_GETBOOKMARK);
					// Reset State And Close Callout Button
					peer.currentState = 'Base'; peer.coButton.closeDropDown();
					break;
				default:
					trace("PeerCalloutViewMediator ==> Unhandled: " + notification.getName() + "");
					break;
			}
		}
		
		/**
		 * Set BookMark Status
		 */
		protected function setBookmark(event:Event):void {
			// Check Bookmark update status
			if(
				!ApplicationFacade.getInstance()._bookmarks[bookmark.unique_key] ||
				 ApplicationFacade.getInstance()._bookmarks[bookmark.unique_key] == false
			) {
				bookmark.value = true;
			} else {
				bookmark.value = false;
			}
			// Dispatch notification
			sendNotification(ApplicationFacade.DBCMD, bookmark, ApplicationFacade.DB_SETBOOKMARK);
		}
		
		/**
		 * Request Asterisk Context
		 */
		protected function contextHandler(event:Event):void {
			// Dispatch notification
			sendNotification(ApplicationFacade.ASTEVENT, null, ApplicationFacade.GET_CTXS);
		}
		
		override public function onRegister():void {
			// Update Mediator Data
			bookmark.key = peer.peerName;
			bookmark.unique_key = peer.peerName + "@" + bookmark.server;
			
			// Update BookMark Status
			if(
				!ApplicationFacade.getInstance()._bookmarks[bookmark.unique_key] ||
				 ApplicationFacade.getInstance()._bookmarks[bookmark.unique_key] == "false"
			) {
				peer.imgBookmark.source = "/assets/images/bookmark.png";
			} else {
				peer.imgBookmark.source = "/assets/images/bookmarked.png";
			}
			
			// Register Events Listener
			peer.addEventListener(DatabaseViewEvent.DB_SETBOOKMARK, setBookmark);
			peer.addEventListener(AsteriskEvent.GETCTXS, contextHandler);
			
			// Debug
			trace("PeerCalloutViewMediator ==> Callout Mediator Registered");
		}
		
		override public function onRemove():void {
			// Unregister Events Listener
			peer.removeEventListener(AsteriskEvent.GETCTXS, contextHandler);
			peer.removeEventListener(DatabaseViewEvent.DB_SETBOOKMARK, setBookmark);			
			
			// Purge Data Structures
			peer.contextDataProvider	= null;
			
			// Debug
			trace("PeerCalloutViewMediator ==> Callout Mediator Unregistered");
		}
	}
}
