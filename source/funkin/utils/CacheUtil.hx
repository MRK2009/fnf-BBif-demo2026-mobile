package funkin.utils;

import flixel.FlxG;
import openfl.utils.Assets;
import openfl.system.System;

class CacheUtil {
    public static function clean():Void {
        FlxG.bitmap.clearCache();
        
        Assets.cache.clear();

        #if cpp
        cpp.NativeGc.enable(true);
        cpp.NativeGc.run(true);
        #end

        System.gc();
        
        trace("Memory Successfully cleared.");
    }
}