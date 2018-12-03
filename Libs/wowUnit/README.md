wowUnit is a [unit testing](http://en.wikipedia.org/wiki/Unit_testing "see Wikipedia")
framework intended to be used for AddOn development in World of Warcraft made by [Mirroar](https://github.com/Mirroar) and updated by [Fulgerul](https://github.com/fulgerul). I only intend to make it work for the latest WoW update. All the work was done by Mirroar and Fulgerul, and they are the ones who must be thank.

Example
=======

Say you have an AddOn called *addAddOn* that simply has a function for adding two
numbers. You could write tests to make sure the function performs as expected
like so:

	addAddOn.tests = {
		["Check addition of numbers"] = {
			["See if results are correct"] = function()
				wowUnit:assertEquals(addAddOn:add(1, 1), 2, "1 and 1 is 2");
				wowUnit:assertEquals(addAddOn:add(-3, 5), 2, "-3 + 5 = 2");
				wowUnit:assertEquals(addAddOn:add(1997, -1995), 2, "1997 + (-1995) = 2");
			end,
			["make sure it behaves as expected for strange input"] = function()
				wowUnit:isNil(addAddOn:add(), "nil when no parameters are given");
				wowUnit:isNil(addAddOn:add(1), "nil when only on parameter is given");
				wowUnit:isNil(addAddOn:add(nil, 1), "nil when only one parameter is given");
				wowUnit:assertEquals(addAddOn:add(-3, 5, 10), 2, "any parameters past the first 2 are ignored");
				wowUnit:isNil(addAddOn:add(1, "1"), "nil when a parameter is not a number");
			end
		}
	}

Once tests are written and loaded, you could run these tests in game by typing
"*/test addAddOn*".

Running Tests
=============

You can easily run unit tests contained in any table directly accessible in the
global namespace by using any of the following slash-commands:

	/test myAddon
	/wowunit myOtherAddon
	/wu testTable
	/unittest testSuite

If your tests are buried deeper within another table, you'll have to run command
like so:

	/run wowUnit:StartTests(myAddon.someTable.testSuiteIsHere)

Test Tables
===========

Anatomy of a Test Suite
-----------------------

#### title
(optional) The title of this test suite, diplayed in wowUnit's main window
#### tests
A table containing the test categories for this test suite. The keys of any
entries in this table serve as titles for your categories, while their values
should be tables containing the actual tests.

Example:

	testTable = {
		title = "My test Suite",
		tests = {
			["Category 1"] = {
				...
			},
			["Another Category"] = {
				...
			},
			...
		}
	}

Anatomy of a Test Category
--------------------------

#### setup
(optional) The function defined here will be called before every test in the
current category.
#### teardown
(optional) The function defined here will be called after every test in the
current category.

Any other functions defined in the table will be considered tests.

Example:

	...
	["Example Category"] = {
		["setup"] = function()
			-- mock complicated function
			myAddon.oldFunc = myAddon.complicatedFunction;
			myAddon.complicatedFunction = function()
				assert(true, "complicated function has been called");
			end
		end,
		["teardown"] = function()
			-- restore complicated function
			myAddon.complicatedFunction = myAddon.oldFunc;
		end,
		["does it get called?"] = function()
			wowUnit:expect(1);
			myAddon.shouldCallTheOtherFunction();
		end,
		...
	}
	...

Assertions
==========

wowUnit:assert(value, message)
------------------------------

#### value
This test will pass if and only if value evaluates to true in an _if (value) then
..._ statement.

#### message
(optional) This message will be displayed in the test window to indicate which
tests passed or failed.

wowUnit:assertEquals(value1, value2, message)
---------------------------------------------

#### value1, value2
This test will pass if and only if value1 is deemed equal to value2 in an _if 
(value1 == value2) then ..._ statement.

Note: Lua does not do automatic type conversion here, so _1_ and _"1"_ are not
equal. Also, two table values are only deemed equal if they reference the exact
same table. Two tables at different adresses are not deemed equal, even if their
contents are the same.

#### message
(optional) This message will be displayed in the test window to indicate which
tests passed or failed.

wowUnit:assertNonEquals(value1, value2, message)
---------------------------------------------

#### value1, value2
This test will pass if and only if value1 is not deemed equal to value2 in an _if 
(value1 ~= value2) then ..._ statement.

Note: Lua does not do automatic type conversion here, so _1_ and _"1"_ are not
equal.

#### message
(optional) This message will be displayed in the test window to indicate which
tests passed or failed.


wowUnit:assertSame(value1, value2, message)
-------------------------------------------

#### value1, value2
If any of the two values are not tables, this will behave exactly like
wowUnit:assertEquals. Provided with two tables, a recursive comparison will be
done to see whether the contents of the two tables are the same.

#### message
(optional) This message will be displayed in the test window to indicate which
tests passed or failed.

wowUnit:isNil(value, message)
-----------------------------

#### value
This test will pass if and only if value evaluates to nil in an
_if (type(value) == "nil") then ..._ statement.

#### message
(optional) This message will be displayed in the test window to indicate which
tests passed or failed.

wowUnit:isTable(value, message)
-------------------------------

#### value
This test will pass if and only if value evaluates to a table in an
_if (type(value) == "table") then ..._ statement.

#### message
(optional) This message will be displayed in the test window to indicate which
tests passed or failed.

wowUnit:isString(value, message)
--------------------------------

#### value
This test will pass if and only if value evaluates to a string in an
_if (type(value) == "string") then ..._ statement.

#### message
(optional) This message will be displayed in the test window to indicate which
tests passed or failed.

wowUnit:isNumber(value, message)
--------------------------------

#### value
This test will pass if and only if value evaluates to a number in an
_if (type(value) == "number") then ..._ statement.

#### message
(optional) This message will be displayed in the test window to indicate which
tests passed or failed.

wowUnit:isFunction(value, message)
----------------------------------

#### value
This test will pass if and only if value evaluates to a function in an
_if (type(value) == "function") then ..._ statement.

#### message
(optional) This message will be displayed in the test window to indicate which
tests passed or failed.

wowUnit:expect(numTests)
------------------------

#### numTests
This will pass if - during the course of the current test function - a number of
assertions is run that equals numTests.

Note: you can set the number of expected tests at any time during a test function.
It will only be checked after the test has completed. The following test, for
example, will show two successful assertions.

	["expectation test"] = function()
		wowUnit:expect(1);
		wowUnit:assert(true);
	end

Asynchronous Testing
====================

If you want to test processes that take a while to complete and don't block the
main thread, you will have to tell wowUnit to wait for more results instead of
continuing on to the next test.

Example:

	["asynch test"] = function()
		wowUnit:expect(1);
		local testID = wowUnit:pauseTesting(10);
		local timeElapsed = 0;
		local timeFrame = CreateFrame("Frame");
		timeFrame:SetScript("OnUpdate", function(self, elapsed)
			timeElapsed = timeElapsed + elapsed;
			
			-- How many seconds you want to block
			if (timeElapsed > 5) then
				timeFrame:SetScript("OnUpdate", nil);	-- don't forget to remove checks like this, otherwise you might be spamming asserts every frame
				
				-- Code to check the results
				wowUnit:assert(myAddon.processCompleted, "all done");
				
				-- Code to release block
				wowUnit:resumeTesting(testID);
			end
		end)

		-- Code you want to run
		myAddon:StartProcess();
	end

testID = wowUnit:pauseTesting(timeout)
--------------------------------------

Will pause running new tests until the timeout is reached or wowUnit:resumeTesting
is called.

#### timeout
(optional) New tests will not be run until this timeout (in seconds) is reached.
Default is 5 seconds.

#### testID
A unique ID for the currently running test, to be used with wowUnit:resumeTesting.

wowUnit:resumeTesting(testID)
-----------------------------

Will try to resume normal testing on the next frame.

#### testID
(optional) If provided, testing will only be resumed if the provided testID
matches the value returned by the most recent call to wowUnit:pauseTesting.

What Else?
==========

If you need further insights and examples for tests, check out wowUnit's tests.lua
and compare it with the results of running "*/test wowUnit*" ingame.


