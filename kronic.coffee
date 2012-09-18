module.exports = (->
    DELIMITER = /[,\s]+/
    NUMBER = /^[0-9]+$/
    NUMBER_WITH_ORDINAL = /^([0-9]+)(st|nd|rd|th)?$/
    ISO_8601_DATE = /^([0-9]{4})-?(1[0-2]|0?[1-9])-?(3[0-1]|[1-2][0-9]|0?[1-9])$/
    
    MONTH_NAMES = [ 'january', 'jan', 'february', 'feb', 'march', 'mar', 'april', 'apr', 'may', 'may', 'june', 'jun', 'july', 'jul', 'august', 'aug', 'september', 'sep', 'october', 'oct', 'november', 'nov', 'december', 'dec' ]
    DAY_NAMES = [ 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday' ]

    trim = (string) ->
        string.replace /^\s+|\s+$/g, ''
    
    map = (array, func) ->
        result = []
        for x of array
            result.push func(array[x])
        result
    
    inject = (array, initialValue, func) ->
        accumulator = initialValue
        for x of array
            accumulator = func(accumulator, array[x])
        accumulator
    
    addDays = (date, numberOfDays) ->
        new Date(date * 1 + numberOfDays * 60 * 60 * 24 * 1000)
    
    titleize = (str) ->
        str.replace /^\w/, ($0) ->
            $0.toUpperCase()

    parseNearbyDays = (string, today) ->
        return today if string is 'today'
        return addDays(today, -1) if string is 'yesterday'
        addDays today, +1 if string is 'tomorrow'
    
    parseLastOrThisDay = (string, today) ->
        tokens = string.split(DELIMITER)
        if [ 'last', 'this' ].indexOf(tokens[0]) >= 0
            days = map([1, 2, 3, 4, 5, 6, 7], (x) ->
                addDays today, (if tokens[0] is 'last' then -x else x)
            )
            days = inject(days, {}, (a, x) ->
                a[DAY_NAMES[x.getDay()].toLowerCase()] = x
                a
            )
            days[tokens[1]]
    
    parseExactDay = (string, today) ->
        tokens = string.split(DELIMITER)
        if tokens.length >= 2
            matches = tokens[0].match(NUMBER_WITH_ORDINAL)
            if matches
                parseExactDateParts matches[1], tokens[1], tokens[2], today
            else
                matches = tokens[1].match(NUMBER_WITH_ORDINAL)
                if matches
                    parseExactDateParts matches[1], tokens[0], tokens[2], today
                else
                    null
    
    parseExactDateParts = (rawDay, rawMonth, rawYear, today) ->
        day = rawDay * 1
        month = monthFromName(rawMonth)
        year = undefined
        if rawYear
            year = (if rawYear.match(NUMBER) then rawYear * 1 else null)
        else
            year = today.getYear() + 1900
        return null unless day and month isnt null and year
        result = new Date(year, month, day)
        
        # Date constructor will happily accept invalid dates
        # so we're checking that day existed in the given month
        return null if result.getMonth() isnt month or result.getDate() isnt day
        result = new Date(year - 1, month, day) if result > today and not rawYear
        result
    
    parseIso8601Date = (string) ->
        if string.match(ISO_8601_DATE)
            tokens = map(string.split('-'), (x) ->
                x * 1
            )
            new Date(tokens[0], tokens[1] - 1, tokens[2])
    
    monthFromName = (month) ->
        monthIndex = MONTH_NAMES.indexOf(month)
        (if monthIndex >= 0 then Math.floor(monthIndex / 2) else null)
    
    parse: (string) ->
        now = @today()
        string = trim(string + "").toLowerCase()
        parseNearbyDays(string, now) or parseLastOrThisDay(string, now) or parseExactDay(string, now) or parseIso8601Date(string)

    format: (date, opts) ->
        opts = today: @today() unless opts
        diff = Math.floor((date * 1 - opts.today * 1) / 60 / 60 / 24 / 1000)
        
        switch diff
            when -7, -6, -5, -4, -3, -2 then "Last #{DAY_NAMES[date.getDay()]}"
            when -1 then 'Yesterday'
            when 0 then 'Today'
            when 1 then 'Tomorrow'
            when 2, 3, 4, 5, 6, 7 then "This #{DAY_NAMES[date.getDay()]}"
            else [ date.getDate(), titleize(MONTH_NAMES[date.getMonth() * 2]), (date.getYear() + 1900) ].join(' ')

    today: -> new Date()
)()