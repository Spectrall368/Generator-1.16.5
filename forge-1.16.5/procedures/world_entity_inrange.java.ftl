((Entity) world.getLoadedEntitiesWithinAABB(${generator.map(field$entity, "entities", 0)}.class,
	new AxisAlignedBB(${input$x} - ${input$range} / 2.0D, ${input$y} - ${input$range} / 2.0D, ${input$z} - ${input$range} / 2.0D, ${input$x} + ${input$range} / 2.0D, ${input$y} + ${input$range} / 2.0D, ${input$z} + ${input$range} / 2.0D), e -> true)
	.stream().sorted(new Object() {
		Comparator<Entity> compareDistOf(double _x, double _y, double _z) {
			return Comparator.comparingDouble(_entcnd -> _entcnd.getDistanceSq(_x, _y, _z));
		}
	}.compareDistOf(${input$x}, ${input$y}, ${input$z})).findFirst().orElse(null))
