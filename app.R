library(shiny)
library(tidyverse)

# Load preprocessed demonstration data.
# See prepare_example_data.R for the transformation from the wide input table.
mydata_long <- read_csv("data/mydata_long.csv", show_col_types = FALSE)

gene_choices <- sort(unique(mydata_long$gene_name))

ui <- fluidPage(
  titlePanel("Interactive Gene Expression Visualization"),
  sidebarLayout(
    sidebarPanel(
      h3("Explore gene expression"),
      selectInput(
        inputId = "gene",
        label = "Select a gene",
        choices = gene_choices,
        selected = gene_choices[[1]]
      ),
      helpText("Demo data are synthetic and are included only to illustrate the application workflow.")
    ),
    mainPanel(
      h3(textOutput("selected_gene", inline = TRUE)),
      plotOutput("bar_plot", height = "420px")
    )
  )
)

server <- function(input, output, session) {
  selected_data <- reactive({
    req(input$gene)
    mydata_long %>% filter(gene_name == input$gene)
  })

  output$selected_gene <- renderText({
    paste("Selected gene:", input$gene)
  })

  output$bar_plot <- renderPlot({
    selected_data() %>%
      ggplot(aes(x = group, y = expression, fill = group)) +
      stat_summary(fun = mean, geom = "bar", color = "black", width = 0.7) +
      stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.25, linewidth = 0.8) +
      labs(
        x = NULL,
        y = "Gene expression",
        title = paste("Expression of", input$gene, "by group")
      ) +
      theme_classic() +
      theme(legend.position = "none")
  })
}

shinyApp(ui = ui, server = server)
