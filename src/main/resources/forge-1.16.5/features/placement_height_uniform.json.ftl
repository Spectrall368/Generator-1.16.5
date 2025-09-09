.withPlacement(Placement.RANGE.configure(new TopSolidRangeConfig(${input$min}, ${input$min == input$max ? (input$max?number - 1) : (input$max?number - input$min?number), ${input$max})))
