package org.techfusion.view.mediators {
	
	// Import default mx Classes
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.techfusion.view.components.DebuggerView;
	
	public class DebuggerViewMediator extends Mediator implements IMediator {
		
		// Mediator Name
		public static const NAME:String		= "DialplanDebuggerViewMediator";
		
		// Local Dictionary index
		private var channelsIndex:Dictionary = new Dictionary();
		private var channelsIpPortIndex:Dictionary = new Dictionary();
		
		// Constructor
		public function DebuggerViewMediator(viewComponent:Object = null) {
			// Debug
			trace(NAME + " ==> Constructor");
			
			// Pass the viewComponent to the superclass where it will
			// will be stored in the inherited viewComponent property
			super(NAME, viewComponent);
		}
		
		private function get dDebuggerView():DebuggerView {
			return viewComponent as DebuggerView;
		}
		
		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.HANG,
				ApplicationFacade.VAR_SET,
				ApplicationFacade.NEW_CHAN,
				ApplicationFacade.NEW_EXTEN,
				ApplicationFacade.RTCP_TX,
				ApplicationFacade.RTCP_RX
			];
		}
		
		override public function handleNotification(notification:INotification):void {
			switch (notification.getName()) {
				case ApplicationFacade.HANG:
					handleHangEvent(notification.getBody() as XML);
					break;
				case ApplicationFacade.VAR_SET:
					handleVarSet(notification.getBody() as XML);
					break;
				case ApplicationFacade.NEW_CHAN:
					handleNewChannelEvent(notification.getBody() as XML);
					break;
				case ApplicationFacade.NEW_EXTEN:
					handleNewExtension(notification.getBody() as XML);
					break;
				case ApplicationFacade.RTCP_TX:
					handleSentRTCP(notification.getBody() as XML);
					break;
				case ApplicationFacade.RTCP_RX:
					handleReceivedRTCP(notification.getBody() as XML);
					break;
				default:
					trace(NAME + "Unhandled event: " + notification.getName());
					break;
			}
		}
		
		/**
		 * Delete Channel Away from data provider
		 */
		private function handleHangEvent(astEvent:XML):void {
			// Retrieve Event Channel Name
			var channelName:String = astEvent.child("Channel").toString();
			
			// Retrieve Endpoint IP Address/Port
			var ipaddrport:String = String(astEvent.IPaddress) + ":" + String(astEvent.IPport);
			
			// Find Related Extension If Present
			if(channelName.length > 0) {
				// Check Items Exists in Dictonary Index
				if(channelsIndex[channelName] != null && channelsIpPortIndex[ipaddrport] != null) {
					// Remove Item from data provider
					dDebuggerView.callsDataProvider.removeItemAt(channelsIndex[channelName]);
					// Deindex it
					delete channelsIndex[channelName];
					delete channelsIpPortIndex[ipaddrport];
				}
			}
		}
		
		/**
		 * Handle Asterisk Internal Variable Setup
		 */
		private function handleVarSet(astEvent:XML):void {
			try {
				if(astEvent.toString().length > 0) {
					// Write it down in Dialplan Debugger Spark List
					dDebuggerView.itemsDataProvider.addItem(astEvent);
				}
			} catch (e:Error) {
				trace(NAME + " ==> Handle Var Setup: " + e.getStackTrace());
			}
		}
		
		/**
		 * Handle Channel Creation Event
		 */
		private function handleNewChannelEvent(astEvent:XML):void {
			// Retrieve Event Channel Name
			var channelName:String = String(astEvent.child("Channel"));
			
			// Retrieve Endpoint IP Address/Port
			var ipaddrport:String = String(astEvent.IPaddress) + ":" + String(astEvent.IPport);
			
			// Find Related Extension If Present
			if(channelName.length > 0) {
				// Check Item Doesn't Exists in the Index
				if(channelsIndex[channelName] == null && channelsIpPortIndex[ipaddrport] == null) {
					// Add Item to List Data Provider
					dDebuggerView.callsDataProvider.list.addItem(new XML(astEvent.toString()));
					// Adding Item DataProvider Position to Dictionary
					channelsIndex[channelName] = channelsIpPortIndex[ipaddrport] = 
						(dDebuggerView.callsDataProvider.list.length - 1);
					// Refresh Data Provider
					dDebuggerView.callsDataProvider.refresh();
				}
			}
		}
		
		/**
		 * Handle Dialplan Extensions Execution
		 */
		private function handleNewExtension(astEvent:XML):void {
			try {
				if(astEvent.toString().length > 0) {
					dDebuggerView.itemsDataProvider.addItem(astEvent);
				}
			} catch (e:Error) {
				trace(NAME + " ==> Handle Dialplan Extension: " + e.getStackTrace());
			}
		}
		
		/**
		 * Handle Sent RTCP Packet Event
		 */
		private function handleSentRTCP(astEvent:XML):void {
			try {
				// Retrieve Endpoint IP Address/Port
				var ipaddrport:String = String(astEvent.IPaddress) + ":" + String(astEvent.IPport);
				// Check Items Exists in Dictonary Index
				if(channelsIpPortIndex[ipaddrport] != null) {
					// Retrieve Stored XML Object
					var node:XML = dDebuggerView.callsDataProvider.list.getItemAt(channelsIpPortIndex[ipaddrport]) as XML;
					
					// Update IT
					node.SentPackets	= String(astEvent.SentPackets);
					node.SentOctets		= String(astEvent.SentOctets);
					node.CumulativeLoss	= String(astEvent.CumulativeLoss);
					
					// Replace IT
					dDebuggerView.callsDataProvider.list.setItemAt(node, channelsIpPortIndex[ipaddrport]);
					
					// Refresh Data Provider
					dDebuggerView.callsDataProvider.refresh();
				}
			} catch (e:Error) {
				trace(NAME + " ==> Handle Sent RTCP Pckt: " + e.getStackTrace());
			}
		}
		
		/**
		 * Handle Received RTCP Packet Event
		 */
		private function handleReceivedRTCP(astEvent:XML):void {
			try {
				// Retrieve Endpoint IP Address/Port
				var ipaddrport:String = String(astEvent.IPaddress) + ":" + String(astEvent.IPport);
				// Check Items Exists in Dictonary Index
				if(channelsIpPortIndex[ipaddrport] != null) {
					// Retrieve Stored XML Object
					var node:XML = dDebuggerView.callsDataProvider.list.getItemAt(channelsIpPortIndex[ipaddrport]) as XML;
					
					// Update IT
					node.PacketsLost	= String(astEvent.PacketsLost);
					node.RTT			= String(astEvent.RTT);
					node.IAJitter		= String(astEvent.IAJitter);
					
					// Replace IT
					dDebuggerView.callsDataProvider.list.setItemAt(node, channelsIpPortIndex[ipaddrport]);
					
					// Refresh Data Provider
					dDebuggerView.callsDataProvider.refresh();
				}
			} catch (e:Error) {
				trace(NAME + " ==> Handle Received RTCP Pckt: " + e.getStackTrace());
			}
		}
		
		/**
		 * Return Node Childs Number
		 */
		private function countNodeChilds(node:XMLList):int {
			var counter:int = 0;
			
			for each (var child:XML in node) {
				if(String(child).length) counter++;
			}
			
			return(counter);
		}
		
		override public function onRegister():void {
			// Debug
			trace(NAME + " ==> DialplanDebuggerViewMediator Registered");
		}
		
		override public function onRemove():void {
			// Debug
			trace(NAME + " ==> DialplanDebuggerViewMediator Unregistered");
		}
		
	}
}
