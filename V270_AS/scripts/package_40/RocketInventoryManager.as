package package_40
{
   import flash.events.EventDispatcher;
   import package_108.BattlePiratesJSONRemoteProcedureCall;
   import package_23.OneButtonMessagePopupWithClose;
   import com.kixeye.popups.IPopupBehavior;
   import com.kixeye.popups.PopupManager;
   import com.waterworld.resources.BPResourceManager;
   import com.waterworld.utils.ReturnStatus;
   import package_32.ComponentManager;
   import com.waterworld.datastores.IOShipComponent;
   import package_10.BaseManager;
   import com.waterworld.datastores.IOBuilding;
   import com.waterworld.core.GLOBAL;
   import package_97.RESEARCH;
   
   public class RocketInventoryManager extends EventDispatcher
   {
      
      public static const const_2526:String = "roomError";
      
      public static const const_1906:String = "levelError";
      
      public static const const_2193:String = "researchError";
       
      private var var_456:Vector.<class_301>;
      
      private var var_1861:Boolean = false;
      
      public function RocketInventoryManager()
      {
         super();
      }
      
      private static function showPopupForFailedServerCall(param1:BattlePiratesJSONRemoteProcedureCall) : void
      {
         response = param1;
         var currentPopup:IPopupBehavior = PopupManager.getInstance().currentPopup;
         var errorMessage:String = "";
         if(response.data)
         {
            errorMessage = response.data.error.toString();
         }
         else
         {
            errorMessage = response.error.text;
         }
         var popup:OneButtonMessagePopupWithClose = new OneButtonMessagePopupWithClose(BPResourceManager.getString("bp-flash","generic_popup_title"),errorMessage,function():void
         {
            popup.hide();
         },BPResourceManager.getString("bp-flash","generic_popup_ok"),null,currentPopup != null?currentPopup.id:-1);
      }
      
      public function init(param1:Function = null, param2:Function = null, param3:Boolean = true) : void
      {
         class_179.getCurrent(serverCallSuccess(param1),serverCallFailure(param2,param3));
      }
      
      public function canBuildRocket(param1:int) : ReturnStatus
      {
         var _loc2_:ReturnStatus = new ReturnStatus();
         var _loc3_:IOShipComponent = ComponentManager.getInstance().getComponent(param1);
         var _loc4_:IOBuilding = BaseManager.getInstance().getBuilding(73);
         if(GLOBAL.bRocketPad == null)
         {
            _loc2_.setError("roomError","rocketpad_needprop_message",{"props":_loc4_.name});
         }
         else if(GLOBAL.bRocketPad.capacity < var_456.length)
         {
            _loc2_.setError("roomError","rocketpad_noroom_message");
         }
         else if(GLOBAL.bRocketPad.level < _loc3_.padLevel)
         {
            _loc2_.setError("levelError","rocketpad_needupgrade_message",{
               "level":_loc3_.padLevel,
               "props":_loc4_.name
            });
         }
         else if(!RESEARCH.isResearched(param1))
         {
            _loc2_.setError("researchError","rocketpad_needresearch_message");
         }
         return _loc2_;
      }
      
      public function getCurrent(param1:Function = null, param2:Function = null, param3:Boolean = false) : void
      {
         class_179.getCurrent(serverCallSuccess(param1),serverCallFailure(param2,param3));
      }
      
      public function scrapRocket(param1:int, param2:Function = null, param3:Function = null, param4:Boolean = false) : void
      {
         class_179.scrap(param1,serverCallSuccess(param2),serverCallFailure(param3,param4));
      }
      
      public function buildRocket(param1:int, param2:Number, param3:Function = null, param4:Function = null, param5:Boolean = false) : void
      {
         var _loc6_:IOShipComponent = ComponentManager.getInstance().getComponent(param1);
         if(!_loc6_)
         {
            return;
         }
         class_179.build(param1,param2,serverCallSuccess(param3),serverCallFailure(param4,param5));
      }
      
      public function buildRocketInstant(param1:int, param2:Number, param3:int, param4:Function = null, param5:Function = null, param6:Boolean = false) : void
      {
         var _loc7_:IOShipComponent = ComponentManager.getInstance().getComponent(param1);
         if(!_loc7_)
         {
            return;
         }
         class_179.buildInstant(param1,param2,param3,serverCallSuccess(param4),serverCallFailure(param5,param6));
      }
      
      public function speedupRocketBuild(param1:int, param2:int, param3:int, param4:Function = null, param5:Function = null, param6:Boolean = false) : void
      {
         class_179.speedup(param1,param2,param3,serverCallSuccess(param4),serverCallFailure(param5,param6));
      }
      
      public function updateRocket(param1:int, param2:Number, param3:Function = null, param4:Function = null, param5:Boolean = false) : void
      {
         class_179.update(param1,param2,serverCallSuccess(param3),serverCallFailure(param4,param5));
      }
      
      public function prepareRocket(param1:int, param2:Function = null, param3:Function = null, param4:Boolean = false) : void
      {
         class_179.prepare(param1,serverCallSuccess(param2),serverCallFailure(param3,param4));
      }
      
      public function unprepareRocket(param1:int, param2:Function = null, param3:Function = null, param4:Boolean = false) : void
      {
         class_179.unprepare(param1,serverCallSuccess(param2),serverCallFailure(param3,param4));
      }
      
      private function updateFromData(param1:Vector.<class_225>) : void
      {
         var _loc2_:* = null;
         var_456 = new Vector.<class_301>();
         var _loc5_:* = 0;
         var _loc4_:* = param1;
         for each(var _loc3_ in param1)
         {
            _loc2_ = new class_301().init(_loc3_);
            var_456.push(_loc2_);
         }
         var_1861 = true;
      }
      
      private function serverCallSuccess(param1:Function = null) : Function
      {
         callback = param1;
         var thisRocketMan:RocketInventoryManager = this;
         return function(param1:Vector.<class_225>):void
         {
            updateFromData(param1);
            if(callback != null)
            {
               callback.length?callback(thisRocketMan):callback();
            }
            dispatchEvent(new RocketInventoryUpdateEvent("updated"));
         };
      }
      
      private function serverCallFailure(param1:Function = null, param2:Boolean = true) : Function
      {
         callback = param1;
         showFailurePopup = param2;
         return function(param1:BattlePiratesJSONRemoteProcedureCall):void
         {
            var _loc5_:* = null;
            var _loc2_:* = undefined;
            var _loc3_:* = null;
            if(showFailurePopup)
            {
               showPopupForFailedServerCall(param1);
            }
            if(param1.data.data != null)
            {
               _loc5_ = param1.data.data?param1.data.data:null;
               _loc2_ = new Vector.<class_225>();
               var _loc7_:* = 0;
               var _loc6_:* = _loc5_;
               for each(var _loc4_ in _loc5_)
               {
                  _loc3_ = new class_225();
                  _loc3_.init(_loc4_);
                  _loc2_.push(_loc3_);
               }
               updateFromData(_loc2_);
            }
            if(callback != null)
            {
               callback.length?callback(param1):callback();
            }
         };
      }
      
      public function getRocket(param1:int) : class_301
      {
         var _loc4_:* = 0;
         var _loc3_:* = var_456;
         for each(var _loc2_ in var_456)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getCurrentRocket() : class_301
      {
         var _loc3_:* = 0;
         var _loc2_:* = var_456;
         for each(var _loc1_ in var_456)
         {
            if(_loc1_.ready)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public function getBuildingRocket() : class_301
      {
         var _loc3_:* = 0;
         var _loc2_:* = var_456;
         for each(var _loc1_ in var_456)
         {
            if(!_loc1_.isComplete)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public function getLastBuiltRocket() : class_301
      {
         var _loc1_:class_301 = var_456.length?var_456[0]:null;
         var _loc4_:* = 0;
         var _loc3_:* = var_456;
         for each(var _loc2_ in var_456)
         {
            if(_loc1_.completeTime < _loc2_.completeTime)
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function getUniqueRocket(param1:int) : class_301
      {
         var _loc3_:* = null;
         var _loc4_:* = 0;
         var _loc2_:int = var_456.length;
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = var_456[_loc4_];
            if(_loc3_ && _loc3_.itemCode == param1)
            {
               return _loc3_;
            }
            _loc4_++;
         }
         return null;
      }
      
      public function getNumRocketsOfType(param1:int) : int
      {
         var _loc4_:* = null;
         var _loc3_:* = 0;
         var _loc5_:* = 0;
         var _loc2_:int = var_456.length;
         _loc5_ = 0;
         while(_loc5_ < _loc2_)
         {
            _loc4_ = var_456[_loc5_];
            if(_loc4_ && _loc4_.itemCode == param1)
            {
               _loc3_++;
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      public function get rocketInventory() : Vector.<class_301>
      {
         return var_456;
      }
      
      public function get numRockets() : int
      {
         return var_456.length;
      }
      
      public function get capacity() : int
      {
         return GLOBAL.bRocketPad?GLOBAL.bRocketPad.capacity:0;
      }
      
      public function get initialized() : Boolean
      {
         return var_1861;
      }
   }
}
