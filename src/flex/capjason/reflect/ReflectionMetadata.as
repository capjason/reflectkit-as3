/**
 * Created by JasonFK on 2017/6/4.
 */
package flex.capjason.reflect {
public class ReflectionMetadata {
    private var _name:String;
    private var _args:Vector.<ReflectionArgument> = new Vector.<ReflectionArgument>();

    public function ReflectionMetadata() {

    }

    public static function createFromXML(xml:XML):ReflectionMetadata {
        var metadata:ReflectionMetadata = new ReflectionMetadata();
        metadata._name = xml.@name;
        var args:XMLList = xml.arg;
        for(var i:int = 0;i < args.length(); ++i) {
            var item:XML = args[i];
            var arg:ReflectionArgument = new ReflectionArgument(item.@key,item.@value);
            metadata._args.push(arg);
        }
        return metadata;
    }

    public function hasDirectArgValue(value:String):Boolean {
        for(var i:int = 0;i < args.length; ++i) {
            if(args[i].key == "" && args[i].value == value) {
                return true;
            }
        }
        return false;
    }

    public function getArgument(name:String):ReflectionArgument {
        for(var i:int = 0;i < args.length; ++i) {
            if(args[i].key == name) {
                return args[i];
            }
        }
        return null;
    }

    public function hasArgument(name:String):Boolean {
        return getArgument(name) != null;
    }

    public function get args():Vector.<ReflectionArgument> {
        return _args;
    }

    public function get name():String {
        return _name;
    }
}
}
