{
	List<Entity> _entfound = world.getEntitiesWithinAABB(Entity.class, new AxisAlignedBB(${input$x}, ${input$y}, ${input$z}, ${input$x}, ${input$y}, ${input$z}).grow(${input$range} / 2d), e -> true)
		.stream().sorted(Comparator.comparing(_entcnd -> _entcnd.getDistanceSq(${input$x}, ${input$y}, ${input$z}))).collect(Collectors.toList());
	for (Entity entityiterator : _entfound) {
		${statement$foreach}
	}
}
