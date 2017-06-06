/**
 * Created by JasonFK on 2017/6/4.
 */
package flex.capjason.reflect {
import flash.utils.describeType;

public class ReflectionClass extends ReflectionObject {
    private var _base:String;
    private var _isDynamic:Boolean;
    private var _isStatic:Boolean;
    private var _isFinal:Boolean;
    private var _prototypeChain:Vector.<String> = new Vector.<String>();
    private var _implementsInterface:Vector.<String> = new Vector.<String>();

    private var _instanceReflection:ReflectionClass;
    private var _constructor:ReflectionConstructor;

    private var _variables:Vector.<ReflectionVariable> = new Vector.<ReflectionVariable>();
    private var _accessors:Vector.<ReflectionAccessor> = new Vector.<ReflectionAccessor>();
    public function ReflectionClass(value:Object) {
        var xml:XML = describeType(value);
        createFromXML(xml,this);
    }

    private static function createFromXML(xml:XML,reflection:ReflectionClass):void {
        if(xml.localName() == "type") {
            reflection._name = xml.@name;
            reflection._base = xml.@base;
            reflection._isDynamic = xml.@isDynamic;
            reflection._isStatic = xml.@isStatic;
            reflection._isFinal = xml.@isFinal;
        } else if(xml.localName() == "factory") {
            reflection._name = xml.@type;
            reflection._isFinal = reflection._isStatic = reflection._isStatic = false;
        } else {
            throw new Error("cannot reflect class");
        }
        if(xml.constructor[0]) {
            reflection._constructor = ReflectionConstructor.createFromXML(xml.constructor[0]);
        }
        var list:XMLList = xml.extendsClass;
        var i:int;
        var tag:XML;
        for(i = 0;i < list.length(); ++i) {
            tag = list[i];
            reflection._prototypeChain.push(tag.@type);
        }

        if(xml.localName() == "factory") {
            reflection._base = reflection._prototypeChain[0];
        }

        list = xml.implementsInterface;
        for(i = 0;i < list.length(); ++i) {
            tag = list[i];
            reflection._implementsInterface.push(tag.@type);
        }

        list = xml.variable;
        for(i = 0;i < list.length(); ++i) {
            reflection._variables.push(ReflectionVariable.createFromXML(list[i]));
        }

        list = xml.accessor;
        for(i = 0;i < list.length(); ++i) {
            reflection._accessors.push(ReflectionAccessor.createFromXML(list[i]));
        }
        reflection.parseMetadata(xml.metadata);
        if(reflection.isStatic && xml.factory[0]) {
            reflection._instanceReflection = new ReflectionClass(null);
            createFromXML(xml.factory[0],reflection._instanceReflection);
        }
    }


    public function get isDynamic():Boolean {
        return _isDynamic;
    }

    public function get isStatic():Boolean {
        return _isStatic;
    }


    public function get instanceReflection():ReflectionClass {
        return _instanceReflection;
    }

    public function get isFinal():Boolean {
        return _isFinal;
    }

    public function get constructor():ReflectionConstructor {
        return _constructor;
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
