(!world.getLoadedEntitiesWithinAABB(${generator.map(field$entity, "entities", 0)}.class,
	new AxisAlignedBB(${input$x} - ${input$range} / 2.0D, ${input$y} - ${input$range} / 2.0D, ${input$z} - ${input$range} / 2.0D, ${input$x} + ${input$range} / 2.0D, ${input$y} + ${input$range} / 2.0D, ${input$z} + ${input$range} / 2.0D), e -> true)
	.isEmpty())
