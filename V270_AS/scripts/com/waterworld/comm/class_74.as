package com.waterworld.comm
{
   import package_157.ObserverNotificationTrigger;
   import flash.utils.Dictionary;
   import com.waterworld.core.GlobalProperties;
   import package_108.BattlePiratesJSONRemoteProcedureCall;
   import package_108.class_198;
   
   public class class_74 extends Object
   {
      
      public static const const_3072:String = "Y9U653YU641VUU3U1U6Z497075076655";
      
      public static const const_3397:String = "073c187f8a02f626210bbcb7f55a4cee";
      
      public static const const_789:String = "1447UV863236UYZZ154V82Z53V676YW9";
      
      public static const const_2277:int = 3;
      
      public static var var_1593:String;
      
      public static var observerNotificationTrigger:ObserverNotificationTrigger;
      
      protected static var var_6:String;
      
      protected static var var_1949:String;
      
      protected static var var_3990:String;
      
      protected static var var_3240:Dictionary = new Dictionary();
      
      private static var var_3694:Boolean;
      
      {
         var_3240 = new Dictionary();
      }
      
      public function class_74()
      {
         super();
      }
      
      public static function setURLs(param1:String, param2:String, param3:String, param4:String) : void
      {
         var_6 = param1;
         var_1949 = param2;
         var_3990 = param3;
         var_1593 = param4;
      }
      
      public static function halt() : void
      {
         var_3694 = true;
      }
      
      protected static function sendRequest(param1:String, param2:String, param3:Array, param4:String, param5:Function, param6:Function, param7:String = "GET", param8:int = 3, param9:Boolean = false, param10:Boolean = false) : void
      {
         var _loc11_:* = null;
         if(var_3694)
         {
            return;
         }
         var _loc12_:String = null;
         if(param9)
         {
            _loc11_ = getFbData();
            if(_loc11_["signed_request"])
            {
               _loc12_ = "?ts=" + GlobalProperties.gameTime + "&signed_request=" + _loc11_["signed_request"];
            }
         }
         if(_loc12_ == null)
         {
            _loc12_ = "?";
         }
         else
         {
            _loc12_ = _loc12_ + "&";
         }
         _loc12_ = _loc12_ + ("game_signed_request=" + GlobalProperties.gameSignedRequest);
         var param1:String = param1 + _loc12_;
         dispatchRequest(param1,param3,param4,param5,param6,param7,param2 != null?param2:"073c187f8a02f626210bbcb7f55a4cee",false,true,param8,param10);
      }
      
      protected static function loadRequest(param1:String, param2:String, param3:Array, param4:String, param5:Function, param6:Function, param7:Boolean = true, param8:String = "POST", param9:Boolean = true, param10:Boolean = false, param11:int = 3, param12:Boolean = false, param13:Boolean = false) : void
      {
         var _loc15_:* = null;
         var _loc16_:* = null;
         if(var_3694)
         {
            return;
         }
         if(param7)
         {
            _loc15_ = getFbData();
            _loc16_ = "";
            var _loc18_:* = 0;
            var _loc17_:* = _loc15_;
            for(var _loc14_ in _loc15_)
            {
               _loc16_ = _loc16_ + ("&" + _loc14_ + "=" + _loc15_[_loc14_]);
            }
            _loc16_ = _loc16_.substr(1);
            var param1:String = param1 + ("?ts=" + GlobalProperties.gameTime + "&" + _loc16_ + "&game_signed_request=" + GlobalProperties.gameSignedRequest);
         }
         else
         {
            param1 = param1 + ("?game_signed_request=" + GlobalProperties.gameSignedRequest);
         }
         dispatchRequest(param1,param3,param4,param5,param6,param8,param2 != null?param2:"073c187f8a02f626210bbcb7f55a4cee",param9,param10,param11,param12,param13);
      }
      
      private static function dispatchRequest(param1:String, param2:Array, param3:String, param4:Function, param5:Function, param6:String, param7:String, param8:Boolean, param9:Boolean, param10:int = 3, param11:Boolean = false, param12:Boolean = false) : void
      {
         url = param1;
         params = param2;
         requestId = param3;
         onSuccess = param4;
         onFailure = param5;
         requestMethod = param6;
         saltSeed = param7;
         isSecure = param8;
         ignoreHashFailure = param9;
         retries = param10;
         maintainParamOrder = param11;
         allowFailureCallbackInProduction = param12;
         onSuccessCleanup = function(param1:class_198):void
         {
            delete var_3240[param1];
            if(onSuccess != null)
            {
               onSuccess(param1);
            }
         };
         onFailureCleanup = function(param1:class_198):void
         {
            delete var_3240[param1];
            if(onFailure != null)
            {
               onFailure(param1);
            }
         };
         var call:BattlePiratesJSONRemoteProcedureCall = new BattlePiratesJSONRemoteProcedureCall(url,params,requestId,onSuccessCleanup,onFailureCleanup,requestMethod,saltSeed != null?saltSeed:"073c187f8a02f626210bbcb7f55a4cee",isSecure,ignoreHashFailure,retries,maintainParamOrder,allowFailureCallbackInProduction);
         var_3240[call] = call;
         call.observerNotificationTrigger = observerNotificationTrigger;
      }
      
      private static function getFbData() : Object
      {
         var _loc1_:Object = {};
         try
         {
            _loc1_ = GlobalProperties.socialNetworkData as Object;
            var _loc5_:* = 0;
            for(var _loc2_ in _loc1_)
            {
               if(_loc2_ != "fbid" && _loc2_ != "signed_request" && _loc2_ != "PHPSESSID" && _loc2_ != "flashsession")
               {
                  delete _loc1_[_loc2_];
               }
            }
         }
         catch(e:*)
         {
            _loc5_ = {};
            return _loc5_;
         }
         return _loc1_;
      }
   }
}
