# Assertions <sub><sup>_can make the test fail_<sup><sub>

Assertions are used to check the state, result, type, etc... of some code.  
If what was given was not expected, the test fails.

Available assertions:  
[Assert:Condition](./assertions.md#assertcondition)  
[Assert:CreatesError](./assertions.md#assertcreateserror)  
[Assert:CreatesNoError](./assertions.md#assertcreatesnoerror)  
[Assert:Equal](./assertions.md#assertequal)  
[Assert:Fail](./assertions.md#assertfail)  
[Assert:False](./assertions.md#assertfalse)  
[Assert:Invokable](./assertions.md#assertinvokable)  
[Assert:Nil](./assertions.md#assertnil)  
[Assert:NotEqual](./assertions.md#assertnotequal)  
[Assert:NotNil](./assertions.md#assertnotnil)  
[Assert:Pass](./assertions.md#assertpass)  
[Assert:TableEmpty](./assertions.md#asserttableempty)  
[Assert:TableEquals](./assertions.md#asserttableequals)  
[Assert:TableHasSameKeys](./assertions.md#asserttablehassamekeys)  
[Assert:TableNotEmpty](./assertions.md#asserttablenotempty)  
[Assert:True](./assertions.md#asserttrue)  
[Assert:Type](./assertions.md#asserttype)  

---

##### Assert:Condition
> `Assert:Condition( expression, [ message ] )`

`expession` should evaluate to a `boolean`  
Evaluated `boolean` should be `true` to make this assertion pass


##### Assert:CreatesError
> `Assert:CreatesError( invokable, ...)`

`invokable` should throw an error to make this assertion pass


##### Assert:CreatesNoError
> `Assert:CreatesNoError( invokable, ...)`

`invokable` should not throw an error to make this assertion pass


##### Assert:Equal
> `Assert:Equal( actual, expected, [ message ] )`

`actual` and `expected` can be of every type  
`actual` and `expected` should be the same to make this assertion pass    
More specialized assertions should be used for complex data-types


##### Assert:Fail
> `Assert:Fail( [ message ] )`

This function makes the test fail


##### Assert:False
> `Assert:False( boolean, [ message ] )`

`booleanType` should be of type `'boolean'`


##### Assert:Invokable
> `Assert:Invokable( object, [ message ] )`

`object` should be invokable to make this assertion pass


##### Assert:Nil
> `Assert:Nil( nilObject, [ message ] )`

`nilObject` should be of type `'nil'`  
`nilObject` should have the value of `nil` to make this assertion pass


##### Assert:NotEqual
> `Assert:NotEqual( actual, expected, [ message ] )`

`actual` and `expected` can be of every type  
`actual` and `expected` should not be the same to make this assertion pass  
More specialized assertions should be used for complex data-types


##### Assert:NotNil
> `Assert:NotNil( object, [ message ] )`

`object` should be of not be of type `'nil'` to make this assertion pass


##### Assert:Pass
> `Assert:Pass()`

This function makes the test pass


##### Assert:TableEmpty
> `Assert:TableEmpty( tableObject, [ message ] )`

`tableObject` should be of type `'table'`  
`tableObject` should be empty to make this assertion pass


##### Assert:TableEquals
> `Assert:TableEquals( tableA, tableB, [ message ] )`

`tableA` and `tableB` should both be of type `'table'`  
`tableA` and `tableB` should both be the same to make this assertion pass


##### Assert:TableHasSameKeys
> `Assert:TableHasSameKeys( tableA, tableB, [ message ] )`

`tableA` and `tableB` should both be of type `'table'`
`tableA` and `tableB` should both have the same keys to make this assertion pass  
Values of the keys are ignored


##### Assert:TableNotEmpty
> `Assert:TableNotEmpty( tableObject, [ message ] )`

`tableObject` should be of type `'table'`  
`tableObject` should have some value(s) to make this assertion pass


##### Assert:True
> `Assert:True( boolean, [ message ] )`

`booleanType` should be of type `'boolean'`


##### Assert:Type
> `Assert:Type( object, expectedType, [ message ] )`

`object` can be of any type  
`expectedType` should be the string representing what type the object is expected to be    
Type of `object` and `expectedType` should match to make this assertion pass  
