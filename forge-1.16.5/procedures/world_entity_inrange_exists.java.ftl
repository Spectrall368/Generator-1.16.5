(!world.getLoadedEntitiesWithinAABB(${generator.map(field$entity, "entities", 0)}.class,
	new AxisAlignedBB(Vector3d.ZERO, Vector3d.ZERO).offset(new Vector3d(${input$x}, ${input$y}, ${input$z})).grow(${input$range} / 2d), e -> true)
	.isEmpty())