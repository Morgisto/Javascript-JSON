package com.waterworld.managers.store.storeitem
{
   import com.waterworld.managers.limitedoffer.class_502;
   import com.waterworld.resources.BPResourceManager;
   import com.waterworld.utils.class_295;
   import package_59.class_120;
   import com.kixeye.utils.json.ActionJSON;
   import package_276.class_553;
   import com.waterworld.managers.store.STORE;
   
   public class LimitedOfferStoreItem extends StoreItem
   {
       
      private var var_3775:Array;
      
      private var var_808:class_502;
      
      public function LimitedOfferStoreItem(param1:String)
      {
         super(param1);
      }
      
      override public function get blockID() : int
      {
         return var_808.creditBlockId;
      }
      
      public function initToBuy(param1:class_502, param2:Array = null) : void
      {
         var_3775 = param2;
         var_808 = param1;
         var_87.Set(var_808.newPrice);
         var_2177 = true;
         setFBCWindowProps(BPResourceManager.getString("bp-flash","store_limitedofferstoreitem_title"),class_295.applyTemplateToKey("store_limitedofferstoreitem_message"),1,"LimitedOfferPopup");
      }
      
      override public function getAnalyticsData() : Object
      {
         var _loc1_:* = null;
         var _loc2_:Object = super.getAnalyticsData();
         if(var_3775)
         {
            _loc1_ = [];
            var _loc5_:* = 0;
            var _loc4_:* = var_3775;
            for each(var _loc3_ in var_3775)
            {
               _loc1_.push(_loc3_.toObject());
            }
            _loc2_.logging = ActionJSON.encodeJSON(_loc1_);
         }
         return _loc2_;
      }
      
      override public function apply(param1:Object) : String
      {
         super.apply(param1);
         return this.doApply();
      }
      
      override protected function doApply(param1:String = null) : String
      {
         var _loc4_:* = 0;
         var _loc3_:* = var_808.getValidRewards();
         for each(var _loc2_ in var_808.getValidRewards())
         {
            _loc2_.apply();
         }
         return "";
      }
      
      override public function get itemInfo() : Object
      {
         return var_808.exportToJSON();
      }
      
      override public function get externalCallback() : String
      {
         return "buyLimitedOfferCallback";
      }
      
      override public function buy(param1:Function = null) : void
      {
         super.buy(param1);
         STORE.purchaseNew(this);
      }
      
      override public function export() : Object
      {
         var _loc1_:Object = super.export();
         return _loc1_;
      }
   }
}
