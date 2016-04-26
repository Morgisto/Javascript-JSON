package com.waterworld.managers.store.storeitem
{
   import com.kixeye.logging.KXLogger;
   import com.kixeye.logging.class_72;
   import com.waterworld.resources.BPResourceManager;
   import com.kixeye.utils.json.ActionJSON;
   import com.waterworld.managers.store.STORE;
   import com.waterworld.core.GLOBAL;
   import com.waterworld.core.BASE;
   import com.kixeye.popups.IPopupBehavior;
   
   public class SendGiftsStoreItem extends StoreItem
   {
      
      protected static var _log:KXLogger = class_72.getLoggerForClass(SendGiftsStoreItem);
      
      {
         _log = class_72.getLoggerForClass(SendGiftsStoreItem);
      }
      
      private var var_409:String;
      
      private var var_1556:Array;
      
      private var var_4708:int;
      
      public function SendGiftsStoreItem(param1:String)
      {
         super(param1);
      }
      
      public function initToBuy(param1:String, param2:Array, param3:int, param4:int = -3) : void
      {
         var_409 = param1;
         var_1556 = param2;
         var_87.Set(param3);
         var_2177 = param1 == "cGold1" || param1 == "cGold2";
         var_4708 = param1 == "cGold1" || param1 == "cGold2"?param4:-3;
         setFBCWindowProps(BPResourceManager.getString("bp-flash","send_gifts_store_item_title"),BPResourceManager.getString("bp-flash","send_gifts_store_item_description"),1);
      }
      
      override public function getAnalyticsData() : Object
      {
         var _loc1_:Object = super.getAnalyticsData();
         var _loc2_:* = var_409;
         _loc1_.giftType = _loc2_;
         _loc1_.action = _loc2_;
         _loc1_.receivers = var_1556;
         _loc1_.description = {};
         _loc1_.description["targetusers"] = var_1556;
         _loc1_.description = ActionJSON.encodeJSON(_loc1_.description);
         return _loc1_;
      }
      
      override public function buy(param1:Function = null) : void
      {
         super.buy(param1);
         STORE.purchaseNew(this);
      }
      
      override public function apply(param1:Object) : String
      {
         super.apply(param1);
         var_409 = var_41.giftType;
         var_1556 = var_41.receivers;
         var_2177 = var_409 == "cGold1" || var_409 == "cGold2";
         return doApply();
      }
      
      override protected function doApply(param1:String = null) : String
      {
         currency = param1;
         if(null == currency)
         {
            var currency:String = "fbc";
         }
         var err:String = "";
         try
         {
            saved = function():void
            {
               if(var_409 != "cGold1" && var_409 != "cGold2")
               {
                  GLOBAL.const_11.onPurchaseComplete();
               }
            };
            GLOBAL.debugRequestToSave.push("SendGiftsStoreItem.doApply");
            BASE.save(0,true,saved);
         }
         catch(e:Error)
         {
            err = BPResourceManager.getString("bp-flash","send_gifts_store_item_base_save_failed");
         }
         return err;
      }
      
      override public function get blockID() : int
      {
         return var_409 == "cGold1" || var_409 == "cGold2"?var_4708:-2;
      }
      
      override public function export() : Object
      {
         var_41.giftType = var_409;
         var_41.receivers = var_1556;
         return super.export();
      }
      
      override protected function purchaseCompleteFunction(param1:IPopupBehavior) : void
      {
         if(var_409 == "cGold1" || var_409 == "cGold2")
         {
            GLOBAL.const_11.onPurchaseComplete();
            return;
         }
         super.purchaseCompleteFunction(param1);
      }
      
      override protected function get purchaseCompleteBodyMessage() : String
      {
         var _loc1_:* = null;
         if(var_409 == "cGold1" || var_409 == "cGold2")
         {
            _loc1_ = var_1556.length > 1?"send_gifts_purchase_complete_gold_gift_body":"send_gifts_purchase_complete_gold_gift_body_single";
            return BPResourceManager.getString("bp-flash",_loc1_,{"num_friends":var_1556.length});
         }
         return super.purchaseCompleteBodyMessage;
      }
   }
}
