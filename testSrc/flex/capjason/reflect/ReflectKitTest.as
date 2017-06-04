/**
 * Created by JasonFK on 2017/6/4.
 */
package flex.capjason.reflect {
import flex.capjason.reflect.bean.Child;
import flex.capjason.reflect.bean.School;

import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertTrue;

public class ReflectKitTest {
    public function ReflectKitTest() {
    }

    [Test]
    public function testClone():void {
        var child:Child = new Child();
        child.name = "haha";
        child.gender = 10;
        var other:Child = child.clone() as Child;
        assertEquals(other.school.name,child.school.name);
        assertEquals(other.name,"haha");
        assertEquals(other.gender,10);
        child.school = new School("ChongQing");
        assertTrue(child.school.name != other.school.name);
    }
}
}
