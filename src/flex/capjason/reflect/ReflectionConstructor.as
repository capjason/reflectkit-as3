/**
 * Created by JasonFK on 2017/6/6.
 */
package flex.capjason.reflect {
public class ReflectionConstructor {
    private var _params:Vector.<ReflectionParameter>  = new Vector.<ReflectionParameter>();
    public function ReflectionConstructor() {
    }

    public static function createFromXML(xml:XML):ReflectionConstructor {
        var constructor:ReflectionConstructor = new ReflectionConstructor();
        var paramXml:XMLList = xml.parameter;
        for(var i:int = 0;i < paramXml.length(); ++i) {
            constructor._params.push(ReflectionParameter.createFromXML(paramXml[0]));
        }
        return constructor;
    }

    public function get paramCount():int {
        return _params.length;
    }

    public function get requiredParamCount():int {
        var count:int = 0;
        for(var i:int = 0;i < _params.length; ++i) {
            if(!_params[i].optional) {
                count ++;
            }
        }
        return count;
    }

    public function get params():Vector.<ReflectionParameter> {
        return _params;
    }
}
}
