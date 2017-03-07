package org.techfusion.view.mediators {
	
	// Import default mx Classes
	import com.developmentarc.core.datastructures.utils.HashTable;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.techfusion.events.AsteriskEvent;
	import org.techfusion.view.components.PeersView;
	
	public class PeersViewMediator extends Mediator implements IMediator {
		
		// Mediator Name
		public static const NAME:String		= "PeersViewMediator";
		
		// Hint Status/Value Hash Map
		private var chanStatus:HashTable = new HashTable();
		private var peerStatus:HashTable = new HashTable();
		
		// Mediator Constructor
		public function PeersViewMediator(viewComponent:Object = null) {
			// Debug
			trace("PeersViewMediator ==> Constructor");
			
			// Populate Peer Status Values			
			peerStatus.addItem(0,  "Idle");
			peerStatus.addItem(1,  "In Use");
			peerStatus.addItem(2,  "Busy");
			peerStatus.addItem(4,  "Unavailable");
			peerStatus.addItem(8,  "Ringing");
			peerStatus.addItem(16, "On Hold");
			peerStatus.addItem(-1, "Not Found");
			
			// Populate Channel Status Values
			chanStatus.addItem(0,  "Down");
			chanStatus.addItem(1,  "Rsrvd");
			chanStatus.addItem(2,  "OffHook");
			chanStatus.addItem(3,  "Dialing");
			chanStatus.addItem(4,  "Ring");
			chanStatus.addItem(5,  "Ringing");
			chanStatus.addItem(6,  "Up");
			chanStatus.addItem(7,  "Busy");
			chanStatus.addItem(8,  "Dialing Offhook");
			chanStatus.addItem(9,  "Pre-ring");
			chanStatus.addItem(10, "Unknown");
			
			// Pass the viewComponent to the superclass where it will be stored in the inherited viewComponent property
			super(NAME, viewComponent);
		}
		
		private function get peersView():PeersView {
			return viewComponent as PeersView;
		}
		
		override public function listNotificationInterests():Array {
			return [
				ApplicationFacade.GET_CONFIG,
				ApplicationFacade.DIAL_ENTRY,
				ApplicationFacade.DISCONNECT,
				ApplicationFacade.LOCAL_BRIDGE,
				ApplicationFacade.PEER_STATUS,
				ApplicationFacade.PEER_ENTRY,
				ApplicationFacade.EXT_STATUS,
				ApplicationFacade.NEW_STATE,
				ApplicationFacade.NEW_CHAN,
				ApplicationFacade.STATUS,
				ApplicationFacade.DIAL,
				ApplicationFacade.HANG
			];
		}
		
		override public function handleNotification(notification:INotification):void {
			// Debug
			// trace("################\nIncoming -->\n" + notification.getName() + ":\n" + notification.getBody() + "\n################\n");
			// trace("################\nIncoming Event ::> " + notification.getName());
			
			switch (notification.getName()) {
				case ApplicationFacade.GET_CONFIG:
					handleGetConfig();
					break;
				case ApplicationFacade.PEER_ENTRY:
					populatePeers(notification.getBody() as XML);
					break;
				case ApplicationFacade.PEER_STATUS:
					handlePeerStatus(notification.getBody() as XML);
					break;
				case ApplicationFacade.EXT_STATUS:
					handleExtensionStatus(notification.getBody() as XML);
					break;
				case ApplicationFacade.NEW_STATE:
					handleNewStateEvent(notification.getBody() as XML);
					break;
				case ApplicationFacade.NEW_CHAN:
					handleNewChannelEvent(notification.getBody() as XML);
					break;
				case ApplicationFacade.LOCAL_BRIDGE:
					handleLocalBridgeEvent(notification.getBody() as XML);
					break;
				case ApplicationFacade.STATUS:
					handleChannelStatus(notification.getBody() as XML);
					break;
				case ApplicationFacade.DIAL:
					handleDialEvent(notification.getBody() as XML);
					break;
				case ApplicationFacade.HANG:
					handleHangEvent(notification.getBody() as XML);
					break;
				case ApplicationFacade.DISCONNECT:
					facade.removeMediator(NAME);
					break;
				default:
					break;
			}
		}
		
		/**
		 * Reinitialize Data Structure
		 */
		private function handleGetConfig():void {
			// Empty Data Providers
			peersView.peersIndex = new Dictionary();
			peersView.peersAddressesIndex = new Dictionary();
			peersView.peersDataProvider = new ArrayCollection();
		}
		
		/**
		 * Populate Main View Peers Data Provider
		 */
		private function populatePeers(astEvent:XML):void {
			try {
				// Build Unique Key
				var ukey:String = String(astEvent.Channeltype) + "/" + String(astEvent.ObjectName);
				
				// Build IP Address Key
				var ikey:String = String(astEvent.IPaddress)   + ":" + String(astEvent.IPport);
				
				// Check Item Doesn't Exists in the Index
				if(!peersView.peersIndex[ukey]) {
					// Add Item to List Data Provider
					peersView.peersDataProvider.list.addItem(new XML(astEvent.toString()));
					// Adding Item DataProvider Position to Dictionary
					peersView.peersIndex[ukey] = peersView.peersAddressesIndex[ikey] =
						peersView.peersDataProvider.list.length;
					// Refresh Data Provider
					peersView.peersDataProvider.refresh();
				}
			} catch (e:Error) {
				trace("PeersViewMediator ==> Populate Peer Error: " + e.getStackTrace());
			}
		}
		
		/**
		 * Update Main View Peer Status (when HINT/BLF is used)
		 */
		private function handlePeerStatus(astEvent:XML):void {
			
			// Retrieve Phone Exten to Update
			var peerNameExp:RegExp	= /(.*)\/(.*)/; 
			var peerItems:Array		= peerNameExp.exec(astEvent.child("Peer").toString());
			
			// Retrieve Peer Data Provider Index
			var phoneIndex:int = peersView.findPhoneByName(String(peerItems[2]));
			
			// Check Phone Index is Valid
			if(phoneIndex >= 0) {
				// Retrieve Phone Object
				var found:XML = XML(peersView.peersDataProvider.list.getItemAt(phoneIndex));
				
				// Update Peer Info's
				if(String(astEvent.child("PeerStatus")) == "Registered") {
					var inet:Array	= astEvent.child("Address").toString().split(':');
					found.IPaddress		= inet[0];
					found.IPport		= inet[1];
				} else if(String(astEvent.child("PeerStatus")) == "Unregistered") {
					found.IPaddress		= astEvent.child("Cause").toString();
					found.Status		= "UNKNOWN";
					found.IPport		= "0";
				}
				
				// Set Status Up
				found.Status			= String(astEvent.child("PeerStatus"));
				
				// Replace original ones
				peersView.peersDataProvider.list.setItemAt(found, phoneIndex);
				
				// Refresh Data Provider
				peersView.peersDataProvider.refresh();
			}
			
		}
		
		/**
		 * Update Main View Peer Extension Status
		 */
		private function handleExtensionStatus(astEvent:XML):void {
			
			// Change Phones Layout Status			
			var phoneIndex:int = peersView.findPhoneByName(String(astEvent.child("Exten")));
			
			// Check Phone Index is Valid
			if(phoneIndex >= 0) {
				// Retrieve Phone Object
				var found:XML = XML(peersView.peersDataProvider.list.getItemAt(phoneIndex));
				
				// Change It
				found.Status = peerStatus.getItem(String(astEvent.child("Status")));
				
				// Update it
				peersView.peersDataProvider.list.setItemAt(found, phoneIndex);
				
				// Refresh Data Provider
				peersView.peersDataProvider.refresh();
			}
			
		}
		
		/**
		 * Update Main View Peer related Channel
		 */
		private function handleNewChannelEvent(astEvent:XML):void {
			// Retrieve Event Channel Name
			var channelName:String = String(astEvent.child("Channel"));

			// Find Related Extension If Present
			if(channelName.length > 0) {
				// Populate Channel Buffer
				peersView.channelIndex[String(astEvent.child("Uniqueid"))] = astEvent
			}
		}
		
		/**
		 * Handle Asterisk Channel Optimization
		 */
		private function handleLocalBridgeEvent(astEvent:XML):void {
			// Find Related Extension If Present
			if(
				String(astEvent.child("Channel1")).length > 0 &&
				String(astEvent.child("Channel2")).length > 0
			) {
				
				// Update Channel
				bridgeChannels(String(astEvent.child("Uniqueid1")), String(astEvent.child("Uniqueid2")));
				
			}
		}
		
		/**
		 * Update Peers Status based on Dial Event
		 */
		private function handleDialEvent(astEvent:XML):void {
			
			// Dial Begin -- Attach Source Channel Reference to
			// Destination Peer Reference
			if(String(astEvent.child("SubEvent")) == "Begin") {
				// Retrieve Source/Destination Channel Id
				var srcUniqueID:String	= String(astEvent.child("UniqueID"));
				var dstUniqueID:String	= String(astEvent.child("DestUniqueID"));
				
				// Get Source/Destination Channel Object
				var srcChannel:XML		= (peersView.channelIndex[srcUniqueID]) as XML;
				var dstChannel:XML		= (peersView.channelIndex[dstUniqueID]) as XML;
				
				// Get Source /Destination References
				var srcChannelName:String = getPeerDetails(String(srcChannel.child("Channel")));
				var dstChannelName:String = getPeerDetails(String(dstChannel.child("Channel")));
				
				// Looking for Caller Peer Display Object
				var phoneSrcIndex:Number = -1;
				if(srcChannelName.length) phoneSrcIndex = peersView.findPhoneByName(srcChannelName);
				
				// Looking for Caller Peer Display Object
				var phoneDstIndex:Number = -1;
				if(dstChannelName.length) phoneDstIndex = peersView.findPhoneByName(dstChannelName);
				
				// A service is locally distributing calls (like queue & proxy local channel)
				if(phoneSrcIndex == phoneDstIndex) {
					attachannel2Peer(phoneSrcIndex, srcChannel, astEvent, 0);
				} else {
					// Check For Caller Channel Creation/Deletion
					if(phoneSrcIndex >= 0) {
						attachannel2Peer(phoneSrcIndex, dstChannel, astEvent, 1);
					}
					
					// Check For Callee Channel Creation/Deletion
					if(phoneDstIndex >= 0) {
						attachannel2Peer(phoneDstIndex, srcChannel, astEvent, 2);
					}
				}
			}
		}
		
		/**
		 * Handle Channel State Update
		 */
		private function handleNewStateEvent(astEvent:XML):void {
			// Retrieve Event Channel Name
			var channelName:String = astEvent.child("Channel").toString();
			
			// Find Related Extension If Present
			if(channelName.length > 0) {
				// Replace UniqueID with the bridged one
				var channelId:String = String(astEvent.child("Uniqueid"));
				var channel:XML = peersView.channelIndex[channelId];
				if(String(channel.BridgedTo).length > 0) {
					astEvent.Uniqueid = channelId = channel.BridgedTo;
				}

				// Update State
				attachannelUpdate(channelId, astEvent);
			}
		}
		
		/**
		 * Update Main View Peers Status based on Hangup Event
		 */
		private function handleHangEvent(astEvent:XML):void {
			// Retrieve Event Channel Name
			var channelName:String = String(astEvent.child("Channel"));
			
			// Find Related Extension If Present
			if(channelName.length > 0) {
				// Detach Channel From all Peers
				dettachannelFromPeers(String(astEvent.child("Uniqueid")), channelName);
				
				// Remove Channel From Buffer
				delete peersView.channelIndex[String(astEvent.child("Uniqueid"))];
			}
		}
		
		/**
		 * Attach Requested Channel to Peer
		 */
		protected function attachannel2Peer(peerIndex:Number, channel:XML, astEvent:XML, dialType:int):void {
			// Characters Replacement Regexp
			var replaceChars:RegExp = /(\/|-)/g;
			
			// Retrieve Phone Object
			var found:XML = XML(peersView.peersDataProvider.list.getItemAt(peerIndex));
			
			// Build Channel Name
			var channelid:String = String(channel.child("Channel")).replace(replaceChars, "_");
			
			// Check for DialString Existance -- Internal to External Call
			var calleenum:String = null;
			if(dialType == 0) 
				calleenum = String(astEvent.child("CallerIDNum"));
			else
				calleenum = String(channel.child("CallerIDNum"));
			// If calleenum not found lookin Dial String
			if(calleenum.length <= 0) {
				if(String(astEvent.child("Dialstring")).length > 0)
					calleenum = String(astEvent.child("Dialstring"));
				else
					calleenum = "Unknown";
			}
			
			// Build new Channel Node					
			var newChanNode:XML = new XML(
				"<channel id=\""    + channelid                                    + "\">"              +
				"  <chanName>"      + channelid                                    + "</chanName>"      +
				"  <chanOrig>"      + String(channel.child("Channel"))             + "</chanOrig>"      +
				"  <chanstate>"     + String(channel.child("ChannelState"))        + "</chanstate>"     +
				"  <callidnum>"     + calleenum                                    + "</callidnum>"     +
				"  <callidname>"    + String(channel.child("CallerIDName"))        + "</callidname>"    +
				"  <chanstatedesc>" + String(channel.child("ChannelStateDesc"))    + "</chanstatedesc>" +	
				"  <uniqueid>"		+ String(channel.child("Uniqueid")) 		   + "</uniqueid>"	    +	
				"</channel>"
			);
			
			// Append To Root Node
			found.ChannelsList.channel	+= newChanNode;
			
			// Change Last Channel Information
			found.LastChannel	= String(channel.child("ChannelStateDesc"));
			found.OECallerID	= calleenum;
			
			// Replace With Original one
			peersView.peersDataProvider.list.setItemAt(found, peerIndex);
			
			// Refresh Data Provider
			peersView.peersDataProvider.refresh();
			
			// Attach Channel Peer Reference
			var tmpArrayCollection:ArrayCollection = null;
			if(!peersView.channelReference[String(channel.child("Uniqueid"))]) {
				tmpArrayCollection = new ArrayCollection();
				tmpArrayCollection.addItem(peerIndex);
				peersView.channelReference[String(channel.child("Uniqueid"))] = tmpArrayCollection;
			} else {
				tmpArrayCollection = (peersView.channelReference[String(channel.child("Uniqueid"))] as ArrayCollection);
				tmpArrayCollection.addItem(peerIndex);
				peersView.channelReference[String(channel.child("Uniqueid"))] = tmpArrayCollection;
			}
		}
		
		/**
		 * Update Attached Channel for all Peers
		 */
		protected function attachannelUpdate(channelId:String, channel:XML):void {
			// Get ChannelId References
			var channelIdRefs:ArrayCollection = peersView.channelReference[channelId] as ArrayCollection;
			
			// Channel Not Already Added to a Peer Update it in chan buffer
			if(!channelIdRefs) {
				var chx:XML	= XML(peersView.channelIndex[channelId]);
				chx.ChannelStateDesc	= channel.ChannelStateDesc;
				//chx.ConnectedLineNum	= channel.ConnectedLineNum;
				chx.ChannelState		= channel.ChannelState;
				chx.CallerIDName		= channel.CallerIDName;
				chx.CallerIDNum			= channel.CallerIDNum;
				peersView.channelIndex[channelId] = chx;
				return;
			}
			
			// Cycle All Peer Idx
			for each(var peerIdx:Number in channelIdRefs) {
				
				// Check Peer Index is Valid
				if(peerIdx >= 0) {
					// Retrieve Peer Object
					var found:XML = XML(peersView.peersDataProvider.list.getItemAt(peerIdx));
					
					// Update Node
					if(String(found.ChannelsList.channel.(uniqueid==channelId).uniqueid).length) {
						// Update Channel
						found.ChannelsList.channel.(uniqueid==channelId).chanOrig		= String(channel.Channel);
						found.ChannelsList.channel.(uniqueid==channelId).chanstate		= String(channel.ChannelState);
						found.ChannelsList.channel.(uniqueid==channelId).callidname		= String(channel.CallerIDName);
						found.ChannelsList.channel.(uniqueid==channelId).chanstatedesc	= String(channel.ChannelStateDesc);
						
						// Handle CallerId for Incoming Calls
						/*if(String(channel.ConnectedLineNum).length) {
							found.ChannelsList.channel.(uniqueid==channelId).callidnum =
								found.OECallerID = String(channel.ConnectedLineNum);
						}*/
					}
					
					// Update Last Channel State
					found.LastChannel	= String(channel.ChannelStateDesc);
					
					// Update Node Status
					found.Status = String(channel.ChannelStateDesc);
					
					// Replace With Original one
					peersView.peersDataProvider.list.setItemAt(found, peerIdx);
					
					// Refresh Data Provider
					peersView.peersDataProvider.refresh();
					
				}
			}
		}
		
		/**
		 * Update Attached Channel for all Peers
		 */
		protected function bridgeChannels(oldChannelId:String, newChannelId:String):void {
			var channel:XML = peersView.channelIndex[oldChannelId] as XML;
			channel.BridgedTo = newChannelId;
			peersView.channelIndex[oldChannelId] = channel;
		}
		
		/**
		 * Dettach Channel From Peer
		 */
		protected function dettachannelFromPeers(channelId:String, chanName:String):void {
			// Get ChannelId References
			var channelIdRefs:ArrayCollection = peersView.channelReference[channelId] as ArrayCollection;
			
			// Cycle All Peer Idx
			for each(var peerIdx:Number in channelIdRefs) {
				// Check Peer Index is Valid
				if(peerIdx >= 0) {
					// Retrieve Peer Object
					var found:XML = XML(peersView.peersDataProvider.list.getItemAt(peerIdx));
					
					// Build Channel Name
					var replaceChars:RegExp = /(\/|-)/g;
					var nodeName:String	= chanName.replace(replaceChars, "_");
					
					//trace("Cleaning Index: " + peerIdx + " ChanID: " + channelId + " Node:\n" + found.toString());
					//trace("Channel: " + String(found.ChannelsList.channel.(chanName==nodeName).chanName));
					
					// Update Peer
					if(String(found.ChannelsList.channel.(chanName==nodeName).chanName).length) {
						// Delete Channel Entry
						for each (var match:XML in found.ChannelsList.channel.(chanName==nodeName)) 
							delete found.ChannelsList.channel[match.childIndex()];
					}
					
					// Change Global Peer Status if no channels exists
					if(!countNodeChilds(found.ChannelsList)) {
						found.Status = peerStatus.getItem(0);
						
						// Purge Last Channel Information
						delete found.LastChannel;
						delete found.OECallerID;
						
						// Compleately remove ChannelsList child node
						delete found.ChannelsList;
					}
					
					// Update it
					peersView.peersDataProvider.list.setItemAt(found, peerIdx);
					
					// Refresh Data Provider
					peersView.peersDataProvider.refresh();
				}
			}
		}
	
		private function handleChannelStatus(astEvent:XML):void {
			// Request For Channel Status
			sendNotification(ApplicationFacade.ASTEVENT, null, AsteriskEvent.GET_CHAN_STATUS);
		}
		
		protected function logoutAction(event:Event):void {
			// Send Disconnect Notification
			sendNotification(ApplicationFacade.DISCONNECT);
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
		
		/**
		 * Count Dictionary Size
		 */
		public static function dictSize(dictionary:flash.utils.Dictionary):int {
			var n:int = 0;
			for (var key:* in dictionary) {
				n++;
			}
			return n;
		}
		
		/**
		 * Get Peer Details from Channel Name
		 */
		private function getPeerDetails(channel:String, detail:String="name"):String {
			var chanSyntax1:RegExp = /(.*)\/(.*)@(.*)-(.*)/g;
			var chanSyntax2:RegExp = /(.*)\/(.*)-(.*)/g;
		
			var returnValue:String = null;
			var channelParts:Array = null;
			
			if((channelParts = chanSyntax1.exec(channel)) != null) {
				returnValue = (detail == "name") ? channelParts[2] : channelParts[1];
			} else if((channelParts = chanSyntax2.exec(channel)) != null) {
				returnValue = (detail == "name") ? channelParts[2] : channelParts[1];
			}
			
			return returnValue;
		}
		
		override public function onRegister():void {
			// Initialize Channels Buffer
			peersView.channelIndex = new Dictionary();
			peersView.channelReference = new Dictionary();
			
			// Register Event Handlers
			peersView.addEventListener(ApplicationFacade.DISCONNECT, logoutAction);
			
			// Debug
			trace("PeersViewMediator ==> PeersViewMediator Registered");
		}
		
		override public function onRemove():void {
			// Unregister Event Handlers
			peersView.removeEventListener(ApplicationFacade.DISCONNECT, logoutAction);
			
			// Garbage Collect Buffer
			peersView.channelIndex  = null;
			peersView.channelReference = null;
			
			// Debug
			trace("PeersViewMediator ==> PeersViewMediator Unregistered");
		}
		
	}
}
