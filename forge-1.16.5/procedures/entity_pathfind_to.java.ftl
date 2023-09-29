if (${input$entity} instanceof MobEntity)
	((MobEntity) ${input$entity}).getNavigator().tryMoveToXYZ(${input$x}, ${input$y}, ${input$z}, ${input$speed});
