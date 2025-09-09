<#assign depthAvg_baseline = (input$min?number + input$max?number) / 2>
<#assign depthAvg_spread = (input$max?number - input$min?number + 2) / 2>
.withPlacement(Placement.DEPTH_AVERAGE.configure(new DepthAverageConfig((${depthAvg_baseline?round}, ${depthAvg_spread?round}))))