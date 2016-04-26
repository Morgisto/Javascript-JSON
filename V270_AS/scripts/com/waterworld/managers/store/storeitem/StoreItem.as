package com.waterworld.managers.store.storeitem
{
   import com.kixeye.logging.KXLogger;
   import com.kixeye.logging.class_72;
   import package_91.SecNum;
   import com.waterworld.managers.store.STORE;
   import com.waterworld.core.GLOBAL;
   import com.kixeye.utils.json.ActionJSON;
   import package_108.AbstractRemoteProcedureCall;
   import package_45.class_469;
   import com.waterworld.core.BASE;
   import com.kixeye.popups.IPopupBehavior;
   import com.waterworld.utils.class_295;
   import com.waterworld.resources.BPResourceManager;
   import package_23.OneButtonMessagePopup;
   import com.kixeye.popups.PopupManager;
   
   public class StoreItem extends Object
   {
      
      private static const const_2352:int = 1800;
      
      private static const const_1498:int = 2;
      
      private static var _log:KXLogger = class_72.getLoggerForClass(StoreItem);
      
      {
         _log = class_72.getLoggerForClass(StoreItem);
      }
      
      protected var var_18;
      
      protected var var_57:String;
      
      protected var var_87:SecNum;
      
      protected var var_41:Object;
      
      protected var var_2177:Boolean;
      
      public var var_833:Boolean = false;
      
      public var var_4345:String = "Placeholder Description";
      
      public var var_4150:String = "Placeholder Title";
      
      public var referrer:String = "Placeholder Referrer";
      
      protected var var_2831:Function = null;
      
      public function StoreItem(param1:String)
      {
         super();
         var_41 = {};
         var_87 = new SecNum();
         if(param1)
         {
            this.var_57 = param1;
         }
      }
      
      public function setFBCWindowProps(param1:String = null, param2:String = null, param3:int = 0, param4:String = null) : void
      {
         if(param1)
         {
            var_4150 = param1;
         }
         if(param2)
         {
            var_4345 = param2;
         }
         if(param4)
         {
            referrer = param4;
         }
      }
      
      public function get itemInfo() : Object
      {
         return {};
      }
      
      public function get externalCallback() : String
      {
         return "fbcBuyCreditsCallback";
      }
      
      public function get requireRealCurrency() : Boolean
      {
         return var_2177;
      }
      
      public function get isFree() : Boolean
      {
         return var_57 == "SP1";
      }
      
      public function buy(param1:Function = null) : void
      {
         var_2831 = param1;
      }
      
      public function get goldQuantity() : int
      {
         var _loc1_:Object = STORE.var_104[this.var_57];
         return this.var_87.Get() / _loc1_.unitCost;
      }
      
      public function getAnalyticsData() : Object
      {
         return {
            "user_level":GLOBAL.bTownhall.level,
            "description":"{}",
            "r1":0,
            "r2":0,
            "r3":0,
            "r4":0
         };
      }
      
      public function apply(param1:Object) : String
      {
         var_41 = param1.hasOwnProperty("iteminfo")?ActionJSON.decodeJSON(param1.iteminfo,"StoreItem.apply()"):param1.hasOwnProperty("itemInfo")?param1.itemInfo:{};
         var_18 = var_41.targetId;
         referrer = param1.referrer;
         var_87.Set(param1.cost);
         onApplyComplete();
         return "";
      }
      
      protected function onApplyComplete() : void
      {
         if(var_2831 != null)
         {
            var_2831.call();
            var_2831 = null;
         }
      }
      
      public function export() : Object
      {
         var_41.targetId = this.var_18;
         return {
            "storeCode":this.var_57,
            "itemInfo":ActionJSON.encodeJSON(this.var_41),
            "cost":this.var_87.Get(),
            "title":var_4150,
            "description":var_4345,
            "referrer":referrer
         };
      }
      
      public function exportHashed() : String
      {
         var _loc1_:* = null;
         var _loc2_:Object = export();
         _loc1_ = ActionJSON.encodeJSON(AbstractRemoteProcedureCall.getHashedObject("Y9U653YU641VUU3U1U6Z497075076655",[["storeCode",_loc2_.storeCode],["cost",_loc2_.cost],["itemInfo",_loc2_.itemInfo],["title",_loc2_.title],["description",_loc2_.description],["referrer",_loc2_.referrer]]));
         return _loc1_;
      }
      
      protected function doApply(param1:String = null) : String
      {
         if(null == param1)
         {
            var param1:String = "fbc";
         }
         var _loc2_:String = "";
         return _loc2_;
      }
      
      public function applyGold() : String
      {
         if(STORE.currencyForCost(this.cost) != "fbc")
         {
            onApplyComplete();
            return doApply("gold");
         }
         return "Error: can\'t complete this purchase using gold!";
      }
      
      public function applyFree() : String
      {
         return "NOT AVAILABLE FOR FREE!";
      }
      
      public function request() : class_469
      {
         var _loc1_:class_469 = new class_469();
         _loc1_.storeCode = var_57;
         _loc1_.cost = var_87.Get();
         _loc1_.var_6018 = BASE.credits;
         _loc1_.title = var_4150;
         _loc1_.var_5897 = var_4345;
         _loc1_.itemInfo = export();
         _loc1_.itemInfo.itemInfo = ActionJSON.decodeJSON(_loc1_.itemInfo.itemInfo,"StoreItem.request()");
         return _loc1_;
      }
      
      public function get cost() : int
      {
         return this.var_87.Get();
      }
      
      public function get storeCode() : String
      {
         return this.var_57;
      }
      
      public function get blockID() : int
      {
         return -3;
      }
      
      public function postGoldPurchase(param1:String = null) : String
      {
         return "";
      }
      
      protected function purchaseCompleteFunction(param1:IPopupBehavior) : void
      {
         param1.hide();
      }
      
      protected function get purchaseCompleteBodyMessage() : String
      {
         return class_295.applyTemplate(BPResourceManager.getString("bp-flash","currency_purchasecomplete_message"),{"gold":BASE.credits});
      }
      
      protected function validateCost(param1:int, param2:int, param3:int) : void
      {
         if(param1 < 2 && param2 > 1800 || param3 > 0 && param2 > 300)
         {
            _log.logRemote("ERROR.StoreItem.doApply.MIS_CALC","code:" + var_57 + " r:" + param3," t:" + param2,"c:" + param1);
         }
      }
      
      public function showPurchaseCompletePopup(param1:Boolean) : void
      {
         success = param1;
         var popup:OneButtonMessagePopup = new OneButtonMessagePopup(BPResourceManager.getString("bp-flash","currency_purchasecomplete_title"),purchaseCompleteBodyMessage,function():void
         {
            purchaseCompleteFunction(popup);
         },BPResourceManager.getString("bp-flash","currency_purchasecomplete_button"),[],PopupManager.getInstance().currentParentId);
      }
   }
}
