package package_108
{
   import com.kixeye.logging.KXLogger;
   import com.kixeye.logging.class_72;
   import package_157.ObserverNotificationTrigger;
   import package_21.class_330;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.events.Event;
   import com.kixeye.utils.json.ActionJSON;
   import com.waterworld.utils.javascript.class_46;
   import com.waterworld.core.GLOBAL;
   
   public class BattlePiratesJSONRemoteProcedureCall extends AbstractRemoteProcedureCall implements class_198
   {
      
      private static var _log:KXLogger = class_72.getLoggerForClass(BattlePiratesJSONRemoteProcedureCall);
      
      {
         _log = class_72.getLoggerForClass(BattlePiratesJSONRemoteProcedureCall);
      }
      
      public var observerNotificationTrigger:ObserverNotificationTrigger;
      
      private var var_1076:Object;
      
      private var var_6092:String;
      
      private var var_4703:Boolean = false;
      
      public function BattlePiratesJSONRemoteProcedureCall(param1:String, param2:Array, param3:String, param4:Function, param5:Function, param6:String, param7:String, param8:Boolean, param9:Boolean, param10:int = 3, param11:Boolean = false, param12:Boolean = false)
      {
         if(!param11 && param2 && param2.length && param2[0] is Array)
         {
            param2.sort(sortParams);
         }
         var_4703 = param12;
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10);
      }
      
      private static function sortParams(param1:Array, param2:Array) : int
      {
         if(param1[0] == param2[0])
         {
            return 0;
         }
         return param1[0] < param2[0]?-1:1.0;
      }
      
      override public function get data() : Object
      {
         return var_1076;
      }
      
      public function get rawResponse() : String
      {
         return var_6092;
      }
      
      override public function get isError() : Boolean
      {
         return var_1076 == null || var_1076.error != null && var_1076.error != 0;
      }
      
      public function replaceJSON(param1:Object) : void
      {
         var_1076 = param1;
      }
      
      override protected function doCall() : void
      {
         class_330.startLoadTime(var_4172);
         var_261 = new URLLoader();
         if(var_3394 == "GET")
         {
            if(var_376.indexOf("?") > 0)
            {
               var_376 = §§dup().var_376 + "&";
            }
         }
         var _loc1_:URLRequest = new URLRequest(var_376);
         if(var_1691 != null)
         {
            _loc1_.data = var_1691;
         }
         _loc1_.method = var_3394;
         var_261.addEventListener("complete",handleLoadComplete);
         var_261.addEventListener("ioError",handleIOError);
         var_261.addEventListener("securityError",handleSecurityError);
         var_261.load(_loc1_);
      }
      
      override protected function handleLoadComplete(param1:Event) : void
      {
         var _loc2_:* = false;
         stopListening();
         var_1076 = ActionJSON.decodeJSON(var_261.data,var_376,var_1691);
         var _loc3_:* = true;
         if(var_4999 && !var_5854)
         {
            if(!verifyHash(var_261.data,var_3382))
            {
               _loc3_ = false;
            }
         }
         if(_loc3_)
         {
            if(_onSuccess != null)
            {
               if(data.hasOwnProperty("error") && data.error != 0 && (data.error).indexOf("updated") >= 0)
               {
                  observerNotificationTrigger.dispatch(10,{"url":var_376});
               }
               _onSuccess(this);
            }
         }
         else if(var_5864)
         {
            class_46.CallJS("reloadPage");
         }
         else
         {
            observerNotificationTrigger.dispatch(20,{
               "url":var_376,
               "saltSeed":var_3382,
               "data":var_261.data
            });
            if(var_1076 && var_1076.error == "1" && var_1076.update == "1")
            {
               GLOBAL.showUpdateMessage();
            }
            _loc2_ = var_4703;
            if(_loc2_)
            {
               _onFailure(this);
            }
            else
            {
               _log.logRemote("BattlePiratesJSONRemoteProcedureCall.handleLoadComplete","Blocking failiure callback for " + var_376);
            }
         }
         _onSuccess = null;
         _onFailure = null;
      }
   }
}
