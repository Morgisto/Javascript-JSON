package com.waterworld.managers.store.storeitem
{
   import package_78.PERSONA;
   import com.waterworld.resources.BPResourceManager;
   import com.waterworld.managers.store.STORE;
   
   public class RenameStoreItem extends StoreItem
   {
       
      public function RenameStoreItem(param1:String)
      {
         super(param1);
      }
      
      public function initToBuy(param1:String) : void
      {
         var_87.Set(PERSONA.COST_FOR_CHANGE);
         var_18 = param1;
         setFBCWindowProps(BPResourceManager.getString("bp-flash","store_renamestoreitem_title"),BPResourceManager.getString("bp-flash","store_renamestoreitem_message"),cost,"PERSONA.BuyNameChange");
      }
      
      override public function getAnalyticsData() : Object
      {
         var _loc1_:Object = super.getAnalyticsData();
         _loc1_.action = "rename";
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
            PERSONA.buyNameChangeB([this.var_18]);
         }
         catch(e:Error)
         {
            _loc2_ = BPResourceManager.getString("bp-flash","store_renamestoreitem_error");
         }
         return _loc2_;
      }
      
      override public function buy(param1:Function = null) : void
      {
         super.buy(param1);
         STORE.purchaseNew(this);
      }
   }
}
