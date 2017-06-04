/**
 * Created by Jason on 2017/6/4.
 */
package flex.capjason.reflect {
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

public class ReflectKit {
    public function ReflectKit() {

    }

    /**
     * clone a value object,any public property is cloned to the returned object.
     * if deepClone is set to true,any clonable property is recursively cloned.
     * @param value
     * @param deepClone
     * @return
     */
    public static function cloneValueObject(object:Clonable,deepClone:Boolean = true):Clonable {
        var clazz:Class = getClassDefinition(object);
        var res = new clazz();
        var reflection:ReflectionClass = new ReflectionClass(object);
        var i:int;

        var clonableProps:Vector.<String> = new Vector.<String>();
        var variables:Vector.<ReflectionVariable> = reflection.variables;
        for(i = 0;i < variables.length; ++i) {
            clonableProps.push(variables[i].name);
        }

        var accessors:Vector.<ReflectionAccessor> = reflection.accessors;
        for(i = 0;i < accessors.length; ++i) {
            var accessor:ReflectionAccessor = accessors[i];
            if(accessor.access != AccessType.READWRITE) {
                continue;
            }
            clonableProps.push(accessor.name);
        }

        for(i = 0;i < clonableProps.length; ++i) {
            var prop:String = clonableProps[i];
            var value:* = object[prop];
            if(value is Clonable && deepClone) {
                res[prop] = cloneValueObject(value,deepClone);
            } else {
                res[prop] = value;
            }
        }
        return res;
    }

    /**
     * serialize an class to JSON,
     * variables and accessors support metadata below
     *      JSON
     *           args transient, no value
     *           args name, name of json object property,default use class property name
     *           args nullValue, specify a value which is regarded as null value for this property.
     *                          used when keepNullValue set to true, default is null.
     * @param serializable
     * @param keepNullValue if set to true, any property whose value is nullValue will be ignored
     * @return
     */
    public static function jsonSerialize(serializable:JSONSerializable,keepNullValue:Boolean = true):Object {
        var obj:Object = {};
        var reflection:ReflectionClass = new ReflectionClass(serializable);

        var accessibleVariables:Vector.<ReflectionObject> = new Vector.<ReflectionObject>();
        var i:int;
        for(i = 0;i < reflection.variables.length; ++i) {
            accessibleVariables.push(reflection.variables[i]);
        }

        for(i = 0;i < reflection.accessors.length; ++i) {
            accessibleVariables.push(reflection.accessors[i]);
        }
        for(i = 0;i < accessibleVariables.length; ++i) {
            var variable:ReflectionObject = accessibleVariables[i];
            var accessor:ReflectionAccessor = variable as ReflectionAccessor;
            if(accessor && accessor.access != AccessType.READWRITE) {
                continue;
            }
            var metadata:ReflectionMetadata = variable.getMetadata("JSON");
            //check null value
            if(!keepNullValue) {
                var nullValue:* = null;
                if(metadata && metadata.hasArgument("nullValue")) {
                    nullValue = metadata.getArgument("nullValue").value;
                }
                if(serializable[variable.name] == nullValue) {
                    continue;
                }
            }

            //check transient and property name
            var property:String = variable.name;
            if(metadata) {
                if(metadata.hasArgument("transient") || metadata.hasDirectArgValue("transient")) {
                    continue;
                }
                var arg:ReflectionArgument = metadata.getArgument("name");
                if(arg != null) {
                    property = String(arg.value);
                }
            }
            obj[property]  = value2Json(serializable[variable.name],keepNullValue);
        }
        return obj;
    }

    private static function value2Json(value:*,keepNullValue:Boolean = true):Object {
        var i:int;
        if(value is Array) {
            var arr:Array = [];
            var valueArr:Array = value as Array;
            for(i = 0;i < valueArr.length; ++i) {
                arr.push(value2Json(valueArr[i]));
            }
            return arr;
        }

        if(isPrimitiveType(value)) {
            return value;
        }

        if(value is JSONSerializable) {
            return jsonSerialize(value,keepNullValue);
        }
        var clss:String = getQualifiedClassName(value);
        if(clss == 'Object') {
            return value;
        } else {
            throw new Error("Object must implements JSONSerializable.");
        }
        return value;
    }

    private static function isPrimitiveType(value:*):Boolean {
        return value is String || value is Number
                || value is int || value is uint
                || value is Boolean || value == null;
    }


    public static function getClassDefinition(value:*):Class {
        return getDefinitionByName(getQualifiedClassName(value)) as Class;
    }

}
}
