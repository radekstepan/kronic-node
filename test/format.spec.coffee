should = require 'should'
Kronic = require '../kronic.coffee'

shiftDate = (date, what, count) ->
    value = Date::["get#{what}"].call(date)
    Date::["set#{what}"].call date, value + count
    date

thisDay = ->  (new Date).getDay()

describe 'formatting strings into dates', ->
    it 'should work :)', ->
        Kronic.format(new Date).should.equal 'Today'
        Kronic.format(shiftDate(new Date, 'Date', -1)).should.equal 'Yesterday'
        Kronic.format(shiftDate(new Date, 'Date', 1)).should.equal 'Tomorrow'
        Kronic.format(shiftDate(new Date, 'Date', 8 - thisDay())).should.equal 'This Monday'
        Kronic.format(new Date(2008, 8, 14)).should.equal '14 September 2008'