(5 + ${input$min}) > (5 + ${input$max}) ? (5 + ${input$min}) : (random.nextInt((5 + ${input$max}) - (5 + ${input$min}) + 1) + (5 + ${input$min}))
