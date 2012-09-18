should = require 'should'
Kronic = require '../kronic.coffee'

shiftDate = (date, what, count) ->
    value = Date::["get#{what}"].call(date)
    Date::["set#{what}"].call date, value + count
    date

lastYear = -> thisYear() - 1
thisYear = -> (new Date).getFullYear()
thisDay = ->  (new Date).getDay()

describe 'parsing string into a date', ->
    it 'should work with relative distances', ->
        Kronic.parse('Today').should.equal new Date
        Kronic.parse('today').should.equal new Date
        Kronic.parse('  Today').should.equal new Date
        Kronic.parse('Yesterday').should.equal shiftDate new Date, 'Date', -1
        Kronic.parse('Tomorrow').should.equal shiftDate new Date, 'Date', 1
        Kronic.parse('Last Monday').should.equal shiftDate new Date, 'Date', 1 - thisDay()
        Kronic.parse('This Monday').should.equal shiftDate new Date, 'Date', 8 - thisDay()

    it 'should work for day and month', ->
        if ((new Date).getTime() < new Date(thisYear(), 8, 4))
            Kronic.parse('4 Sep').should.equal new Date(lastYear(), 8, 4)
            Kronic.parse('4  Sep').should.equal new Date(lastYear(), 8, 4)
            Kronic.parse('4 September').should.equal new Date(lastYear(), 8, 4)
            Kronic.parse('Sep 4th').should.equal new Date(lastYear(), 8, 4)
            Kronic.parse('September 4').should.equal new Date(lastYear(), 8, 4)
        else
            Kronic.parse('4 Sep').should.equal new Date(thisYear(), 8, 4)
            Kronic.parse('4  Sep').should.equal new Date(thisYear(), 8, 4)
            Kronic.parse('4 September').should.equal new Date(thisYear(), 8, 4)
            Kronic.parse('Sep 4th').should.equal new Date(thisYear(), 8, 4)
            Kronic.parse('September 4').should.equal new Date(thisYear(), 8, 4)

        if ((new Date).getTime() < new Date(thisYear(), 8, 20))
            Kronic.parse('20 Sep').should.equal new Date(lastYear(), 8, 20)
        else
            Kronic.parse('20 Sep').should.equal new Date(thisYear(), 8, 20)

    it 'should work for day, month and year', ->
        Kronic.parse('28 Sep 2010').should.equal new Date(2010, 8, 28)
        Kronic.parse('14 Sep 2008').should.equal new Date(2008, 8, 14)

        Kronic.parse('14th Sep 2008').should.equal new Date(2008, 8, 14)
        Kronic.parse('23rd Sep 2008').should.equal new Date(2008, 8, 23)

        Kronic.parse('September 14 2008').should.equal new Date(2008, 8, 14)

        Kronic.parse('Sep 14, 2008').should.equal new Date(2008, 8, 14)
        Kronic.parse('14 Sep, 2008').should.equal new Date(2008, 8, 14)

        Kronic.parse('2008-09-04').should.equal new Date(2008, 8, 4)
        Kronic.parse('2008-9-4').should.equal new Date(2008, 8, 4)

        Kronic.parse('1 Jan 2010').should.equal new Date(2010, 0, 1)
        Kronic.parse('31 Dec 2010').should.equal new Date(2010, 11, 31)

    it 'should not parse', ->
        should.not.exist Kronic.parse('0 Jan 2010')
        should.not.exist Kronic.parse('32 Dec 2010')
        should.not.exist Kronic.parse('366 Jan 2010')
        should.not.exist Kronic.parse('bogus')
        should.not.exist Kronic.parse('14')
        should.not.exist Kronic.parse('14 bogus in')
        should.not.exist Kronic.parse('14 June oen')
        should.not.exist Kronic.parse('January 1999')
        should.not.exist Kronic.parse('Last M')