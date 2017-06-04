/**
 * Created by JasonFK on 2017/6/4.
 */
package flex.capjason.reflect.bean {
import flex.capjason.reflect.Clonable;
import flex.capjason.reflect.ReflectKit;
[Bindable]
public class School implements Clonable{
    public var name:String = "Nanjing";
    public function School(n:String = null) {
        name = n;
    }

    public function clone():Clonable {
        return ReflectKit.cloneValueObject(this);
    }
}
}
