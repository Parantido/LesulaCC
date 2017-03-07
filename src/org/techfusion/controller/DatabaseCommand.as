package org.techfusion.controller {
	
	// Import PureMVC Model Classes
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.techfusion.model.proxies.DatabaseProxy;
	
	public class DatabaseCommand extends SimpleCommand implements ICommand {
		
		public function DatabaseCommand() {
		}
		
		override public function execute(notification:INotification):void {
			
			// Retrieve Registered Database Proxy
			if(!facade.hasProxy(DatabaseProxy.NAME)) facade.registerProxy(new DatabaseProxy());
			var dbProxy:DatabaseProxy = facade.retrieveProxy(DatabaseProxy.NAME) as DatabaseProxy;
			
			// Check for correct Object Initialization
			if(!dbProxy) {
				trace("DatabaseCommand ==> Unable to retrieve Database Proxy!!!");
				return;
			}
			
			// Retrieve Database Command
			var dbCmdType:String = notification.getType() as String;
			
			// Retrieve Database Command Body
			var dbCmdBody:Object = null;
			if(notification.getBody()) {
				dbCmdBody = notification.getBody();
			}

			// Check What to Do
			switch(dbCmdType) {
				case ApplicationFacade.DB_GETCREDENTS:
					// Retrieve Credentials from Database
					dbProxy.loadCredentials(ApplicationFacade.DB_GETCREDENTS);
					break;
				case ApplicationFacade.DB_SETCREDENTS:
					// Store Credentials to Database
					if(dbCmdBody) dbProxy.storeCredentials(
						ApplicationFacade.DB_SETCREDENTS, dbCmdBody.username, dbCmdBody.password, dbCmdBody.server);
					break;
				case ApplicationFacade.DB_DELCREDENTS:
					// Delete Credentials from Database
					if(dbCmdBody) dbProxy.removeCredentials(
						ApplicationFacade.DB_DELCREDENTS, dbCmdBody.username, dbCmdBody.password, dbCmdBody.server);
					break;	
				case ApplicationFacade.DB_GETBOOKMARK:
					// Retrieve Bookmark Status
					if(dbCmdBody) dbProxy.getBookmarks(ApplicationFacade.DB_GETBOOKMARK, dbCmdBody);
					break;
				case ApplicationFacade.DB_SETBOOKMARK:
					// Retrieve Bookmark Status
					if(dbCmdBody) dbProxy.setBookmark(ApplicationFacade.DB_SETBOOKMARK, dbCmdBody);
					break;
			}
		}
	}
}