#https://github.com/amrrs/sample_revenue_dashboard_shiny/blob/master/app.R
#https://www.freecodecamp.org/news/build-your-first-web-app-dashboard-using-shiny-and-r-ec433c9f3f6c/

library(shiny)
library(shinydashboard)

# Define UI for application that draws a histogram
header <- dashboardHeader(title = "Vanilla Fern Dashboard")  

#Sidebar content of the dashboard
sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
        menuItem("Visit-us", icon = icon("send",lib='glyphicon'), 
                 href = "https://www.salesforce.com")
    )
)


frow1 <- fluidRow(
    valueBoxOutput("value1")
    ,valueBoxOutput("value2")
    ,valueBoxOutput("value3")
)

frow2 <- fluidRow(
    
    box(
        title = "Revenue per Account"
        ,status = "primary"
        ,solidHeader = TRUE 
        ,collapsible = TRUE 
        ,plotOutput("revenuebyPrd", height = "300px")
    )
    
    ,box(
        title = "Revenue per Product"
        ,status = "primary"
        ,solidHeader = TRUE 
        ,collapsible = TRUE 
        ,plotOutput("revenuebyRegion", height = "300px")
    ) 
    
)



# combine the two fluid rows to make the body
body <- dashboardBody(frow1, frow2)

#completing the ui part with dashboardPage
ui <- dashboardPage(title = 'This is my Page title', header, sidebar, body, skin='green')


# ui <- fluidPage(
# 
#     # Application title
#     titlePanel("Vanilla Fern Dashaboard"),
# 
#         # Show a plot of the generated distribution
#         mainPanel(
#             valueBoxOutput("value1")
#         )
#     )


# Define server logic required to draw a histogram
server <- function(input, output) {
    
    #data
    tot_inc <- income %>% summarise(sales = sum(sale_price * qty_how_many_sold))
    tot_exp <- expense %>% 
        replace_na(list(any_shipping = 0)) %>%
        mutate(total_expense = (qty * price) + any_shipping) %>%
        summarise(sum(total_expense))
    profit <- tot_inc - tot_exp
    
    output$value1 <- renderValueBox({
        valueBox(
            formatC(tot_inc, format="d", big.mark=','),
            subtitle = "Total Sales",
            icon = icon("stats",lib='glyphicon'),
            color = "green"
        )
    })
    
    output$value2 <- renderValueBox({
        valueBox(
            formatC(tot_exp, format="d", big.mark=','),
            subtitle = "Total Expenses",
            icon = icon("stats",lib='glyphicon'),
            color = "light-blue"
        )
    })
    
    output$value3 <- renderValueBox({
        valueBox(
            formatC(profit, format="d", big.mark=','),
            subtitle = "Profit",
            icon = icon("stats",lib='glyphicon'),
            color = "yellow"
        )
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
