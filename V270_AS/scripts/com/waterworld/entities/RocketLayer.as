package com.waterworld.entities
{
   import flash.events.EventDispatcher;
   import com.waterworld.utils.class_165;
   import gs.TweenLite;
   import com.waterworld.core.GLOBAL;
   import com.waterworld.utils.class_177;
   import flash.display.Shape;
   import com.waterworld.utils.SoftwareDisplay;
   import com.waterworld.utils.StarlingDisplay;
   import flash.geom.Rectangle;
   import package_95.class_195;
   import flash.events.Event;
   
   public class RocketLayer extends EventDispatcher
   {
      
      private static const const_1958:int = 20;
      
      public static const const_2311:String = "eventfinished";
       
      private var var_196:class_165;
      
      private var _view:class_165;
      
      private var _use3d:Boolean;
      
      public function RocketLayer(param1:Boolean)
      {
         super();
         _use3d = param1;
         _view = class_177.createSpriteWrapper(_use3d);
      }
      
      public function get view() : class_165
      {
         return _view;
      }
      
      public function destroy() : void
      {
         TweenLite.killTweensOf(var_196);
         _view.removeFromParent();
         _view = null;
         var_196 = null;
      }
      
      public function loadRocket(param1:String) : void
      {
         if(null == param1)
         {
            return;
         }
         _view.removeChildren();
         GLOBAL.assets.getContentAsync(param1,onLoadSuccess,null,true);
      }
      
      private function onLoadSuccess(param1:Vector.<String>) : void
      {
         var _loc2_:* = null;
         if(null == _view)
         {
            return;
         }
         _view.removeChildren();
         var_196 = class_177.createBitmapDataContainerFromId(param1[0],_use3d);
         _view.addChild(var_196);
         if(!_use3d)
         {
            _loc2_ = new Shape();
            _loc2_.graphics.clear();
            _loc2_.graphics.beginFill(0);
            _loc2_.graphics.drawRect(0,0,var_196.texture.height,-var_196.texture.width);
            _loc2_.graphics.endFill();
            _view.addChild(_loc2_);
            SoftwareDisplay(var_196).mask = _loc2_;
            var_196.rotation = -90;
         }
         else
         {
            var_196.rotation = -1.5707963267948966;
            StarlingDisplay(_view).clipRect = new Rectangle(0,0,var_196.texture.height,-var_196.texture.width);
         }
         var_196.y = var_196.height;
      }
      
      public function play() : void
      {
         if(var_196 != null)
         {
            TweenLite.killTweensOf(var_196);
            if(var_196.height > 0)
            {
               var_196.y = var_196.height;
               TweenLite.to(var_196,var_196.height / 20,{
                  "y":0,
                  "onComplete":onRocketFinish,
                  "ease":class_195.easeNone
               });
            }
         }
      }
      
      private function onRocketFinish() : void
      {
         dispatchEvent(new Event("eventfinished"));
      }
   }
}
