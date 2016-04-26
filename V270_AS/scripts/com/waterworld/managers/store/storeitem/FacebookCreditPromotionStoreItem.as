package com.waterworld.managers.store.storeitem
{
   import com.waterworld.managers.store.STORE;
   import com.waterworld.resources.BPResourceManager;
   import com.waterworld.entities.BuildingFoundation;
   import package_10.BaseManager;
   import com.waterworld.entities.Outpost;
   import package_59.class_223;
   import com.waterworld.core.GlobalProperties;
   import com.waterworld.utils.class_295;
   import package_134.LargeMessageImagePopup;
   import com.waterworld.core.GLOBAL;
   import package_45.class_312;
   
   public class FacebookCreditPromotionStoreItem extends StoreItem
   {
      
      public static var var_3733:Boolean = false;
       
      public function FacebookCreditPromotionStoreItem(param1:String)
      {
         super(param1);
      }
      
      public function initToBuy() : void
      {
      }
      
      override public function buy(param1:Function = null) : void
      {
         super.buy(param1);
         STORE.purchaseNew(this);
      }
      
      override public function getAnalyticsData() : Object
      {
         var _loc1_:Object = super.getAnalyticsData();
         _loc1_.action = "creditpromotion";
         return _loc1_;
      }
      
      override public function apply(param1:Object) : String
      {
         super.apply(param1);
         return this.doApply();
      }
      
      override public function applyFree() : String
      {
         if(isFree)
         {
            return doApply();
         }
         return BPResourceManager.getString("bp-flash","store_facebookcreditpromotionitem_error_nonfree");
      }
      
      override public function get isFree() : Boolean
      {
         return var_57 == "NCP";
      }
      
      override protected function doApply(param1:String = null) : String
      {
         currency = param1;
         var error:String = "";
         if(var_3733)
         {
            if(null == currency)
            {
               var currency:String = "fbc";
            }
            var _loc4_:* = 0;
            var _loc3_:* = BaseManager.getInstance().buildings;
            for each(buildingFoundation in BaseManager.getInstance().buildings)
            {
               if(buildingFoundation is Outpost)
               {
                  buildingFoundation.upgraded();
                  break;
               }
            }
            class_223.logPurchaseFacebookPromotion(this.var_57);
            if(buildingFoundation && GlobalProperties.currency == "gold")
            {
               var messageText:String = class_295.applyTemplateToKey("ncp_message_message",{"level":buildingFoundation.level});
               new LargeMessageImagePopup(BPResourceManager.getString("bp-flash","ncp_message_title"),BPResourceManager.getString("bp-flash","ncp_message_title"),messageText,GLOBAL.assets.getURL("ncp_message_image"),BPResourceManager.getString("bp-flash","ncp_message_cta_label"),function():void
               {
                  class_312.const_7.showCurrencyPurchaseWindow();
               });
            }
            var_3733 = false;
         }
         else
         {
            error = "FacebookCreditPromoStoreItem not allowed";
         }
         return error;
      }
   }
}
