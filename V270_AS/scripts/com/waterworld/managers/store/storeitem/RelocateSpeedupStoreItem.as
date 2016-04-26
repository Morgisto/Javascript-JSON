package com.waterworld.managers.store.storeitem
{
   import com.waterworld.managers.store.STORE;
   import package_174.MAPBASEPLACER;
   import com.waterworld.resources.BPResourceManager;
   import com.waterworld.core.GLOBAL;
   import com.waterworld.core.BASE;
   
   public class RelocateSpeedupStoreItem extends StoreItem
   {
       
      public var _quantity:int;
      
      public function RelocateSpeedupStoreItem(param1:String)
      {
         super(param1);
      }
      
      public function initToBuy() : void
      {
         var_87.Set(STORE.costForTime(MAPBASEPLACER.moveReadyTime));
         setFBCWindowProps(BPResourceManager.getString("bp-flash","store_relocatespeedupstoreitem_title"),BPResourceManager.getString("bp-flash","store_relocatespeedupstoreitem_description"),1,"Store");
         var_833 = true;
      }
      
      override public function getAnalyticsData() : Object
      {
         var _loc1_:Object = super.getAnalyticsData();
         _loc1_.action = "relocate_speedup";
         _loc1_["speedup_seconds"] = MAPBASEPLACER.moveReadyTime;
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
         return "";
      }
      
      override public function export() : Object
      {
         var_41.quantity = _quantity;
         return super.export();
      }
      
      override public function postGoldPurchase(param1:String = null) : String
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
               MAPBASEPLACER.lastMoved = 0;
               MAPBASEPLACER.var_4337 = true;
               MAPBASEPLACER.finalizePlacement();
            };
            GLOBAL.debugRequestToSave.push("RelocateSpeedupStoreItem.postGoldPurchase");
            BASE.save(0,true,saved);
         }
         catch(e:Error)
         {
            err = BPResourceManager.getString("bp-flash","store_resourcestoreitem_couldntfindbase");
         }
         return err;
      }
   }
}
