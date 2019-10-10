usa = fread("/Users/auke/repos/wp4-cow-conversions/clioinfra/Exchange_Rates_USA-historical.xlsx.csv")

ex = merge(usa, usa, by = "year", allow.cartesian = TRUE)

ex[, countries := paste0(country_name.y, " currency in currency of ", country_name.x)]
ex[, exchange_rate := value.x / value.y]

# check sanity
ex[country_name.x == c("Netherlands") & country_name.y == "Belgium", .(year, countries, exchange_rate)]
plot(ex[country_name.x == c("Netherlands") & country_name.y == "Belgium", .(year, exchange_rate)])
