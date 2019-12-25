-- Load companies on server load.

Companies = {}

AddEvent("database:connected", function()
    mariadb_query(sql, "SELECT * FROM companies;", function()
        for i=1,mariadb_get_row_count() do
            local company = mariadb_get_assoc(i)
            local id = tonumber(company['id'])

            Companies[id] = { name = company['name'], money = tonumber(company['money']) }
        end
    end)
end)
