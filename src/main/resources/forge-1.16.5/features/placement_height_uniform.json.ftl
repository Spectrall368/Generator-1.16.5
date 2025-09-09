.withPlacement(Placement.RANGE.configure(new TopSolidRangeConfig(${input$min}, ${input$min == input$max ? (input$max - 1) : (input$max - input$min), ${input$max})))
