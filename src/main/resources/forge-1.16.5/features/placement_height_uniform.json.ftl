.withPlacement(Placement.RANGE.configure(new TopSolidRangeConfig(${input$min}, <#if input$min == input$max> ${input$max} - 1<#else>${input$max} - ${input$min}</#if>, ${input$max})))
