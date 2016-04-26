package com.waterworld.managers.store.storeitem
{
   import com.waterworld.core.BASE;
   import com.waterworld.resources.BPResourceManager;
   import com.waterworld.utils.class_295;
   import com.waterworld.utils.class_84;
   import com.waterworld.managers.store.STORE;
   
   public class BaseRepairAllBuildingsStoreItem extends StoreItem
   {
      
      private static const const_2759:String = "all";
       
      private var _time:int;
      
      private var var_739:Object;
      
      public function BaseRepairAllBuildingsStoreItem(param1:String)
      {
         super(param1);
      }
      
      public function initToBuy() : void
      {
         var_739 = BASE.repairSummary();
         var _loc1_:int = var_739.damaged + var_739.destroyed;
         _time = var_739.time;
         this.setFBCWindowProps(BPResourceManager.getString("bp-flash","store_baserepairstoreitem_title"),class_295.applyTemplateToKey("store_baserepairstoreitem_message",{
            "damage":_loc1_,
            "time":class_84.toTime(var_739.time)
         }),var_739.time,"BASE");
         this.var_87.Set(var_739.cost);
      }
      
      override public function getAnalyticsData() : Object
      {
         var _loc1_:Object = super.getAnalyticsData();
         _loc1_.action = "repairedall";
         _loc1_.speedup_seconds = _time;
         return _loc1_;
      }
      
      override public function apply(param1:Object) : String
      {
         super.apply(param1);
         return this.doApply();
      }
      
      override protected function doApply(param1:String = null) : String
      {
         var _loc2_:* = null;
         if(null == param1)
         {
            var param1:String = "fbc";
         }
         try
         {
            BASE.repairAllBuildings(true,var_739);
         }
         catch(e:Error)
         {
            _loc2_ = BPResourceManager.getString("bp-flash","store_baserepairstoreitem_error_couldnt");
         }
         return _loc2_;
      }
      
      override public function buy(param1:Function = null) : void
      {
         super.buy(param1);
         STORE.purchaseNew(this);
      }
      
      override public function export() : Object
      {
         var_41.type = "all";
         return super.export();
      }
   }
}
