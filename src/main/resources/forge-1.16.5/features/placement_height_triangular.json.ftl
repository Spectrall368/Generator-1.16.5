<#assign depthAvg_baseline = (input$min + input$max) / 2>
<#assign depthAvg_spread = (input$max - input$min + 2) / 2>
.withPlacement(Placement.DEPTH_AVERAGE.configure(new DepthAverageConfig((${depthAvg_baseline?round}, ${depthAvg_spread?round}))))