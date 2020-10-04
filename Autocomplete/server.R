library(shiny)
library(data.table)
library(wordcloud)
tri.model<-fread("export_trigram.csv")
shinyServer(function(input, output,session) {
        
        
        model.tri.pred<-function(words){
                w=unlist(strsplit(tolower(words)," "))
                
                n1=length(w)
                if (n1==1){
                        cg=sprintf("%s%s", "<s>_", w[n1])
                } else
                        cg=sprintf("%s%s%s", w[n1-1], "_" ,w[n1])
                
                pred.tri<-tri.model[bi.feature==cg]
                
                if (nrow(pred.tri) == 0){
                        if (n1==1){
                                cg=sprintf("%s%s", "<s>_", "<unk>")
                                
                        } else{
                                cg=sprintf("%s%s%s", "<unk>", "_" , w[n1])
                        }
                        
                        pred.tri<-tri.model[bi.feature==cg]
                        
                        if (nrow(pred.tri) == 0){
                                cg=sprintf("%s%s%s", w[n1-1], "_" , "<unk>")
                                
                                pred.tri<-tri.model[bi.feature==cg]
                                
                                if (nrow(pred.tri) == 0){
                                        cg=sprintf("%s%s%s", "<unk>", "_" , "<unk>")
                                        
                                        pred.tri<-tri.model[bi.feature==cg]
                                        
                                }
                                
                        }
                        
                }
                pred<-pred.tri[order(MLE,decreasing=TRUE),][]
                return(pred)
                
        }
        
        values <- reactiveValues(Data = NULL,newtext=NULL)
        
        
        
        observeEvent(input$caption, {
                
                values$newtext <- input$caption
                
        })
        
        observeEvent(input$caption, {
                
                if (input$caption==""){
                        values$Data <-"<s1>"
                }
                else
                        values$Data <- input$caption
                
        })
        
        prediction<- reactive({
                
                (model.tri.pred(values$Data))[,c("tri.feature","MLE")][!tri.feature == "<unk>" & !tri.feature == "</s>",]
                
        })
        
        
        
        output$state <- renderUI({
                selectInput("state", 
                            label = "Autocomplete", 
                            selected = NULL,
                            choices = prediction()[1:15,1],
                            multiple = TRUE,
                            selectize = TRUE
                            
                )
        })
        
        observeEvent(input$state, {
                
                updateTextInput(session, "caption", value = paste(values$newtext,input$state))
                
        })
        
        
        output$value <- renderText({ values$newtext })
        
        wordcloud_rep <- repeatable(wordcloud)
        
        
        
        
        output$plot <- renderPlot({
                v <- data.table(words=prediction()[,1],freq=prediction()[,2])   
                wordcloud_rep(v$words, v$freq, scale=c(7,0.5),
                              min.freq = 1, max.words=50,
                              colors=brewer.pal(8, "Dark2"))
        })
        
})
