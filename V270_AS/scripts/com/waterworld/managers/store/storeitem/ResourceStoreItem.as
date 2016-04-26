package com.waterworld.managers.store.storeitem
{
   import com.waterworld.managers.store.STORE;
   import com.waterworld.resources.BPResourceManager;
   import com.waterworld.core.GLOBAL;
   import com.waterworld.core.BASE;
   
   public class ResourceStoreItem extends StoreItem
   {
       
      private var _quantity:Number;
      
      private var var_4142:int;
      
      public function ResourceStoreItem(param1:String)
      {
         super(param1);
      }
      
      public function initToBuy() : void
      {
         var _loc3_:Object = STORE.var_104[this.var_57];
         var_87.Set(_loc3_.cost[0]);
         _quantity = _loc3_.quantity;
         var _loc2_:int = this.var_57.charAt(3);
         var _loc1_:String = BPResourceManager.getString("bp-flash","store_resourcestoreitem_resourcequantity_" + _loc2_);
         var_4142 = this.var_57.charAt(2);
         var _loc4_:String = GLOBAL.getResourceName(var_4142);
         setFBCWindowProps(BPResourceManager.getString("bp-flash","store_resourcestoreitem_buyresources"),_loc1_ + _loc4_,_quantity,"Store");
         var_833 = true;
      }
      
      override public function getAnalyticsData() : Object
      {
         var _loc1_:Object = super.getAnalyticsData();
         _loc1_.action = "resources";
         _loc1_["r" + var_4142] = _quantity;
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
         _quantity = var_41.quantity;
         return doApply();
      }
      
      override protected function doApply(param1:String = null) : String
      {
         var _loc3_:* = 0;
         if(null == param1)
         {
            var param1:String = "fbc";
         }
         var _loc2_:String = "";
         try
         {
            _loc3_ = storeCode.charAt(2);
            BASE.fund(_loc3_,_quantity);
            BASE.pointsAdd(_quantity,"resource",{"source":"ResourceStoreItem.doApply._quantity"});
         }
         catch(e:Error)
         {
            _loc2_ = BPResourceManager.getString("bp-flash","store_resourcestoreitem_couldntfindbase");
         }
         return _loc2_;
      }
      
      override public function export() : Object
      {
         var_41.quantity = _quantity;
         return super.export();
      }
   }
}
