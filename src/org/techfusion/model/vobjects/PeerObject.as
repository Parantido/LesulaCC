package org.techfusion.model.vobjects {

	public class PeerObject {
		
		private var Channeltype:String;
		private var ObjectName:String;
		private var ChanObjectType:String;
		private var IPaddress:String;
		private var IPport:String;
		private var Dynamic:String;
		private var Forcerport:String;
		private var VideoSupport:String;
		private var TextSupport:String;
		private var ACL:String;
		private var Status:String;
		private var RealtimeDevice:String;
		private var Description:String;
		private var DateTime:String;
		
		/**
		 * Peer Constructor by XML Object
		 */
		public function PeerObject(peer:XML) {
			// Initialize Internal Data Structure
			Channeltype		= String(peer.Channeltype);
			ObjectName		= String(peer.ObjectName);
			ChanObjectType	= String(peer.ChanObjectType);
			IPaddress		= String(peer.IPaddress);
			IPport			= String(peer.IPport);
			Dynamic			= String(peer.Dynamic);
			Forcerport		= String(peer.Forcerport);
			VideoSupport	= String(peer.VideoSupport);
			TextSupport		= String(peer.TextSupport);
			ACL				= String(peer.ACL);
			Status			= String(peer.Status);
			RealtimeDevice	= String(peer.RealtimeDevice);
			Description		= String(peer.Description);
			DateTime		= String(peer.DateTime);
		}
		
		//**************************************/
		//** Define Getter/Setters           ***/
		//**************************************/
		public function getChanneltype():String {
			return(Channeltype);
		}
		
		public function getObjectName():String {
			return(ObjectName);
		}
		
		public function getChanObjectType():String {
			return(ChanObjectType);
		}
		
		public function getIPaddress():String {
			return(IPaddress);
		}
		
		public function getIPport():String {
			return(IPport);
		}
		
		public function getDynamic():String {
			return(Dynamic);
		}
		
		public function getForcerport():String {
			return(Forcerport);
		}
		
		public function getVideoSupport():String {
			return(VideoSupport);
		}
		
		public function getTextSupport():String {
			return(TextSupport);
		}
		
		public function getACL():String {
			return(ACL);
		}
		
		public function getStatus():String {
			return(Status);
		}
		
		public function getRealtimeDevice():String {
			return(RealtimeDevice);
		}
		
		public function getDescription():String {
			return(Description);
		}
		
		public function getDateTime():String {
			return(DateTime);
		}
		
		public function setChanneltype(value:String):void {
			this.Channeltype = value;
		}
		
		public function setObjectName(value:String):void {
			this.ObjectName = value;
		}
		
		public function setChanObjectType(value:String):void {
			this.ChanObjectType = value;
		}
		
		public function setIPaddress(value:String):void {
			this.IPaddress = value;
		}
		
		public function setIPport(value:String):void {
			this.IPport = value;
		}
		
		public function setDynamic(value:String):void {
			this.Dynamic = value;
		}
		
		public function setForcerport(value:String):void {
			this.Forcerport = value;
		}
		
		public function setVideoSupport(value:String):void {
			this.VideoSupport = value;
		}
		
		public function setTextSupport(value:String):void {
			this.TextSupport = value;
		}
		
		public function setACL(value:String):void {
			this.ACL = value;
		}
		
		public function setStatus(value:String):void {
			this.Status = value;
		}
		
		public function setRealtimeDevice(value:String):void {
			this.RealtimeDevice = value;
		}
		
		public function setDescription(value:String):void {
			this.Description = value;
		}
		
		public function setDateTime(value:String):void {
			this.DateTime = value;
		}
	}
}