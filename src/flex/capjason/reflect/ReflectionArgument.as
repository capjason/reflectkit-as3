/**
 * Created by JasonFK on 2017/6/4.
 */
package flex.capjason.reflect {
public class ReflectionArgument {
    private var _key:String;
    private var _value:String;

    public function ReflectionArgument(key:String, value:String) {
        this._key = key;
        this._value = value;
    }


    public function get key():String {
        return _key;
    }

    public function get value():Object {
        return _value;
    }
}
}
