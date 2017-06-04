/**
 * Created by JasonFK on 2017/6/4.
 */
package flex.capjason.reflect {
import flash.utils.describeType;

public class ReflectionClass extends ReflectionObject {
    private var _value:Object;
    private var _base:String;
    private var _prototypeChain:Vector.<String> = new Vector.<String>();
    private var _implementsInterface:Vector.<String> = new Vector.<String>();

    private var _variables:Vector.<ReflectionVariable> = new Vector.<ReflectionVariable>();
    private var _accessors:Vector.<ReflectionAccessor> = new Vector.<ReflectionAccessor>();
    public function ReflectionClass(value:Object) {
        _value = value;
        reflectClass();
    }

    protected function reflectClass():void {
        var xml:XML = describeType(_value);
        _name = xml.@name;
        _base = xml.@base;
        var list:XMLList = xml.extendsClass;
        var i:int;
        var tag:XML;
        for(i = 0;i < list.length(); ++i) {
            tag = list[i];
            _prototypeChain.push(tag.@type);
        }
        list = xml.implementsInterface;
        for(i = 0;i < list.length(); ++i) {
            tag = list[i];
            _implementsInterface.push(tag.@type);
        }

        list = xml.variable;
        for(i = 0;i < list.length(); ++i) {
            _variables.push(ReflectionVariable.createFromXML(list[i]));
        }

        list = xml.accessor;
        for(i = 0;i < list.length(); ++i) {
            _accessors.push(ReflectionAccessor.createFromXML(list[i]));
        }
        parseMetadata(xml.metadata);
    }


    public function get value():Object {
        return _value;
    }

    public function get base():String {
        return _base;
    }

    public function get prototypeChain():Vector.<String> {
        return _prototypeChain;
    }

    public function get implementsInterface():Vector.<String> {
        return _implementsInterface;
    }

    public function get variables():Vector.<ReflectionVariable> {
        return _variables;
    }

    public function get accessors():Vector.<ReflectionAccessor> {
        return _accessors;
    }
}
}
