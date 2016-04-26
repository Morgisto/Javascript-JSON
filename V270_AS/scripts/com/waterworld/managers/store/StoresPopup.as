package com.waterworld.managers.store
{
   import com.waterworld.managers.popups.AbstractPopup;
   import com.kixeye.popups.IPopupBehavior;
   import com.kixeye.logging.KXLogger;
   import com.kixeye.logging.class_72;
   import com.waterworld.ui.Scroller;
   import com.waterworld.entities.BuildingFoundation;
   import package_287.class_587;
   import package_23.ZeroButtonMessagePopup;
   import package_129.class_227;
   import package_93.RogueCrewPackVO;
   import package_93.RogueCrewPackPurchaseVO;
   import flash.display.MovieClip;
   import com.waterworld.core.GLOBAL;
   import com.waterworld.utils.movieclip.class_277;
   import com.waterworld.resources.BPResourceManager;
   import flash.display.Sprite;
   import com.waterworld.managers.merccaptains.MercCaptainsManager;
   import com.waterworld.managers.merccaptains.RogueCrewsOverviewPopup;
   import com.waterworld.display.ButtonManager;
   import package_287.RogueCrewPackButton;
   import package_287.RogueCrewStandardButton;
   import package_23.TwoButtonMessagePopup;
   import com.waterworld.core.BASE;
   import package_45.class_312;
   import package_45.class_511;
   import package_10.BaseManager;
   import package_237.GoldCurrencyEvent;
   import package_10.BaseManagerEvent;
   import package_108.BattlePiratesJSONRemoteProcedureCall;
   import package_23.OneButtonMessagePopup;
   import package_91.class_176;
   import com.waterworld.managers.merccaptains.MercCaptainConfirmPopup;
   import package_300.MercCaptainEvent;
   import package_23.OneButtonMessagePopupWithClose;
   import package_166.OfficerSelectionPopup;
   import com.waterworld.managers.store.storeitem.StoreItem;
   import com.waterworld.managers.store.storeitem.TokenUseStoreItem;
   import com.waterworld.core.PurchaseManager;
   import package_136.TokenTransactionRequest;
   import com.waterworld.utils.Delegate;
   import package_292.CurrencyTransactionCommand;
   import com.waterworld.managers.currency.CurrencyDataManager;
   import package_151.TokenVO;
   import package_43.Player;
   import flash.events.MouseEvent;
   import package_294.LimitedOfferTrigger;
   import com.waterworld.managers.limitedoffer.class_494;
   import com.waterworld.core.GlobalProperties;
   import com.waterworld.utils.class_295;
   import com.waterworld.utils.class_84;
   import com.waterworld.entities.ShipYard;
   import com.waterworld.entities.BuildingGenericResearch;
   import package_97.RESEARCH;
   import com.waterworld.datastores.class_118;
   import com.waterworld.entities.ShipDock;
   import com.waterworld.entities.RocketLaunchPad;
   import com.waterworld.entities.DefensivePlatform;
   import package_96.class_182;
   import com.waterworld.datastores.IOFleet;
   
   public class StoresPopup extends AbstractPopup implements IPopupBehavior
   {
      
      private static const const_2044:String = "modalClose";
      
      private static const const_18:String = "AssetStorePopup_V3";
      
      private static const STORES_ASSET_ID:String = "popupsStore";
      
      private static const const_4474:int = 120;
      
      private static var _log:KXLogger = class_72.getLoggerForClass(StoresPopup);
      
      {
         _log = class_72.getLoggerForClass(StoresPopup);
      }
      
      private var var_1806:Array;
      
      private var _category:String;
      
      private var var_1614:Vector.<CategoryButton>;
      
      private var var_3347:Vector.<StoreItemDisplay>;
      
      private var var_3115:Vector.<TokenItemDisplay>;
      
      private var var_254:Scroller;
      
      private var var_5265:Boolean = false;
      
      private var var_5374:BuildingFoundation;
      
      private var var_3457:Boolean = false;
      
      private var var_3176:Vector.<class_587>;
      
      private var var_519:ZeroButtonMessagePopup;
      
      private var var_3379:Vector.<class_227>;
      
      private var var_893:RogueCrewPackVO;
      
      private var var_1344:RogueCrewPackPurchaseVO;
      
      private var var_4370:MovieClip;
      
      private var var_4841:Boolean = false;
      
      public function StoresPopup(param1:int = -1, param2:Array = null, param3:String = null)
      {
         init(param2,param3);
         super("AssetStorePopup_V3",param1,null,null,"popupsStore");
      }
      
      private function init(param1:Array, param2:String) : void
      {
         var_1806 = param1;
         var_3347 = new Vector.<StoreItemDisplay>();
         var_3115 = new Vector.<TokenItemDisplay>();
         var_5374 = GLOBAL.selectedBuilding;
         if(param2 != null)
         {
            _category = param2;
            var_4841 = true;
         }
      }
      
      override protected function initialize() : void
      {
         var_1614 = new Vector.<CategoryButton>();
         var _loc3_:* = 0;
         var _loc2_:* = StoreManager.const_380;
         for each(var _loc1_ in StoreManager.const_380)
         {
            if(_category == null)
            {
               _category = _loc1_;
            }
            var_1614.push(new CategoryButton(_popup,_loc1_,switchCategory));
         }
         class_277.setTextOn(_popup,["mcOuterWindow","mcFrame","mcWindowHeader","tWindowHeader"],BPResourceManager.getString("bp-flash","ui_store_popup_headline"));
         setupList();
         if(var_4841)
         {
            refreshCategory();
         }
         centerPopup();
      }
      
      protected function setupList() : void
      {
         var _loc2_:MovieClip = class_277.getMovieClip(_popup,["listEntry"]);
         var _loc3_:Sprite = new Sprite();
         _loc3_.x = _loc2_.x;
         _loc3_.y = _loc2_.y;
         _loc3_.graphics.beginFill(16777215);
         _loc3_.graphics.drawRect(0,0,_loc2_.width,_loc2_.height);
         _loc3_.graphics.endFill();
         _popup.addChild(_loc3_);
         _loc2_.mask = _loc3_;
         var _loc1_:MovieClip = class_277.getMovieClip(_popup,["Scroll"]);
         var_254 = new Scroller(_loc2_,_loc3_,_loc1_);
      }
      
      private function switchCategory(param1:String) : void
      {
         if(var_3457)
         {
            return;
         }
         clearAllItems();
         STORE.initStoreItems();
         _category = param1;
         class_277.setTextOn(_popup,["tContentHeader"],BPResourceManager.getString("bp-flash","store_popup_button_" + _category));
         var _loc5_:* = 0;
         var _loc4_:* = var_1614;
         for each(var _loc2_ in var_1614)
         {
            _loc2_.checkSelected(_category);
         }
         if(_category == "roguecrews")
         {
            var _loc7_:* = 0;
            var _loc6_:* = var_3176;
            for each(var _loc3_ in var_3176)
            {
               _loc3_.destroy();
            }
            var_3457 = true;
            MercCaptainsManager.getInstance().getPacks(onRogueCrewPacksData);
         }
         else
         {
            updateAndResetScroll();
         }
      }
      
      private function onRogueCrewsOverviewClick() : void
      {
      }
      
      private function onRogueCrewPacksData(param1:Object, param2:int) : void
      {
         var _loc7_:* = null;
         var _loc4_:* = null;
         var _loc9_:* = NaN;
         var _loc8_:* = null;
         var _loc5_:* = null;
         var _loc3_:MovieClip = class_277.getMovieClip(_popup,["listEntry"]);
         if(_loc3_)
         {
            _loc7_ = GLOBAL.assets.getClass("popupsStore","AssetRogueCrewItem_Description");
            _loc4_ = new _loc7_() as MovieClip;
            class_277.setTextOn(_loc4_,["tText"],BPResourceManager.getString("bp-flash","rogue_crew_overview"));
            var_4370 = class_277.getMovieClip(_loc4_,["btnOverview"]);
            ButtonManager.attach(var_4370,onRogueCrewsOverviewClick);
            _loc3_.addChild(_loc4_);
            _loc9_ = _loc4_.height;
            var _loc11_:* = 0;
            var _loc10_:* = param1;
            for each(var _loc6_ in param1)
            {
               _loc8_ = new RogueCrewPackVO(_loc6_);
               if(_loc6_.quantity > 1)
               {
                  _loc5_ = new RogueCrewPackButton(_loc8_,purchaseRogueCrewPack);
               }
               else
               {
                  _loc5_ = new RogueCrewStandardButton(_loc8_,purchaseRogueCrewPack);
               }
               var_3176.push(_loc5_);
               _loc5_.asset.y = _loc9_;
               _loc9_ = _loc9_ + _loc5_.asset.height;
               _loc3_.addChild(_loc5_.asset);
            }
         }
         var_254.evaluateScroll();
         var_254.jumpToTop();
         var_3457 = false;
      }
      
      private function purchaseRogueCrewPack(param1:RogueCrewPackVO) : void
      {
         var_893 = param1;
         if(var_893.isFree)
         {
            onPurchaseRogueCrewPackConfirm();
            return;
         }
         var _loc5_:String = var_893.crews.length == 1?"_singular":"_plural";
         var _loc4_:String = var_893.currencyType == "gold"?"_gold":"_uranium";
         var _loc3_:String = BPResourceManager.getString("bp-flash","rogue_crew_confirm_purchase_title" + _loc5_);
         var _loc2_:String = BPResourceManager.getString("bp-flash","rogue_crew_confirm_purchase_message" + _loc4_ + _loc5_,{"currencyAmount":var_893.currencyAmount});
         return;
         §§push(new TwoButtonMessagePopup(_loc3_,_loc2_,onPurchaseRogueCrewPackConfirm,BPResourceManager.getString("bp-flash","generic_popup_yes"),null,null,BPResourceManager.getString("bp-flash","generic_popup_no"),null,id));
      }
      
      private function onPurchaseRogueCrewPackConfirm() : void
      {
         var _loc1_:* = null;
         var_519 = new ZeroButtonMessagePopup(BPResourceManager.getString("bp-flash","generic_please_wait"),BPResourceManager.getString("bp-flash","rogue_crew_searching"),id);
         if(var_893.currencyType == "gold" && var_893.currencyAmount > BASE.credits)
         {
            _loc1_ = class_312.const_7 as class_511;
            if(!_loc1_)
            {
               GLOBAL.var_3.topLeft.onAddCredits();
            }
            else
            {
               addRogueCrewGoldTopoffListeners();
               _loc1_.showGoldAmountTopoff(var_893.currencyAmount);
            }
         }
         else
         {
            MercCaptainsManager.getInstance().purchasePack(var_893.packID,onPurchasePackSuccess,onPurchasePackFailure);
         }
      }
      
      private function addRogueCrewGoldTopoffListeners() : void
      {
         var _loc1_:class_511 = class_312.const_7 as class_511;
         _loc1_.addEventListener("Gold Purchase Cancelled",onRogueCrewGoldTopoffCancelled);
         BaseManager.getInstance().addEventListener("base_credits_changed",onRogueCrewGoldTopoffSucceeded);
      }
      
      private function removeRogueCrewGoldTopoffListeners() : void
      {
         var _loc1_:class_511 = class_312.const_7 as class_511;
         _loc1_.removeEventListener("Gold Purchase Cancelled",onRogueCrewGoldTopoffCancelled);
         BaseManager.getInstance().removeEventListener("base_credits_changed",onRogueCrewGoldTopoffSucceeded);
      }
      
      private function onRogueCrewGoldTopoffCancelled(param1:GoldCurrencyEvent) : void
      {
         var_519.hide();
         removeRogueCrewGoldTopoffListeners();
      }
      
      private function onRogueCrewGoldTopoffSucceeded(param1:BaseManagerEvent) : void
      {
         var_519.hide();
         removeRogueCrewGoldTopoffListeners();
         purchaseRogueCrewPack(var_893);
      }
      
      private function onPurchasePackFailure(param1:BattlePiratesJSONRemoteProcedureCall) : void
      {
         var_519.hide();
         if(param1.isError && param1.data && param1.data.hasOwnProperty("error"))
         {
            hide();
            MercCaptainsManager.getInstance().handleError(param1.data.error.toString(),param1.data.error_code.toString());
         }
         else
         {
            new OneButtonMessagePopup(BPResourceManager.getString("bp-flash","merc_captain_recruit_title"),BPResourceManager.getString("bp-flash","unignorepopup_error_message"),null,BPResourceManager.getString("bp-flash","generic_popup_ok"),null,id);
         }
      }
      
      private function onPurchasePackSuccess(param1:BattlePiratesJSONRemoteProcedureCall) : void
      {
         response = param1;
         var purchaseData:Object = response.data.purchase;
         var crewIds:Array = purchaseData.crewIds as Array;
         var_1344 = new RogueCrewPackPurchaseVO(purchaseData);
         var_3379 = new Vector.<class_227>();
         var allCapts:Vector.<class_227> = MercCaptainsManager.getInstance().getCaptainVOs();
         var _loc6_:* = 0;
         var _loc5_:* = crewIds;
         for each(capID in crewIds)
         {
            var _loc4_:* = 0;
            var _loc3_:* = allCapts;
            for each(captVO in allCapts)
            {
               if(captVO.captainid == capID.toString())
               {
                  var_3379.push(captVO);
                  var lastRolledCaptain:class_227 = captVO;
                  break;
               }
            }
         }
         var dummyCrewIDPool:Vector.<String> = var_893.crews;
         var copyDummyCrewIDPool:Vector.<String> = dummyCrewIDPool.concat();
         var dummyCaptainVOs:Vector.<class_227> = new Vector.<class_227>();
         while(dummyCaptainVOs.length < 120)
         {
            if(copyDummyCrewIDPool.length == 0)
            {
               copyDummyCrewIDPool = dummyCrewIDPool.concat();
            }
            var crewIDIndex:int = class_176.randRange(0,copyDummyCrewIDPool.length - 1);
            var crewID:String = copyDummyCrewIDPool[crewIDIndex];
            copyDummyCrewIDPool.splice(crewIDIndex,1);
            var mercenaryCaptainVO:class_227 = MercCaptainsManager.getInstance().getCaptainVOByCaptainId(crewID);
            dummyCaptainVOs.push(mercenaryCaptainVO);
         }
         var imageIDs:Vector.<String> = new Vector.<String>();
         var _loc8_:* = 0;
         var _loc7_:* = dummyCaptainVOs;
         for each(captainVO in dummyCaptainVOs)
         {
            imageIDs.push(captainVO.getCaptainImageKey());
         }
         var _loc10_:* = 0;
         var _loc9_:* = var_3379;
         for each(captainVO in var_3379)
         {
            imageIDs.push(captainVO.getCaptainImageKey());
         }
         GLOBAL.assets.getBatchAsync(imageIDs,function():void
         {
            var_519.hide();
            var_519 = null;
            var _loc1_:MercCaptainConfirmPopup = new MercCaptainConfirmPopup(var_3379,dummyCaptainVOs,var_1344,id);
            _loc1_.addEventListener("Accept Crews",onAcceptCrews);
            _loc1_.addEventListener("ReRoll",onReRollCrews);
         });
      }
      
      private function onAcceptCrews(param1:MercCaptainEvent) : void
      {
         var _loc2_:MercCaptainConfirmPopup = param1.target as MercCaptainConfirmPopup;
         _loc2_.removeEventListener("Accept Crews",onAcceptCrews);
         _loc2_.removeEventListener("ReRoll",onReRollCrews);
         _loc2_.hide();
         var_519 = new ZeroButtonMessagePopup(BPResourceManager.getString("bp-flash","generic_please_wait"),BPResourceManager.getString("bp-flash","rogue_crew_accepting"),id);
         MercCaptainsManager.getInstance().acceptPack(var_1344.transactionID,onAcceptPackSuccess,onAcceptPackFailure);
      }
      
      private function onReRollCrews(param1:MercCaptainEvent) : void
      {
         var _loc2_:MercCaptainConfirmPopup = param1.target as MercCaptainConfirmPopup;
         _loc2_.removeEventListener("Accept Crews",onAcceptCrews);
         _loc2_.removeEventListener("ReRoll",onReRollCrews);
         _loc2_.hide();
         var_519 = new ZeroButtonMessagePopup(BPResourceManager.getString("bp-flash","generic_please_wait"),BPResourceManager.getString("bp-flash","rogue_crew_searching"),id);
         reRollPack(var_1344);
      }
      
      private function reRollPack(param1:RogueCrewPackPurchaseVO) : void
      {
         var _loc2_:* = null;
         if(param1.reRollCurrencyType == "gold" && param1.reRollCurrencyAmount > BASE.credits)
         {
            _loc2_ = class_312.const_7 as class_511;
            if(!_loc2_)
            {
               GLOBAL.var_3.topLeft.onAddCredits();
            }
            else
            {
               var_1344 = param1;
               addRogueCrewGoldTopoffListeners();
               _loc2_.showGoldAmountTopoff(param1.reRollCurrencyAmount);
            }
         }
         else
         {
            MercCaptainsManager.getInstance().reRollPack(var_1344.transactionID,onPurchasePackSuccess,onPurchasePackFailure);
         }
      }
      
      private function removeRogueCrewGoldReRollTopoffListeners() : void
      {
         var _loc1_:class_511 = class_312.const_7 as class_511;
         _loc1_.removeEventListener("Gold Purchase Cancelled",onRogueCrewGoldReRollTopoffCancelled);
         BaseManager.getInstance().removeEventListener("base_credits_changed",onRogueCrewGoldReRollTopoffSucceeded);
      }
      
      private function onRogueCrewGoldReRollTopoffCancelled(param1:GoldCurrencyEvent) : void
      {
         var_519.hide();
         removeRogueCrewGoldReRollTopoffListeners();
      }
      
      private function onRogueCrewGoldReRollTopoffSucceeded(param1:BaseManagerEvent) : void
      {
         var_519.hide();
         removeRogueCrewGoldReRollTopoffListeners();
         reRollPack(var_1344);
      }
      
      private function onAcceptPackSuccess(param1:BattlePiratesJSONRemoteProcedureCall) : void
      {
         response = param1;
         MercCaptainsManager.getInstance().loadPlayerCaptainData(function():void
         {
            var_519.hide();
            hide();
         });
      }
      
      private function onAcceptPackFailure(param1:BattlePiratesJSONRemoteProcedureCall) : void
      {
         new OneButtonMessagePopup(BPResourceManager.getString("bp-flash","rogue_crew_pack_accept_error_title"),BPResourceManager.getString("bp-flash","rogue_crew_pack_accept_error_message"),null,BPResourceManager.getString("bp-flash","generic_popup_ok"));
         var _loc2_:String = param1.data?param1.data.toString():"Not found in response";
         _log.logRemote("ERROR.StoresPopup.onAcceptPackFailure","Full JSON: ",_loc2_);
      }
      
      private function onClickBuyItem(param1:String, param2:*, param3:Object = null, param4:Function = null) : void
      {
         var _loc5_:StoreItem = StoreManager.getInstance().getBuyableStoreItem(param3.itemcode,var_1806);
         STORE.hide();
         _loc5_.buy(param4);
      }
      
      private function onClickUseToken(param1:String, param2:*, param3:Object = null, param4:Function = null) : void
      {
         var _loc5_:TokenUseStoreItem = new TokenUseStoreItem(param3.token,param3.itemCode);
         _loc5_.initToUse(var_5374,var_1806);
         _loc5_.apply(null);
         _loc5_.buy(param4);
         tokenUseCleanup();
      }
      
      private function onTokenUse(param1:String, param2:*, param3:Object = null) : void
      {
         var _loc4_:* = null;
         var _loc6_:* = null;
         var _loc5_:* = null;
         if(PurchaseManager.tokenPurchaseEnabled)
         {
            PurchaseManager.tokenPurchaseEnabled = false;
            ButtonManager.setEnabled(param2,false,true);
            _loc4_ = new TokenTransactionRequest(param3.token,param3.log);
            _loc6_ = Delegate.create(onClickUseToken,param1,param2,param3);
            _loc5_ = new CurrencyTransactionCommand(_loc4_,_loc6_,id,null,tokenUseCleanup);
            _loc5_.execute();
         }
      }
      
      private function tokenUseCleanup() : void
      {
         PurchaseManager.tokenPurchaseEnabled = true;
         STORE.hide();
         BASE.save(0,true);
      }
      
      private function updateAndResetScroll() : void
      {
         update();
         var_254.evaluateScroll();
         var_254.jumpToTop();
      }
      
      private function clearAllItems() : void
      {
         var _loc1_:MovieClip = class_277.getMovieClip(_popup,["listEntry"]);
         if(_loc1_)
         {
            _loc1_.removeChildren();
         }
         var _loc4_:* = 0;
         var _loc3_:* = var_3176;
         for each(var _loc2_ in var_3176)
         {
            _loc2_.destroy();
         }
         var_3176 = new Vector.<class_587>();
      }
      
      public function update() : void
      {
         var _loc17_:* = NaN;
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         var _loc18_:* = null;
         var _loc11_:* = null;
         var _loc4_:* = undefined;
         var _loc16_:* = 0;
         var _loc3_:* = 0;
         var _loc19_:* = 0;
         var _loc12_:* = null;
         var _loc10_:* = 0;
         var _loc14_:* = null;
         var _loc5_:* = null;
         var _loc6_:* = false;
         var _loc1_:* = null;
         var _loc13_:* = null;
         var _loc7_:* = null;
         var _loc15_:Array = StoreManager.getInstance().storeGroupings[_category];
         var _loc2_:MovieClip = class_277.getMovieClip(_popup,["listEntry"]);
         if(_loc15_ != null && _loc2_ != null)
         {
            _loc17_ = 0.0;
            _loc8_ = _loc15_.length;
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               _loc18_ = _loc15_[_loc9_];
               if(_loc18_ == "SPT")
               {
                  if(!(!GLOBAL.selectedBuilding || !GLOBAL.isEnabled("ft_build_repair_tokens")))
                  {
                     _loc11_ = CurrencyDataManager.getInstance().getTokenTypeByBuilding(GLOBAL.selectedBuilding);
                     _loc4_ = CurrencyDataManager.getInstance().getTokensByTag(_loc11_);
                     _loc16_ = _loc4_.length;
                     _loc3_ = 0;
                     _loc19_ = 0;
                     while(_loc19_ < _loc16_)
                     {
                        _loc12_ = _loc4_[_loc19_];
                        _loc10_ = Player.getInstance().getCurrencyBalance(_loc12_);
                        if(_loc10_ > 0 && _loc12_)
                        {
                           if(_loc3_ < var_3115.length)
                           {
                              _loc14_ = var_3115[_loc3_];
                           }
                           else
                           {
                              _loc14_ = new TokenItemDisplay();
                              var_3115.push(_loc14_);
                           }
                           _loc3_++;
                           _loc5_ = getTokenLog();
                           _loc6_ = PurchaseManager.tokenPurchaseEnabled && !BASE.isSaving;
                           _loc14_.setToken(_loc12_,0,_loc17_,_loc6_,onTokenUse,_loc5_);
                           _loc17_ = _loc17_ + _loc14_.height;
                           _loc14_.attachTo(_loc2_);
                        }
                        _loc19_++;
                     }
                  }
               }
               else
               {
                  if(_loc9_ < var_3347.length)
                  {
                     _loc1_ = var_3347[_loc9_];
                  }
                  else
                  {
                     _loc1_ = new StoreItemDisplay();
                     var_3347.push(_loc1_);
                  }
                  _loc13_ = getUpdateProps(_loc18_);
                  _loc7_ = onClickBuyItem;
                  if(StoreManager.isSpeedup(_loc18_))
                  {
                     _loc7_ = onSpeedupButtonClick;
                  }
                  _loc1_.setStoreItem(_loc18_,_loc13_,0,_loc17_,_loc7_);
                  _loc17_ = _loc17_ + _loc1_.height;
                  _loc1_.attachTo(_loc2_);
               }
               _loc9_++;
            }
         }
      }
      
      private function onSpeedupButtonClick(param1:String, param2:*, param3:Object = null, param4:Function = null) : void
      {
         var_5265 = true;
         onClickBuyItem(param1,param2,param3,param4);
      }
      
      override protected function closeClickHandler(param1:MouseEvent) : void
      {
         if(!var_5265)
         {
            sendSpeedupAbandonedTrigger();
         }
         super.closeClickHandler(param1);
      }
      
      protected function sendSpeedupAbandonedTrigger() : void
      {
         var _loc1_:LimitedOfferTrigger = new LimitedOfferTrigger("modalClose");
         _loc1_.addDetail("time_elapsed",getPopupOpenDuration());
         _loc1_.addDetail("modal","speedup");
         class_494.sendTrigger(_loc1_);
      }
      
      private function getUpdateProps(param1:String) : class_672
      {
         var _loc24_:* = 0;
         var _loc10_:* = 0;
         var _loc23_:* = null;
         var _loc25_:* = null;
         var _loc27_:* = null;
         var _loc11_:* = null;
         var _loc18_:* = null;
         var _loc28_:* = null;
         var _loc3_:* = null;
         var _loc16_:* = null;
         var _loc19_:* = null;
         var _loc9_:* = null;
         var _loc8_:* = null;
         var _loc6_:* = null;
         var _loc15_:* = null;
         var _loc7_:* = null;
         var _loc14_:* = null;
         var _loc26_:* = null;
         var _loc13_:* = 0;
         var _loc17_:* = null;
         var _loc30_:Object = STORE.var_104[param1];
         var _loc5_:Object = STORE.var_146[param1];
         var _loc29_:BuildingFoundation = GLOBAL.selectedBuilding;
         var _loc2_:class_672 = new class_672();
         _loc2_.title = "";
         _loc2_.body = _loc30_.description;
         _loc2_.alpha = 1;
         if(GlobalProperties.currency == "fbc")
         {
            if(BASE.credits >= _loc30_.cost[0])
            {
               _loc2_.currency = "gold";
            }
            else
            {
               _loc2_.currency = GlobalProperties.currency;
            }
         }
         else
         {
            _loc2_.currency = GlobalProperties.currency;
         }
         var _loc12_:* = 0;
         var _loc4_:* = false;
         var _loc22_:* = false;
         if(BASE.credits == 0 && GlobalProperties.currency == "fbc")
         {
            _loc22_ = true;
         }
         if(param1.substr(0,2) == "SP")
         {
            if(_loc29_ != null)
            {
               _loc12_ = _loc29_.upgradeTimeRemaining + _loc29_.upgradeFortificationTimeRemaining + _loc29_.buildTimeRemaining + _loc29_.designBuildTimeRemaining;
               if((_loc12_ > 0 || _loc29_.buildingRepairTimeRemaining > 0) && STORE.var_879 != "Shipdock")
               {
                  _loc18_ = BPResourceManager.getString("bp-flash","store_popup_upgrade_build_build");
                  _loc28_ = BPResourceManager.getString("bp-flash","store_popup_upgrade_building_build");
                  if(_loc29_.upgradeTimeRemaining > 0 || _loc29_.designBuildTimeRemaining > 0)
                  {
                     _loc18_ = BPResourceManager.getString("bp-flash","store_popup_upgrade_build_upgrade");
                     _loc28_ = BPResourceManager.getString("bp-flash","store_popup_upgrade_building_upgrade");
                  }
                  if(_loc29_.upgradeFortificationTimeRemaining > 0)
                  {
                     _loc18_ = BPResourceManager.getString("bp-flash","store_popup_upgrade_build_fortification");
                     _loc28_ = BPResourceManager.getString("bp-flash","store_popup_upgrade_building_fortification");
                  }
                  if(_loc29_.isRepairing || _loc29_.hp < _loc29_.hpMax)
                  {
                     _loc12_ = _loc29_.buildingRepairTimeRemaining;
                     _loc18_ = BPResourceManager.getString("bp-flash","store_popup_upgrade_build_repair");
                     _loc28_ = BPResourceManager.getString("bp-flash","store_popup_upgrade_building_repair");
                  }
                  _loc2_.var_5787 = _loc29_.getTokenTransactionLogDetails();
                  var _loc31_:* = param1;
                  if("SP1" !== _loc31_)
                  {
                     if("SP2" !== _loc31_)
                     {
                        if("SP3" !== _loc31_)
                        {
                           if("SP4" === _loc31_)
                           {
                              _loc2_.description = class_295.applyTemplateToKey("store_popup_savetime",{
                                 "time":class_84.toTime(_loc12_,false,false),
                                 "building":_loc28_,
                                 "buildingName":_loc29_._buildingProps.name
                              });
                           }
                        }
                        else
                        {
                           _loc2_.description = class_295.applyTemplateToKey("store_popup_sp2_reducebyhour_description2",{
                              "building":_loc18_,
                              "buildingName":_loc29_._buildingProps.name
                           });
                        }
                     }
                     else
                     {
                        _loc2_.description = class_295.applyTemplateToKey("store_popup_sp2_reducebyhalfhour_description2",{
                           "building":_loc18_,
                           "buildingName":_loc29_._buildingProps.name
                        });
                     }
                  }
                  else if(_loc12_ <= 300)
                  {
                     _loc2_.description = class_295.applyTemplateToKey("store_popup_sp1_closeenough_description2",{
                        "building":_loc28_,
                        "buildingName":_loc29_._buildingProps.name
                     });
                  }
                  else
                  {
                     _loc2_.description = class_295.applyTemplateToKey("store_popup_sp1_closeenough_description",{
                        "building":_loc28_,
                        "buildingName":_loc29_._buildingProps.name
                     });
                  }
               }
               else if(_loc29_.type == 5)
               {
                  _loc3_ = _loc29_ as ShipYard;
                  if(_loc3_.shipBuildTimeRemaining > 0)
                  {
                     _loc12_ = _loc3_.shipBuildTimeRemaining;
                     _loc11_ = _loc3_.currentBuild.hullName;
                     _loc2_.var_5787 = _loc3_.currentBuild.getTokenTransactionLogDetails();
                     _loc16_ = _loc3_.refitShip?"store_popup_upgrade_building_refit":"store_popup_upgrade_building_build";
                     _loc19_ = BPResourceManager.getString("bp-flash",_loc16_);
                     _loc9_ = _loc3_.refitShip?"store_popup_upgrade_build_refit":"store_popup_upgrade_build_build";
                     _loc8_ = BPResourceManager.getString("bp-flash",_loc9_);
                     if(_loc12_ > 0)
                     {
                        if(param1 == "SP1")
                        {
                           if(_loc12_ <= 300)
                           {
                              _loc2_.description = class_295.applyTemplateToKey("store_popup_sp1_closeenough_description4",{
                                 "building":_loc19_,
                                 "buildingName":_loc11_
                              });
                           }
                           else
                           {
                              _loc2_.description = class_295.applyTemplateToKey("store_popup_sp1_closeenough_description3",{
                                 "building":_loc19_,
                                 "buildingName":_loc11_
                              });
                           }
                        }
                        else if(param1 == "SP2")
                        {
                           _loc2_.description = class_295.applyTemplateToKey("store_popup_sp2_reducebyhalfhour_description",{
                              "hullName":_loc11_,
                              "building":_loc8_
                           });
                        }
                        else if(param1 == "SP3")
                        {
                           _loc2_.description = class_295.applyTemplateToKey("store_popup_sp3_reducebyhour_description",{
                              "hullName":_loc11_,
                              "building":_loc8_
                           });
                        }
                        else if(param1 == "SP4")
                        {
                           _loc2_.description = class_295.applyTemplateToKey("store_popup_savetime",{
                              "time":class_84.toTime(_loc12_,false,false),
                              "building":_loc19_,
                              "buildingName":_loc11_
                           });
                        }
                     }
                  }
               }
               else if(_loc29_ is BuildingGenericResearch)
               {
                  _loc6_ = _loc29_ as BuildingGenericResearch;
                  if(_loc6_.researchTimeRemaining > 0)
                  {
                     _loc12_ = _loc6_.researchTimeRemaining;
                     _loc15_ = RESEARCH.getResearchComp(_loc6_.researchID);
                     _loc11_ = _loc15_.name;
                     if(_loc12_ > 0)
                     {
                        _loc31_ = param1;
                        if("SP1" !== _loc31_)
                        {
                           if("SP2" !== _loc31_)
                           {
                              if("SP3" !== _loc31_)
                              {
                                 if("SP4" === _loc31_)
                                 {
                                    _loc2_.description = class_295.applyTemplateToKey("store_popup_savetime",{
                                       "time":class_84.toTime(_loc12_,false,false),
                                       "building":BPResourceManager.getString("bp-flash","store_popup_upgrade_building_research"),
                                       "buildingName":_loc11_
                                    });
                                 }
                              }
                              else
                              {
                                 _loc2_.description = class_295.applyTemplateToKey("store_popup_sp3_reducebyhour_description",{
                                    "hullName":_loc11_,
                                    "building":BPResourceManager.getString("bp-flash","store_popup_upgrade_build_research")
                                 });
                              }
                           }
                           else
                           {
                              _loc2_.description = class_295.applyTemplateToKey("store_popup_sp2_reducebyhalfhour_description",{
                                 "hullName":_loc11_,
                                 "building":BPResourceManager.getString("bp-flash","store_popup_upgrade_build_research")
                              });
                           }
                        }
                        else if(_loc12_ <= 300)
                        {
                           _loc2_.description = class_295.applyTemplateToKey("store_popup_sp1_closeenough_description4",{
                              "building":BPResourceManager.getString("bp-flash","store_popup_upgrade_building_research"),
                              "buildingName":_loc11_
                           });
                        }
                        else
                        {
                           _loc2_.description = class_295.applyTemplateToKey("store_popup_sp1_closeenough_description3",{
                              "building":BPResourceManager.getString("bp-flash","store_popup_upgrade_building_research"),
                              "buildingName":_loc11_
                           });
                        }
                     }
                  }
               }
               else if(_loc29_.type == 7)
               {
                  _loc7_ = _loc29_ as ShipDock;
                  if(_loc7_.repairTimeRemainingTotal > 0)
                  {
                     _loc12_ = _loc7_.repairTimeRemainingTotal;
                     if(_loc12_ > 0)
                     {
                        _loc31_ = param1;
                        if("SP1" !== _loc31_)
                        {
                           if("SP2" !== _loc31_)
                           {
                              if("SP3" !== _loc31_)
                              {
                                 if("SP4" === _loc31_)
                                 {
                                    _loc2_.description = class_295.applyTemplateToKey("store_popup_savetime2",{
                                       "time":class_84.toTime(_loc12_,false,false),
                                       "building":BPResourceManager.getString("bp-flash","store_popup_upgrade_building_repair")
                                    });
                                 }
                              }
                              else
                              {
                                 _loc2_.description = class_295.applyTemplateToKey("store_popup_sp3_reducebyhour_description3",{"building":BPResourceManager.getString("bp-flash","store_popup_upgrade_build_repair")});
                              }
                           }
                           else
                           {
                              _loc2_.description = class_295.applyTemplateToKey("store_popup_sp2_reducebyhalfhour_description3",{"building":BPResourceManager.getString("bp-flash","store_popup_upgrade_build_repair")});
                           }
                        }
                        else if(_loc12_ <= 300)
                        {
                           _loc2_.description = class_295.applyTemplateToKey("store_popup_sp1_closeenough_description5",{"building":BPResourceManager.getString("bp-flash","store_popup_upgrade_building_repair")});
                        }
                        else
                        {
                           _loc2_.description = class_295.applyTemplateToKey("store_popup_sp1_closeenough_description5",{"building":BPResourceManager.getString("bp-flash","store_popup_upgrade_building_repair")});
                        }
                     }
                  }
               }
               else if(_loc29_.type == 73)
               {
                  _loc14_ = _loc29_ as RocketLaunchPad;
                  if(_loc14_.isBuildingRocket)
                  {
                     _loc12_ = _loc14_.speedUpTimeRemaining;
                     if(_loc12_)
                     {
                        _loc31_ = param1;
                        if("SP1" !== _loc31_)
                        {
                           if("SP2" !== _loc31_)
                           {
                              if("SP3" !== _loc31_)
                              {
                                 if("SP4" === _loc31_)
                                 {
                                    _loc2_.description = class_295.applyTemplateToKey("store_popup_savetime2",{
                                       "time":class_84.toTime(_loc12_,false,false),
                                       "building":BPResourceManager.getString("bp-flash","store_popup_upgrade_building_build")
                                    });
                                 }
                              }
                              else
                              {
                                 _loc2_.description = BPResourceManager.getString("bp-flash","store_popup_sp3_reducebyhour_rocket");
                              }
                           }
                           else
                           {
                              _loc2_.description = BPResourceManager.getString("bp-flash","store_popup_sp2_reducebyhalfhour_rocket");
                           }
                        }
                        else if(_loc12_ <= 300)
                        {
                           _loc2_.description = class_295.applyTemplateToKey("store_popup_savetime2",{
                              "time":class_84.toTime(_loc12_,false,false),
                              "building":BPResourceManager.getString("bp-flash","store_popup_upgrade_building_build")
                           });
                        }
                        else
                        {
                           _loc2_.description = BPResourceManager.getString("bp-flash","store_popup_sp1_closeenough_description_rocket");
                        }
                     }
                  }
               }
               else if(_loc29_.type == 40)
               {
                  _loc26_ = _loc29_ as DefensivePlatform;
                  if(_loc26_.turretBuildTimeRemaining > 0)
                  {
                     _loc12_ = _loc26_.speedUpTimeRemaining;
                     if(_loc12_ > 0)
                     {
                        _loc31_ = param1;
                        if("SP1" !== _loc31_)
                        {
                           if("SP4" !== _loc31_)
                           {
                           }
                        }
                        else if(_loc12_ <= 300)
                        {
                           _loc2_.description = BPResourceManager.getString("bp-flash","store_popup_sp1_closeenough_description_turret2");
                        }
                        else
                        {
                           _loc2_.description = BPResourceManager.getString("bp-flash","store_popup_sp1_closeenough_description_turret");
                        }
                        _loc2_.description = class_295.applyTemplateToKey("store_popup_savetime2",{
                           "time":class_84.toTime(_loc12_,false,false),
                           "building":BPResourceManager.getString("bp-flash","store_popup_upgrade_building_build")
                        });
                     }
                  }
               }
            }
            else
            {
               _loc31_ = param1;
               if("SP1" !== _loc31_)
               {
                  if("SP2" !== _loc31_)
                  {
                     if("SP3" !== _loc31_)
                     {
                        if("SP4" === _loc31_)
                        {
                           _loc2_.description = BPResourceManager.getString("bp-flash","store_popup_sp4_no_building_selected");
                        }
                     }
                     else
                     {
                        _loc2_.description = BPResourceManager.getString("bp-flash","store_popup_sp3_no_building_selected");
                     }
                  }
                  else
                  {
                     _loc2_.description = BPResourceManager.getString("bp-flash","store_popup_sp2_no_building_selected");
                  }
               }
               else
               {
                  _loc2_.description = BPResourceManager.getString("bp-flash","store_popup_sp1_no_building_selected");
               }
            }
         }
         _loc31_ = param1;
         if("PRO1" !== _loc31_)
         {
            if("PRO2" !== _loc31_)
            {
               if("PRO3" === _loc31_)
               {
                  _loc2_.description = BPResourceManager.getString("bp-flash","store_popup_pro3_description");
               }
            }
            else
            {
               _loc2_.description = BPResourceManager.getString("bp-flash","store_popup_pro2_description");
            }
         }
         else
         {
            _loc2_.description = BPResourceManager.getString("bp-flash","store_popup_pro1_description");
         }
         _loc24_ = 0;
         _loc10_ = _loc30_.cost.length;
         if(_loc5_)
         {
            _loc24_ = _loc5_.q;
         }
         if(_loc30_.inf)
         {
            _loc24_ = 0;
         }
         _loc23_ = "" + _loc2_.description;
         if(param1 == "BIP" && STORE.var_146.BIP && STORE.var_146.BIP.q < 10)
         {
            _loc23_ = _loc23_ + class_295.applyTemplateToKey("store_popup_totalincrease",{"percent":(STORE.var_146.BIP.q + 1) * 10});
         }
         var _loc20_:String = "";
         if(param1.substr(0,2) == "BR" && _loc30_.cost[0] == 0)
         {
            _loc20_ = BPResourceManager.getString("bp-flash","store_popup_morestoragerequired");
         }
         if(param1.substr(0,2) == "SP")
         {
            if(!_loc29_)
            {
               _loc20_ = BPResourceManager.getString("bp-flash","store_popup_nobuildingselected");
            }
            else if(_loc29_)
            {
               _loc12_ = 0;
               if(_loc29_.upgradeTimeRemaining + _loc29_.buildTimeRemaining + _loc29_.buildingRepairTimeRemaining + _loc29_.upgradeFortificationTimeRemaining + _loc29_.designBuildTimeRemaining > 0)
               {
                  if(!(_loc29_ is ShipDock && STORE.var_879 == "Shipdock"))
                  {
                     _loc12_ = _loc29_.isRepairing?_loc29_.buildingRepairTimeRemaining:_loc29_.upgradeTimeRemaining + _loc29_.buildTimeRemaining + _loc29_.upgradeFortificationTimeRemaining + _loc29_.designBuildTimeRemaining;
                  }
                  else
                  {
                     _loc12_ = ShipDock(_loc29_).repairTimeRemainingTotal;
                  }
               }
               else
               {
                  if(_loc29_.type == 73 && RocketLaunchPad(_loc29_).rocketBuildTimeRemaining > 0)
                  {
                     _loc12_ = RocketLaunchPad(_loc29_).rocketBuildTimeRemaining;
                  }
                  if(_loc29_.type == 5 && (_loc29_ as ShipYard).shipBuildTimeRemaining > 0)
                  {
                     _loc12_ = (_loc29_ as ShipYard).shipBuildTimeRemaining;
                  }
                  if(_loc29_ is BuildingGenericResearch && (_loc29_ as BuildingGenericResearch).researchTimeRemaining > 0)
                  {
                     _loc12_ = (_loc29_ as BuildingGenericResearch).researchTimeRemaining;
                  }
                  if(_loc29_ is ShipDock && ShipDock(_loc29_).repairTimeRemainingTotal > 0)
                  {
                     _loc12_ = ShipDock(_loc29_).repairTimeRemainingTotal;
                  }
                  if(_loc29_.type == 40 && (_loc29_ as DefensivePlatform).turretBuildTimeRemaining > 0)
                  {
                     _loc12_ = (_loc29_ as DefensivePlatform).turretBuildTimeRemaining;
                  }
               }
               if(_loc12_ == 0)
               {
                  _loc20_ = BPResourceManager.getString("bp-flash","store_popup_problem_nothingtospeedup");
               }
               else if(param1 == "SP1" && _loc12_ > 300)
               {
                  _loc20_ = BPResourceManager.getString("bp-flash","store_popup_problem_morethan5minutes");
               }
               else if(param1 == "SP2" && _loc12_ < 1800)
               {
                  _loc20_ = BPResourceManager.getString("bp-flash","store_popup_problem_notneeded");
               }
               else if(param1 == "SP3" && _loc12_ < 3600)
               {
                  _loc20_ = BPResourceManager.getString("bp-flash","store_popup_problem_notneeded");
               }
               else if(param1 == "SP4" && _loc12_ <= 300)
               {
                  _loc20_ = BPResourceManager.getString("bp-flash","store_popup_problem_notneeded");
               }
            }
            else
            {
               _loc20_ = BPResourceManager.getString("bp-flash","store_popup_nothingselected");
            }
         }
         var _loc21_:String = GLOBAL.formatNumber(_loc30_.cost[_loc24_]);
         if(_loc30_.cost[_loc24_] == 0 && _loc20_ == "")
         {
            _loc21_ = BPResourceManager.getString("bp-flash","store_popup_free");
            _loc2_.var_5924 = false;
         }
         else
         {
            _loc2_.var_5924 = true;
         }
         if(_loc20_ != "" || !STORE.canBuy && param1 != "SP1")
         {
            _loc2_.alpha = 0.5;
            _loc25_ = _loc21_;
            _loc27_ = _loc20_;
         }
         else if(_loc24_ >= _loc10_ && !_loc30_.inf)
         {
            _loc2_.alpha = 0.5;
            _loc25_ = BPResourceManager.getString("bp-flash","store_popup_soldout");
            if(_loc30_.duration > 0)
            {
               _loc13_ = STORE.var_146[param1].e - GlobalProperties.gameTime;
               if(_loc13_ > 0)
               {
                  _loc27_ = class_295.applyTemplateToKey("store_popup_rebuy",{"time":class_84.toTime(_loc13_,true)});
               }
               else
               {
                  _loc5_.q = §§dup(_loc5_).q - 1;
               }
            }
            else if(_loc24_ == 0)
            {
               _loc27_ = BPResourceManager.getString("bp-flash","store_popup_youhavepurchasedthis");
            }
            else
            {
               _loc27_ = class_295.applyTemplateToKey("store_popup_youhavepurchesedthis_times",{
                  "purchased":_loc24_,
                  "quantity":_loc10_
               });
            }
         }
         else
         {
            _loc4_ = true;
            if(_loc30_.inf)
            {
               _loc24_ = 0;
            }
            _loc25_ = _loc21_;
            if(_loc30_.duration > 0)
            {
               _loc27_ = class_295.applyTemplateToKey("store_popup_cooldown",{"time":class_84.toTime(_loc30_.duration,true)});
            }
            else if(_loc30_.inf)
            {
               _loc27_ = "";
            }
            else
            {
               if(_loc24_ == 0 && _loc10_ == 1)
               {
                  _loc27_ = BPResourceManager.getString("bp-flash","store_popup_purchaseonce");
               }
               if(_loc24_ == 0 && _loc10_ > 1)
               {
                  _loc27_ = class_295.applyTemplateToKey("store_popup_purchasemany",{"quantity":_loc10_});
               }
               if(_loc24_ > 0)
               {
                  _loc27_ = class_295.applyTemplateToKey("store_popup_purchasefraction",{
                     "purchased":_loc24_,
                     "quantity":_loc10_
                  });
               }
            }
         }
         _loc2_.var_5745 = _loc27_;
         if(param1 == "SP4")
         {
            _loc2_.var_3866 = BPResourceManager.getString("bp-flash","store_popup_button_buy_instant");
         }
         else if(param1 == "SP1" || param1 == "SP2" || param1 == "SP3")
         {
            _loc17_ = class_182.determineSpeedUpCopy(GlobalProperties.playerId)?"store_popup_button_buy_speedup":"store_popup_button_buy";
            _loc2_.var_3866 = BPResourceManager.getString("bp-flash",_loc17_);
         }
         else
         {
            _loc2_.var_3866 = BPResourceManager.getString("bp-flash","store_popup_button_buy");
         }
         _loc2_.var_2623 = _loc4_;
         _loc2_.body = _loc23_ != "undefined" && _loc23_.length?_loc23_:_loc2_.body;
         _loc2_.cost = _loc25_;
         return _loc2_;
      }
      
      public function getTokenLog() : Object
      {
         var _loc4_:* = null;
         var _loc7_:* = null;
         var _loc1_:* = null;
         var _loc6_:* = null;
         var _loc3_:* = null;
         var _loc2_:Object = null;
         var _loc5_:BuildingFoundation = GLOBAL.selectedBuilding;
         var _loc8_:* = _loc5_.type;
         if(5 !== _loc8_)
         {
            if(7 !== _loc8_)
            {
               if(26 !== _loc8_)
               {
                  if(23 !== _loc8_)
                  {
                     if(25 !== _loc8_)
                     {
                        if(21 !== _loc8_)
                        {
                        }
                     }
                     addr58:
                     _loc6_ = _loc5_ as BuildingGenericResearch;
                     _loc3_ = RESEARCH.getResearchComp(_loc6_.researchID);
                     if(_loc3_)
                     {
                        _loc2_ = _loc3_.getTokenTransactionLogDetails();
                     }
                  }
                  addr57:
                  §§goto(addr58);
               }
               §§goto(addr57);
            }
            else
            {
               _loc7_ = _loc5_ as ShipDock;
               _loc1_ = _loc7_.getRepairingFleet();
               if(_loc1_)
               {
                  _loc2_ = _loc1_.getTokenTransactionLogDetails();
               }
            }
         }
         else
         {
            _loc4_ = _loc5_ as ShipYard;
            if(_loc4_.currentBuild)
            {
               _loc2_ = _loc4_.currentBuild.getTokenTransactionLogDetails();
            }
         }
         if(!_loc2_)
         {
            _loc2_ = _loc5_.getTokenTransactionLogDetails();
         }
         return _loc2_;
      }
      
      public function refreshCategory() : void
      {
         switchCategory(_category);
      }
      
      override public function hide() : void
      {
         ButtonManager.detach(var_4370);
         super.hide();
      }
   }
}

import flash.display.MovieClip;
import flash.text.TextField;
import com.waterworld.utils.movieclip.class_277;
import com.waterworld.display.ButtonManager;
import com.waterworld.resources.BPResourceManager;
import com.waterworld.core.GLOBAL;

class CategoryButton extends Object
{
   
   private static const STORES_ASSET_ID:String = "popupsStore";
    
   private var _button:MovieClip;
   
   private var _category:String;
   
   private var _callback:Function;
   
   private var _titleDeselected:TextField;
   
   private var _titleSelected:TextField;
   
   private var _freeOfferText:TextField;
   
   function CategoryButton(param1:MovieClip, param2:String, param3:Function)
   {
      super();
      init(param1,param2,param3);
   }
   
   private function init(param1:MovieClip, param2:String, param3:Function) : void
   {
      _callback = param3;
      _category = param2;
      _button = class_277.getMovieClip(param1,["btn_" + param2]);
      ButtonManager.attach(_button,onClick);
      _titleSelected = class_277.getTextField(_button,["tCatagory_Selected"]);
      _titleDeselected = class_277.getTextField(_button,["tCatagory_Deselected"]);
      var _loc6_:* = BPResourceManager.getString("bp-flash","store_popup_button_" + param2);
      _titleDeselected.text = _loc6_;
      _titleSelected.text = _loc6_;
      _freeOfferText = class_277.getTextField(_button,["tFree"]);
      _freeOfferText.text = BPResourceManager.getString("bp-flash","store_popup_free");
      hasFreeOffer = false;
      var _loc5_:MovieClip = class_277.getMovieClip(_button,["iconGuide"]);
      var _loc4_:Class = GLOBAL.assets.getClass("popupsStore","AssetStoreIcon_" + param2);
      _loc5_.addChild(new _loc4_() as MovieClip);
   }
   
   private function onClick() : void
   {
   }
   
   public function set hasFreeOffer(param1:Boolean) : void
   {
      _freeOfferText.visible = param1;
   }
   
   public function set selected(param1:Boolean) : void
   {
      _titleSelected.visible = param1;
      _titleDeselected.visible = !param1;
   }
   
   public function checkSelected(param1:String) : void
   {
      selected = _category == param1;
   }
}
