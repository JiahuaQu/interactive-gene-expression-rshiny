#BiocManager::install("shiny")
library(shiny)

#BiocManager::install("tidyverse")
library(tidyverse)
# read in gene expression table
# mydata <- read_csv("data/gene_expression_table.csv")
# mydata$group_1_mean <- rowMeans(mydata[,2:4])
# mydata$group_2_mean <- rowMeans(mydata[,5:7])
# 
# #BiocManager::install("plotrix") # use std.error to calculate standard error
# library(plotrix)
# mydata$group_1_se <- apply(mydata[,2:4],1,std.error)
# mydata$group_2_se <- apply(mydata[,5:7],1,std.error)
# 
# mydata$pval <- sapply(1:nrow(mydata), function(i) t.test(as.numeric(unlist(mydata[i,2:4])), as.numeric(unlist(mydata[i,5:7])))[c("p.value")])
# 
# # long table
# mydata_long <- mydata[,1:7] %>%
#   pivot_longer(sample_1:sample_6,
#                names_to = "sample",
#                values_to = "expression")
# 
# # group
# group <- data.frame(sample=paste0("sample_",seq(1:6)),group=c(rep("group_1",3),rep("group_2",3)))
# 
# # join
# mydata_long <- mydata_long %>%
#   left_join(group, by="sample")
# 
# write_csv(mydata_long,"./data/mydata_long.csv")

mydata_long <- read_csv("data/mydata_long.csv")

# plot
# selected_gene <- "Gene_1"
# p1 <- mydata_long %>%
#   filter(gene_name == selected_gene) %>%
#   ggplot(mapping=aes(x=group, y=expression, fill=group)) +
#   geom_bar(stat = "summary", fun=mean, color='black', position = "dodge") +   # "summary" and mean function
#   scale_fill_manual(values = c('blue', 'red')) +
#   stat_summary(geom = "errorbar", fun.data = 'mean_se', width=0.5, linewidth=0.8) +
#   labs(x=selected_gene, y="Gene expression") +
#   theme_classic() +
#   theme(legend.position = "none")
# p1

# # stat
# sum_stat <- mydata_long %>%
#   group_by(gene_name, group) %>%
#   summarise(
#     count = n(),
#     mean = round(mean(expression, na.rm = TRUE),2),
#     sem = round(std.error(expression, na.rm = TRUE),2)
#   )
# 
# # paired t.test
# pval <- mydata_long %>%
#   group_by(gene_name) %>%
#   summarise(
#     p.val = t.test(expression~group, paired=F)$p.value
#   )
# 
# sum_stat_p <- left_join(sum_stat, pval, by="gene_name")


# Define UI ----
ui <- fluidPage(
  titlePanel("Comparison of expression of maternal effect genes across species"),
  
  sidebarLayout(
    sidebarPanel(
      h2("Maternal effect genes"),
      selectInput("gene", h3("Select gene"), 
                  choices = list("Gene_1", 
                                 "Gene_2",
                                 "Gene_3"), 
                  selected = "Gene_1")
      ),
    
    
    mainPanel(
      h2("Expression across species"),
      img(src = "UCSF_logo.png", height = 292, width = 452),
      br(),
      br(),
      textOutput("selected_gene"),
      plotOutput("bar_plot")
      )
  )
)

# Define server logic ----
server <- function(input, output) {
  output$selected_gene <- renderText({ 
    paste0("You have selected this: ",input$gene)
  })
  
  output$bar_plot <- renderPlot({
    selected_gene <- input$gene
    mydata_long %>%
      filter(gene_name == selected_gene) %>%
      ggplot(mapping=aes(x=group, y=expression, fill=group)) +
      geom_bar(stat = "summary", fun=mean, color='black', position = "dodge") +   # "summary" and mean function
      scale_fill_manual(values = c('blue', 'red')) +
      stat_summary(geom = "errorbar", fun.data = 'mean_se', width=0.5, linewidth=0.8) +
      labs(x=selected_gene, y="Gene expression") +
      theme_classic() +
      theme(legend.position = "none")

  })
  
  
}

# Run the app ----
shinyApp(ui = ui, server = server)